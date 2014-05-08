-------------------------------------------------------------------------------
-- Title      : ISO14443A RX
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Iso14443ARx-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-04-12
-- Last update: 2014-04-06
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: ISO14443A Receiver
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

library nfc;
use nfc.Iso14443.all;

entity Iso14443aPiccRx is
  
  generic (
    gClkFrequency  : natural := 50e6;
    gId : std_ulogic_vector);
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iEnable : in std_ulogic;
    iNfcFieldActive    : in  std_ulogic;
    iNfcFieldValid    : in  std_ulogic;
    oRxData     : out aDataPort;
    oRxShortFrame : out std_ulogic;
    oCyclesToBitStart : out std_ulogic_vector(LogDualis(cCyclesPerBit)-1 downto 0);
    oBitGridIndex : out std_ulogic_vector(LogDualis(cFrameDelayMaxN)-1 downto 0)    
    );

end Iso14443aPiccRx;
