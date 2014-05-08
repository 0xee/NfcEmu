-------------------------------------------------------------------------------
-- Title      : ControlReg
-- Project    : 
-------------------------------------------------------------------------------
-- File       : ControlReg-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-07-29
-- Last update: 2014-04-27
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Generic control/status register using DataPorts for communication
--              interface connected to a host.
--
--              If gCmdRead is received, current register values/status bits are sent to the host
--              If gCmdWrite is received, the following incoming data is
--              written to the register
--
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-07-29  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library nfc;
--use nfc.DebugCodes.all;

library global;
use global.Global.all;

entity ControlReg is
  
  generic (
    gCmdRead  : std_ulogic_vector;
    gCmdWrite : std_ulogic_vector;

    gInitCfg  : std_ulogic_vector;
    gReadBack : std_ulogic_vector;
    gId       : std_ulogic_vector);


  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iDin         : in  aDataPort;
    oAckIn       : out std_ulogic;
    oDout        : out aDataPort;
    iAckOut      : in  std_ulogic;

    oCtrl      : out std_ulogic_vector(gInitCfg'range);
    iStatus    : in  std_ulogic_vector(gInitCfg'range);
    oUpdateCfg : out std_ulogic;
    oCfgValid  : out std_ulogic
    );

end ControlReg;

architecture Rtl of ControlReg is

  type aState is (Idle, ShiftIn, ShiftOut, UpdateCfg, WaitForEof, WriteError);
  constant cCfgLen : natural := gInitCfg'length/8;

  type aRegSet is record
    State       : aState;
    CfgBuffer   : std_ulogic_vector(gInitCfg'range);
    IoReg       : std_ulogic_vector(gInitCfg'range);
    Idx         : natural range 0 to cCfgLen-1;
    EofReceived : std_ulogic;
    UpdateCfg   : std_ulogic;
    CfgValid    : std_ulogic;
  end record;

  signal R, NextR : aRegSet;

  constant cRegInitVal : aRegSet := (State       => Idle,
                                     CfgBuffer   => gInitCfg,
                                     IoReg       => (others => '0'),
                                     Idx         => 0,
                                     CfgValid    => '0',
                                     EofReceived => '0',
                                     UpdateCfg   => '0'
                                     );

  signal sRegReadVal : std_ulogic_vector(gReadBack'range);
  
begin  -- Rtl

  assert gReadBack'length = gInitCfg'length report "Generic length mismatch" severity failure;

  oCtrl       <= R.CfgBuffer;
  oCfgValid   <= R.CfgValid;
  oUpdateCfg  <= R.UpdateCfg;
  sRegReadVal <= (R.CfgBuffer and gReadBack) or (iStatus and not gReadBack);

  Comb : process (R, iDin, iAckOut, iStatus, sRegReadVal)
    variable vAcceptDin : boolean;
  begin  -- process Comb
    
    NextR           <= R;
    oAckIn          <= '0';
    InitPort(oDout);
    oDout.Id        <= gId;
    NextR.UpdateCfg <= '0';

    case R.State is
      
      when Idle =>
        if iDin.Valid then
          oAckIn            <= '1';
          NextR.Idx         <= 0;
          NextR.EofReceived <= '0';
          if iDin.Data = gCmdWrite then
            NextR.State <= ShiftIn;
          elsif iDin.Data = gCmdRead then
            NextR.State <= ShiftOut;
            NextR.IoReg <= sRegReadVal;
          else
            NextR.State <= WaitForEof;
            assert false report "Invalid command" severity error;
          end if;
        end if;

      when ShiftIn =>

        if iDin.Valid then
          NextR.IoReg <= iDin.Data & R.IoReg(R.IoReg'left downto R.IoReg'right+8);
          oAckIn      <= '1';
          if R.Idx = cCfgLen-1 then
            NextR.Idx         <= 0;
            NextR.EofReceived <= iDin.Eof;
            NextR.State       <= UpdateCfg;
          elsif iDin.Eof = '1' then
            NextR.State <= WriteError;
          else
            NextR.Idx <= R.Idx + 1;
          end if;
          
        end if;
        
      when ShiftOut =>

        Send(oDout, R.IoReg(7 downto 0));
        if R.Idx = cCfgLen-1 then
          oDout.Eof <= '1';
        end if;

        if iAckOut then
          NextR.IoReg(R.IoReg'left-8 downto 0) <= R.IoReg(R.IoReg'left downto 8);
          if R.Idx = cCfgLen-1 then
            NextR.Idx   <= 0;
            NextR.State <= Idle;
          else
            NextR.Idx <= R.Idx + 1;
          end if;
          
        end if;

      when UpdateCfg =>
        NextR.UpdateCfg <= '1';
        NextR.CfgBuffer <= R.IoReg;
        NextR.CfgValid  <= '1';

        if R.EofReceived then
          NextR.EofReceived <= '0';
          NextR.Idx         <= 0;
          NextR.State       <= Idle;--ShiftOut;
        else
          NextR.State <= WaitForEof;
        end if;

      when WaitForEof =>
        oAckIn <= iDin.Valid;
        if iDin.Valid and iDin.Eof then
          NextR.Idx   <= 0;
--          NextR.IoReg <= R.CfgBuffer;
          NextR.State <= Idle;--ShiftOut;
        end if;

      when WriteError =>
        oDout.Data  <= std_ulogic_vector(to_unsigned(R.Idx, oDout.Data'length));
        oDout.Id    <= SetIdFlags(gId, "111");
        oDout.Valid <= '1';
        if iAckOut then
          NextR.State       <= Idle;
          NextR.Idx         <= 0;
          NextR.EofReceived <= '0';
        end if;

      when others => null;

    end case;
    
  end process Comb;

  Reg : process (iClk, inResetAsync)
  begin  -- process Reg
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      R <= cRegInitVal;
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      R <= NextR;
    end if;
  end process Reg;

  
end Rtl;
