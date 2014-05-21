-------------------------------------------------------------------------------
-- Title      : NfcEmu
-- Project    : 
-------------------------------------------------------------------------------
-- File       : NfcEmu-e.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-15
-- Last update: 2014-05-15
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-15  1.0      lukas	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library global;
use global.Global.all;

entity NfcEmu is
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    
    iDin         : in  aDataPort;
    oAckIn         : out std_ulogic;
    oDout        : out aDataPort;
    iAckOut         : in  std_ulogic;
    oTsOut : out std_ulogic_vector(31 downto 0);
    oDacOut : out std_ulogic_vector(9 downto 0);

    iEnvelope : in std_ulogic_vector(8 downto 0);
    iEnvelopeValid : in std_ulogic;

    oSDacAVal : out  std_ulogic_vector(7 downto 0);
    oSDacBVal : out  std_ulogic_vector(7 downto 0);
    oSDacUpdate : out std_ulogic;
    oSDacEnableCD : out std_ulogic;
    iSDacAck : in std_ulogic;
    oNfcLoadSwitch : out std_ulogic;
    oTest : out std_ulogic
    );

end NfcEmu;
