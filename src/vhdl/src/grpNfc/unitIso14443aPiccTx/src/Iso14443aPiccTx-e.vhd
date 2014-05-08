-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Iso14443aPiccTx-e.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-26
-- Last update: 2014-05-06
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-26  1.0      lukas	Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

library global;
use global.Global.all;

entity Iso14443aPiccTx is
  
  generic (
    gClkFrequency : natural := 81360e3);
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iTxData : in aDataPort;
  iShortFrame : in std_ulogic;
    iTxBits : in std_ulogic_vector(2 downto 0);
    oAck         : out std_ulogic;
    oLoadSwitch  : out std_ulogic;
    oIdle        : out std_ulogic);

end Iso14443aPiccTx;
