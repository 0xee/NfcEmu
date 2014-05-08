-------------------------------------------------------------------------------
-- Title      : PacketEncoder
-- Project    : 
-------------------------------------------------------------------------------
-- File       : PacketEncoder-e.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2014-03-11
-- Last update: 2014-04-11
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-03-11  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library global;
use global.Global.all;

library work;

entity PacketEncoder is
  generic (
    gStartByte      : std_ulogic_vector(cDataPortWidth-1 downto 0) := x"AA";
    gStopByte       : std_ulogic_vector(cDataPortWidth-1 downto 0) := x"CC";
    gDataLinkEscape : std_ulogic_vector(cDataPortWidth-1 downto 0) := x"EE");

  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iDin         : in  aDataPort;
    oAckIn : out std_ulogic;
    oDout        : out std_ulogic_vector(7 downto 0);
    oEof : out std_ulogic;
    oBusy : out std_ulogic;
    iAckOut : in std_ulogic;
    oValid       : out std_ulogic);

end entity PacketEncoder;
