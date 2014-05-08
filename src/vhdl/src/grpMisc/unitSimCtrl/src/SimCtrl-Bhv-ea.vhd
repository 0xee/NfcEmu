-------------------------------------------------------------------------------
-- Title      : SimCtrl
-- Project    : 
-------------------------------------------------------------------------------
-- File       : SimCtrl-Bhv-ea.vhd
-- Author     : Lukas Schuller  <lukas@0xee.eu>
-- Company    : 
-- Created    : 2014-05-01
-- Last update: 2014-05-01
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Simulation controler
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-05-01  1.0      lukas	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SimCtrl is
  
  generic (
    gClkFreq     : natural := 100e6;
    gResetCycles : natural := 10;
    gWdtTimeout  : time    := 1 ms);

  port (
    oClk      : out std_ulogic;
    onReset   : out std_ulogic;
    iEndOfSim : in  std_ulogic;
    iWdtReset : in  std_ulogic);

end entity SimCtrl;

architecture Bhv of SimCtrl is

  constant cClkPeriod : time := 1 sec / gClkFreq;
  
  signal sClk : std_ulogic := '1';
  signal snReset : std_ulogic := '0';
  
begin  -- architecture Bhv

  ClkGen: sClk <= (not sClk) and (not iEndOfSim) after cClkPeriod/2;

  
  ResetGen: process is
  begin  -- process ResetGen

    wait for gResetCycles*cClkPeriod;
    snReset <= '1';
    wait;
  end process ResetGen;
  
  SimWatchdog_1: entity work.SimWatchdog
    generic map (
      gTimeout          => gWdtTimeout,
      gTimeoutIsFailure => true)
    port map (
      iEnable      => not iEndOfSim,
      iToggleReset => iWdtReset,
      oTimeout     => open);

  oClk <= sClk;
  onReset <= snReset;
  
end architecture Bhv;
