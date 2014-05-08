-------------------------------------------------------------------------------
-- Title      : SimWatchdog
-- Project    : 
-------------------------------------------------------------------------------
-- File       : SimWatchdog-Bhv-ea.vhd
-- Author     : Lukas Schuller  <lukas@0xee.eu>
-- Company    : 
-- Created    : 2014-04-16
-- Last update: 2014-05-01
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Watchdog for simulations
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-04-16  1.0      lukas   Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity SimWatchdog is
  
  generic (
    gTimeout          : time    := 1 ms;
    gTimeoutIsFailure : boolean := true);

  port (
    iEnable      : in  std_ulogic;
    iToggleReset : in  std_ulogic;
    oTimeout     : out std_ulogic);

end entity SimWatchdog;


architecture Rtl of SimWatchdog is

  signal sExpired : std_ulogic := '0';
begin  -- architecture Rtl

  Wdt1 : process is
    variable vNextDelay : time := gTimeout;
  begin  -- process Wdt
    oTimeout <= '0';

    if iEnable /= '1' then
      wait until iEnable = '1';
    end if;

    wait for vNextDelay;

    sExpired <= not sExpired;
    wait for 0 ns;
    --report "iToggleReset: " & time'image(iToggleReset'last_event);
    if gTimeoutIsFailure then
      
      assert iToggleReset'last_event <= gTimeout report "Watchdog timeout" severity failure;

    elsif iToggleReset'last_event > gTimeout then

      oTimeout <= '1';
      wait on iToggleReset;
      oTimeout <= '0';

    end if;

    vNextDelay := gTimeout-iToggleReset'last_event;
    if vNextDelay = 0 ns then
      vNextDelay := gTimeout;
    end if;

    
  end process Wdt1;



end architecture Rtl;
