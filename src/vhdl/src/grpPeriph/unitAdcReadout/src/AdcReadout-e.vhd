-------------------------------------------------------------------------------
-- Title      : AdcReadout
-- Project    : 
-------------------------------------------------------------------------------
-- File       : AdcReadout-e.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-11
-- Last update: 2013-06-11
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Reads data from an ADC on the rising edge of the input clock
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-11  1.0      lukas	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity AdcReadout is
  generic (
    gWidth : natural := 8);
  port (
    iClk : in std_ulogic;
    inResetAsync : in std_ulogic;
    iAdcData : in std_ulogic_vector(gWidth-1 downto 0);
    oAdcClk : out std_ulogic;
    oAdcData : out std_ulogic_vector(gWidth-1 downto 0)
    );
    
end AdcReadout;
