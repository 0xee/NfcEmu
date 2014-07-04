-------------------------------------------------------------------------------
-- Title      : UartTx
-- Project    : 
-------------------------------------------------------------------------------
-- File       : UartTx-Rtl-ea.vhd
-- Author     : Lukas Schuller  <lukas@0xee.eu>
-- Company    : 
-- Created    : 2014-05-15
-- Last update: 2014-05-15
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: UART Tx module
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-05-15  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library global;
use global.Global.all;

entity UartTx is
  
  generic (
    gClkFreq  : natural := 40e6;
    gBaudrate : natural := 115200;
    gDataBits : natural := 8);

  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iDin         : in  aDataPort;
    oAckIn       : out std_ulogic;
    oTx          : out std_ulogic
    );
end entity UartTx;



architecture Rtl of UartTx is

  constant cMaxBaudrateCnt : natural := gClkFreq/gBaudrate;

  type aState is (Idle, Start, Data, Stop);

  type aRegSet is record
    State       : aState;
    BaudCounter : unsigned(LogDualis(cMaxBaudrateCnt)-1 downto 0);
    TxData      : std_ulogic_vector(gDataBits-1 downto 0);
    BitCounter  : unsigned(LogDualis(gDataBits)-1 downto 0);
  end record;

  constant cRegInitVal : aRegSet := (State       => Idle,
                                     BaudCounter => (others => '0'),
                                     TxData      => (others => '0'),
                                     BitCounter  => (others => '0'));

  signal R, NextR : aRegSet;
  
begin  -- architecture Rtl

  Comb : process (all) is
  begin  -- process Comb
    NextR <= R;
    oAckIn <= '0';
    oTx <= '1';
    
    if R.BaudCounter = 0 then
      NextR.BaudCounter <= to_unsigned(cMaxBaudrateCnt-1, R.BaudCounter'length);
    else
      NextR.BaudCounter <= R.BaudCounter - 1;
    end if;

    case R.State is
      when Idle =>
        if DataValid(iDin) then
          NextR.BaudCounter <= to_unsigned(cMaxBaudrateCnt-1, R.BaudCounter'length);
          NextR.State       <= Start;
          NextR.TxData      <= iDin.Data;
          oAckIn            <= '1';
        end if;

      when Start =>
        oTx <= '0';
        if R.BaudCounter = 0 then
          NextR.State      <= Data;
          NextR.BitCounter <= to_unsigned(gDataBits-1, R.BitCounter'length);
        end if;
        
      when Data =>
        oTx <= R.TxData(0);
        if R.BaudCounter = 0 then
          NextR.TxData <= '0' & R.TxData(R.TxData'left downto 1);
          if R.BitCounter = 0 then
            NextR.State <= Stop;
          else
            NextR.BitCounter <= R.BitCounter - 1;
          end if;
        end if;
        
      when Stop =>
        if R.BaudCounter = 0 then
          NextR.State <= Idle;
        end if;

        
    end case;
    
  end process Comb;


  Reg : process (iClk, inResetAsync) is
  begin  -- process Reg
    if inResetAsync = '0' then          -- asynchronous reset (active low)
      R <= cRegInitVal;
    elsif rising_edge(iClk) then        -- rising clock edge
      R <= NextR;
    end if;
  end process Reg;
  
end architecture Rtl;
