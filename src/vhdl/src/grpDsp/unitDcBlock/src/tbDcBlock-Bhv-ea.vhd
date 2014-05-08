-------------------------------------------------------------------------------
-- Title      : Testbench for design "Iso14443ARx"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tbIso14443ARx.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-05-09
-- Last update: 2014-02-24
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

entity tbDcBlock is

end tbDcBlock;

-------------------------------------------------------------------------------

architecture Bhv of tbDcBlock is

  constant cClkFreq     : natural    := 81360e3;
  constant cClkPeriod   : time       := 1 sec / cClkFreq;
  -- component ports
  signal   iClk         : std_ulogic := '1';
  signal   inResetAsync : std_ulogic;
  signal   iDin         : std_ulogic_vector(11 downto 0);
  signal   oDout        : std_ulogic_vector(11 downto 0);

  signal sEnd : std_ulogic := '0';

begin  -- Bhv

  -- component instantiation
  DUT : entity dsp.DcBlock(Rtl)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => iDin,
      iValid => '1',
      oDout        => oDout,
      oValid => open);

  -- clock generation
  iClk <= not iClk after cClkPeriod/2;


  
  Stimuli : process
    file inputFile  : text;
    variable vInput : integer;
    variable vLine  : line;
  begin
    iDin <= (others => '0');

    inResetAsync <= '0' after 0 ns,
                  '1' after 2*cClkPeriod;
    wait for 3*cClkPeriod;
    
    --Open the file in read mode.
    file_open(inputFile, "../data/stimuli.txt", read_mode);

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

    file_open(outFile, "../data/results.txt", write_mode);

    while sEnd = '0' loop
      
      wait until rising_edge(iClk);

        write(vLine, to_integer(signed(oDout)));
        writeline(outFile, vLine);
        
     end loop;

      wait;
  end process Results;


  

end Bhv;
