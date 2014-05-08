-------------------------------------------------------------------------------
-- Title      : Package NFC
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Nfc-p.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-16
-- Last update: 2014-04-24
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-16  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Nfc is

  
  constant cPiccPowerOn      : natural := 1;
  constant cPiccPowerLost    : natural := 2;
  constant cPiccIsReady      : natural := 3;
  constant cPiccSelected     : natural := 4;
  constant cPiccHalted       : natural := 5;
  constant cInvalidCrc       : natural := 7;
  constant cIsoL4Deactivated : natural := 10;

  constant cDirLogic   : std_ulogic_vector := "000";  -- for protocol events
                                        -- (e.g. PICC selected, ...)
  constant cDirDown    : std_ulogic_vector := "001";  -- for PCD->PICC communication
  constant cDirUp      : std_ulogic_vector := "010";  -- for PICC->PCD communication
  constant cDirStatus  : std_ulogic_vector := "011";  -- for unit status
  constant cDirSpecial : std_ulogic_vector := "100";  -- for unit-specific
                                                      -- special messages
  constant cDirDebug   : std_ulogic_vector := "111";  -- for debug messages

  
  constant cNfcFc      : natural := 13560e3;

  -- ISO standard specifies a delay < 5ms
  constant cFieldOnDetectTime : time := 2 ms;


  --type aCounterArray is array (natural range <>) of std_ulogic_vector(7 downto 0);
    
  subtype aThreshold is std_ulogic_vector(7 downto 0);


  constant cUidLenDouble : natural := 7;
  constant cUidLenSingle : natural := 4;
  subtype aUid is std_ulogic_vector(cUidLenDouble*8-1 downto 0);

  
end Nfc;

package body Nfc is

  
end Nfc;
