-------------------------------------------------------------------------------
-- Title      : tbSimWatchdog
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tbSimWatchdog-Bhv-ea.vhd
-- Author     : Lukas Schuller  <lukas@0xee.eu>
-- Company    : 
-- Created    : 2014-04-16
-- Last update: 2014-04-16
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-04-16  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity tbSimWatchdog is

end entity tbSimWatchdog;

architecture Bhv of tbSimWatchdog is

  signal s        : std_ulogic := '0';
  signal sTimeout : std_ulogic;
  signal sEndOfSim : std_ulogic := '0';
begin  -- architecture Bhv

  SimWatchdog_1 : entity work.SimWatchdog
    generic map (
      gTimeout => 10 us,
      gTimeoutIsFailure => false)
    port map (
      iEnable => not sEndOfSim,
      iToggleReset => s,
      oTimeout     => sTimeout);

  p : process is
    constant cDel : time_vector := (3 us, 8 us, 10 us, 5 us, 12 us, 5 us, 7 us);
  begin  -- process p
    
    for i in cDel'range loop
      report "Next delay is " & time'image(cDel(i));
      wait for cDel(i);

      assert (cDel(i) <= 10 us or sTimeout = '0') or
        (cDel(i) > 10 us or sTimeout = '1')
        report "Watchdog error"
        severity failure;

      s <= not s;
      
    end loop;  -- i
    sEndOfSim <= '1';
    report "End of simulation";
    wait;
  end process p;
  
end architecture Bhv;
