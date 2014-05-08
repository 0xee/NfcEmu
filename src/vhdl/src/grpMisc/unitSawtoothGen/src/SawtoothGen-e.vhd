-------------------------------------------------------------------------------
-- Title      : SawtoothGen
-- Project    : 
-------------------------------------------------------------------------------
-- File       : SawtoothGen-e.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-07
-- Last update: 2013-06-07
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
use ieee.numeric_std.all;

entity SawtoothGen is
  
  generic (
    gClkFreq    : natural := 48e6;
    gUpdateFreq : natural := 1e6;
    gMinVal     : natural := 0;
    gMaxVal     : natural := 255);

  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iEnable      : in  std_ulogic;
    iSyncReset   : in  std_ulogic;
    oDout        : out std_ulogic_vector;
    oUpdate      : out std_ulogic);

end SawtoothGen;
