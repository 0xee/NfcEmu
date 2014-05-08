-------------------------------------------------------------------------------
-- Title      : Testbench for design "FrameDecoder"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : FrameDecoder_tb.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-12-26
-- Last update: 2014-03-18
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-12-26  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library nfc;
use nfc.Nfc.all;

library global;
use global.Global.all;
-------------------------------------------------------------------------------

entity tbFrameDecoder is

end entity tbFrameDecoder;

-------------------------------------------------------------------------------

architecture Bhv of tbFrameDecoder is

  -- component generics
  constant gId : std_ulogic_vector := x"AB";

  -- component ports
  signal inResetAsync : std_ulogic;
  signal iRxBit       : std_ulogic;
  signal iValid       : std_ulogic;
  signal iEof         : std_ulogic;
  signal oRxData      : aDataPort;

  constant cSof : std_ulogic := '1';
  constant cEof : std_ulogic := '0';

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture Bhv

  -- component instantiation
  DUT : entity nfc.FrameDecoder
    generic map (
      gId => gId)
    port map (
      iClk         => Clk,
      inResetAsync => inResetAsync,
      iRxBit       => iRxBit,
      iValid       => iValid,
      iEof         => iEof,
      oRxData      => oRxData);

  -- clock generation
  Clk <= not Clk after 10 ns;

  inResetAsync <= '0' after 0 ns,
                  '1' after 20 ns;

  -- waveform generation
  WaveGen_Proc : process
    procedure SendBit (constant cBit : std_ulogic) is
    begin
      iValid <= '1';
      iRxBit <= cBit;
      wait until rising_edge(Clk);
      iValid <= '0';
    end procedure;

    type aByteVector is array (natural range <>) of std_ulogic_vector(7 downto 0);

    procedure SendBits (constant cMsg : in std_ulogic_vector) is
    begin
      for i in 0 to cMsg'length-1 loop
        SendBit(cMsg(i));
        wait until rising_edge(Clk);
      end loop;  -- i
    end procedure;
      
  begin
    -- insert signal assignments here
    
    wait until inResetAsync = '1';


    wait until Clk = '1';
  end process WaveGen_Proc;

  

end architecture Bhv;
