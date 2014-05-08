-------------------------------------------------------------------------------
-- Title      : ISO14443A PCD RX
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Iso14443aPcdRx-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-04-12
-- Last update: 2014-04-27
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: ISO-14443A PICC Receiver
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-04-12  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library global;
use global.Global.all;


entity Iso14443aPcdRx is
  generic (
    gId : std_ulogic_vector);
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iEnable      : in  std_ulogic;
    iEnvelope    : in  std_ulogic_vector;
    iValid       : in  std_ulogic;
    iThreshold   : in  std_ulogic_vector(7 downto 0);
    oRxData      : out aDataPort;
    iRxAck       : in  std_ulogic);

end Iso14443aPcdRx;
