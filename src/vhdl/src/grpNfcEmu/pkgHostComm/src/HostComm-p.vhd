-------------------------------------------------------------------------------
-- Title      : HostComm
-- Project    : 
-------------------------------------------------------------------------------
-- File       : HostComm-p.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2014-03-20
-- Last update: 2014-03-20
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Package for host communication
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-03-20  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


package HostComm is

  constant cStartByte : std_ulogic_vector := x"AA";
  constant cStopByte  : std_ulogic_vector := x"CC";
  constant cDle       : std_ulogic_vector := x"EE";

end package HostComm;
