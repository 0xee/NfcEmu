-------------------------------------------------------------------------------
-- Title      : StrobeGen
-- Project    : 
-------------------------------------------------------------------------------
-- File       : StrobeGen-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-07
-- Last update: 2014-04-10
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-07  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library misc;

entity StrobeGen is
  
  generic (
    gClkFreq    : natural := 48e6;
    gStrobeFreq : natural := 1e6);

  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iEnable      : in  std_ulogic;
    iSyncReset   : in  std_ulogic;
    oStrobe      : out std_ulogic);

end StrobeGen;


architecture Rtl of StrobeGen is

  constant cClkDiv : natural := gClkFreq/gStrobeFreq;

  signal Counter : natural range 0 to cClkDiv-1;

  
begin  -- Rtl

  Reg : process (iClk, inResetAsync)
  begin  -- process Reg
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      Counter <= 0;
      oStrobe <= '0';
    elsif iClk'event and iClk = '1' then  -- rising clock edge

      if iSyncReset = '1' then
        oStrobe <= '0';
        Counter <= 0;
      elsif iEnable = '1' then
        
        if Counter = cClkDiv-1 then
          oStrobe <= '1';
          Counter <= 0;
        else
          oStrobe <= '0';
          Counter <= Counter + 1;
        end if;
        
      end if;

    end if;
    
  end process Reg;

end Rtl;
