-------------------------------------------------------------------------------
-- Title      : DebugCodes Package
-- Project    : 
-------------------------------------------------------------------------------
-- File       : DebugCodes-p.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-08-10
-- Last update: 2014-04-03
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Contains 1-byte debug codes
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-08-10  1.0      lukas   Created
-------------------------------------------------------------------------------

package DebugCodes is

  constant cDummyMessage     : natural := 0;
  constant cConfigAck        : natural := 6;
end DebugCodes;
