-------------------------------------------------------------------------------
-- Title      : tbControlReg
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tbControlReg-Bhv-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2014-04-03
-- Last update: 2014-04-23
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-04-03  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library misc;

library global;
use global.Global.all;

entity tbControlReg is

end entity tbControlReg;

architecture Bhv of tbControlReg is

  constant cCfgLen : natural := 22;

  subtype aCfgReg is std_ulogic_vector(cCfgLen*8-1 downto 0);

  constant cClkPeriod    : time    := 10 ns;
  constant cInit         : aCfgReg := x"AABBCCDDEEFF00102030405060708090A0B0C0D0E0F0";
  constant cReadBackMask : aCfgReg := x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";

  constant cCmdRead  : std_ulogic_vector := x"01";
  constant cCmdWrite : std_ulogic_vector := x"02";

  signal iClk         : std_ulogic := '1';
  signal inResetAsync : std_ulogic := '0';
  signal iDin         : aDataPort;
  signal oAckIn       : std_ulogic;
  signal oDout        : aDataPort;
  signal iAckOut      : std_ulogic;
  signal oCtrl        : aCfgReg;
  signal iStatus      : aCfgReg;
  signal oUpdateCfg   : std_ulogic;
  signal oCfgValid    : std_ulogic;

  signal sEndOfSim : std_ulogic := '0';
  signal sToggle : std_ulogic := '0';
begin  -- architecture Bhv

  iClk         <= (not iClk) after cClkPeriod/2 when sEndOfSim = '0'
                  else '0';
  
  inResetAsync <= '1'                          after 2*cClkPeriod;

  tg: process (iClk, inResetAsync) is
  begin  -- process tg
    if rising_edge(iClk) then        -- rising clock edge
      sToggle <= not sToggle;
    end if;
  end process tg;
  
  ControlReg_1 : entity work.ControlReg
    generic map (
      gCmdRead  => cCmdRead,
      gCmdWrite => cCmdWrite,
      gInitCfg  => cInit,
      gReadBack => cReadBackMask,
      gId       => x"CC")
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => iDin,
      oAckIn       => oAckIn,
      oDout        => oDout,
      iAckOut      => iAckOut,
      oCtrl        => oCtrl,
      iStatus      => iStatus,
      oUpdateCfg   => oUpdateCfg,
      oCfgValid    => oCfgValid);


  iAckOut <= oDout.Valid and sToggle;
  
  Sender : process is

    procedure WriteCfg (constant cCfg : std_ulogic_vector) is
      constant cPacket : std_ulogic_vector(cCfg'length+7 downto 0) :=  cCfg & cCmdWrite;
    begin
      report "Writing cfg: " & ToHex(cPacket);
      SendPacket(iDin, oAckIn, iClk, cPacket);
      wait until rising_edge(iClk) and oCfgValid = '1';    
    end;

    procedure ReadCfg (variable vCfg : out std_ulogic_vector) is
      constant cPacket : std_ulogic_vector := cCmdRead;
    begin
      SendPacket(iDin, oAckIn, iClk, cPacket);
      for i in 0 to cCfgLen-1 loop
        wait until rising_edge(iClk) and DataValid(oDout) and iAckOut = '1';
        vCfg(8*(i+1)-1 downto i*8) := oDout.Data;
      end loop;  -- i
    end;

    procedure SetStatus (constant cStatus : std_ulogic_vector) is
    begin
      iStatus <= cStatus;
      wait until rising_edge(iClk);
    end;

    
    variable vCfg, vStatus, vSetStatus : std_ulogic_vector(cCfgLen*8-1 downto 0);    
  begin
    iDin.Id <= x"00";
    InitPort(iDin);
    
    SetStatus(x"00000000000000000000000000000000000000000000");
    vCfg := x"AABBCCDDEE112233441122334411223344A0B0C0D0E0";
    WriteCfg(vCfg);

    assert oCtrl = vCfg report "Error writing configuration" severity failure;
    
    vSetStatus := x"AA4455667788445566778844556677884455667788AA";
    SetStatus(vSetStatus);
    
    ReadCfg(vStatus);
    assert ((vCfg and cReadBackMask) or (vSetStatus and not cReadBackMask)) = vStatus report "Error reading configuration" severity failure;

    wait for 20 ns;
    sEndOfSim <= '1';
    wait;
  end process Sender;

  
  

end architecture Bhv;
