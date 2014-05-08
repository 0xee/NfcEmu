-------------------------------------------------------------------------------
-- Title      : Testbench for design "Iso14443ARx"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tbIso14443ARx.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-05-09
-- Last update: 2013-09-22
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-05-09  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library dsp;
use dsp.FilterCoefficients.all;

-------------------------------------------------------------------------------

entity tbDigitalFir is

end tbDigitalFir;

-------------------------------------------------------------------------------

architecture Bhv of tbDigitalFir is

  constant cClkFreq      : natural    := 8*13560e3;
  constant cClkPeriod    : time       := 1 sec / cClkFreq;
  -- component ports
  signal iClk            : std_ulogic := '1';
  signal inResetAsync    : std_ulogic;
  signal iDin            : std_ulogic_vector(11 downto 0);
  signal oDout, oDigDout : std_ulogic_vector(12 downto 0);

  --constant cCoeffs : aCoeffArray := CalcBandpassCoeffs(0.0, 1.0/8.0, 15);

  constant cCoeffs : aCoeffArray := (-1.0, -1.0, -1.0, -1.0,
                                     1.0, 1.0, 1.0, 1.0,
                                     1.0, 1.0, 1.0, 1.0,
                                     -1.0, -1.0, -1.0, -1.0);

  signal sEnd : std_ulogic := '0';

  component Fir
    generic (
      gCoeffs : aCoeffArray);
    port (
      iClk         : in  std_ulogic;
      inResetAsync : in  std_ulogic;
      iEnable      : in  std_ulogic;
      iDin         : in  std_ulogic_vector;
      oDout        : out std_ulogic_vector;
      iValid       : in  std_ulogic;
      oValid       : out std_ulogic);
  end component;
begin  -- Bhv

  -- component instantiation
  DUT_1 : Fir
    generic map (
      gCoeffs => cCoeffs)
    port map (
      iClk         => iClk,
      iEnable      => '1',
      inResetAsync => inResetAsync,
      iDin         => iDin,
      iValid       => '1',
      oDout        => oDout,
      oValid       => open);

  DUT_2 : entity dsp.DigitalFir
    generic map (
      gCoeffs => cCoeffs)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iEnable      => '1',
      iDin         => iDin,
      oDout        => oDigDout,
      iValid       => '1',
      oValid       => open);

  -- clock generation
  iClk <= not iClk after cClkPeriod/2;



  Stimuli : process
    file inputFile  : text;
    variable vInput : integer;
    variable vLine  : line;
  begin
    inResetAsync <= '0' after 0 ns,
                    '1' after 2*cClkPeriod;
    wait for 3*cClkPeriod;

    --Open the file in read mode.
    file_open(inputFile, "../data/fir_stimuli.txt", read_mode);

    while (not ENDFILE(inputFile)) loop
      readline(inputFile, vLine);       --read the current line.
      --extract the real value from the read line and store it in the variable.
      read(vLine, vInput);
      iDin <= std_ulogic_vector(to_signed(vInput, iDin'length));

      wait until rising_edge(iClk);

--      report "in: " & integer'image(to_integer(signed(iDin)));
      
    end loop;


    wait until rising_edge(iClk);
    report "end of input";
    file_close(inputFile);              --close the file after reading.

    sEnd <= '1';

--    assert false report "End of simulation" severity failure;

    wait;
  end process Stimuli;

  Results : process
    file outFile   : text;
    variable vLine : line;
  begin

    file_open(outFile, "../data/fir_results.txt", write_mode);

    while sEnd = '0' loop
      
      wait until rising_edge(iClk);

      write(vLine, to_integer(signed(oDout)));
      writeline(outFile, vLine);
      
    end loop;

    wait;
  end process Results;

  DigResults : process
    file outFile   : text;
    variable vLine : line;
  begin

    file_open(outFile, "../data/dfir_results.txt", write_mode);

    while sEnd = '0' loop
      
      wait until rising_edge(iClk);

      write(vLine, to_integer(signed(oDigDout)));
      writeline(outFile, vLine);
      
    end loop;

    wait;
  end process DigResults;


  

end Bhv;
