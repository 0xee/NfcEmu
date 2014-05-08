-------------------------------------------------------------------------------
-- Title      : EdgeDetector
-- Project    : 
-------------------------------------------------------------------------------
-- File       : EdgeDetector-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-07-11
-- Last update: 2013-07-11
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Edge Detector
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-07-11  1.0      lukas   Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity EdgeDetector is
  
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iDin         : in  std_ulogic;
    iValid       : in  std_ulogic;
    oRising      : out std_ulogic;
    oFalling     : out std_ulogic);

end EdgeDetector;

architecture Rtl of EdgeDetector is

  signal rState : std_ulogic;
  
begin  -- Rtl

  Detect : process (iClk, inResetAsync)
  begin  -- process Detect
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      rState <= '0';
      oRising <= '0';
      oFalling <= '0';
    elsif iClk'event and iClk = '1' then  -- rising clock edge

      oRising  <= iValid and (iDin and not rState);
      oFalling <= iValid and (not iDin and rState);

      if iValid = '1' then
        rState <= iDin;
      end if;
      
    end if;
  end process Detect;

end Rtl;
