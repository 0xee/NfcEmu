-------------------------------------------------------------------------------
-- Title      : AdcReadout RTL
-- Project    : 
-------------------------------------------------------------------------------
-- File       : AdcReadout-Rtl-a.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-11
-- Last update: 2013-06-11
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-11  1.0      lukas	Created
-------------------------------------------------------------------------------

architecture Rtl of AdcReadout is

begin  -- Rtl
  
  oAdcClk <= iClk;
  
  Reg: process (iClk, inResetAsync)
  begin  -- process Reg
    if inResetAsync = '0' then          -- asynchronous reset (active low)
      oAdcData <= (others => '0');
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      oAdcData <= iAdcData;
    end if;
  end process Reg;

end Rtl;
