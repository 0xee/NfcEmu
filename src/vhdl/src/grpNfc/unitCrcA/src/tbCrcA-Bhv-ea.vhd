-------------------------------------------------------------------------------
-- Title      : Testbench for design "CrcA"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : CrcA_tb.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-08-29
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
-- 2013-08-29  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library nfc;

-------------------------------------------------------------------------------

entity tbCrcA is

end entity tbCrcA;

-------------------------------------------------------------------------------

architecture Bhv of tbCrcA is


  -- component ports
  signal iClk         : std_ulogic;
  signal inResetAsync : std_ulogic;
  signal iSyncReset   : std_ulogic;
  signal iDin         : std_ulogic_vector(7 downto 0);
  signal iValid       : std_ulogic;
  signal oCheckSum    : std_ulogic_vector(15 downto 0);

  -- clock
  signal Clk     : std_logic         := '1';
  signal Count   : natural;
  constant cData : std_ulogic_vector(55 downto 0) := x"937088058a2225";
  signal reversed : std_ulogic_vector(15 downto 0);
begin  -- architecture Bhv

  -- component instantiation
  DUT : entity nfc.CrcA
    port map (
      iClk         => Clk,
      inResetAsync => inResetAsync,
      iSyncReset   => iSyncReset,
      iDin         => iDin,
      iValid       => iValid,
      oCrcSum    => oCheckSum);

  -- clock generation
  Clk          <= not Clk after 10 ns;
  inResetAsync <= '0'     after 0 ns,
                  '1' after 20 ns;
  iSyncReset <= '0';

  rev: for i in 0 to 15 generate
    reversed(i) <= oCheckSum(15-i);
  end generate rev;
  
  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    iValid <= '0';
    iDin   <= (others => '0');
    Count  <= 0;
    wait for 100 ns;
    wait until rising_edge(Clk);
    report integer'image(cData'left) & " " & integer'image(cData'right);
    for i in cData'length/8-1 downto 0 loop
      iDin   <= cData(i*8+7 downto i*8);
      iValid <= '1';
      Count  <= i;
      wait until rising_edge(Clk);
    end loop;
    iValid <= '0';
    iDin <= (others => '0');
    for i in 0 to 2-1 loop
      Count <= i;
      wait until rising_edge(Clk);
    end loop;  -- i

    report "End of simulation" severity failure;
    wait;
  end process WaveGen_Proc;

end architecture Bhv;
