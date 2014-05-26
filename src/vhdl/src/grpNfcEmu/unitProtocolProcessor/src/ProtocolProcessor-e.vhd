-------------------------------------------------------------------------------
-- Title      : Protocol processor
-- Project    : 
-------------------------------------------------------------------------------
-- File       : ProtocolProcessor-e.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-09-22
-- Last update: 2014-05-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Wrapper for T51, interface and update units 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-09-22  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library global;
use global.Global.all;

library nfc;
use nfc.Nfc.all;

entity ProtocolProcessor is
  
  generic (
    gNrPorts : natural := 2
    );
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iInputPorts  : in  aDataPortArray(gNrPorts-1 downto 0);
    oInputAck    : out std_ulogic_vector(gNrPorts-1 downto 0);
    oOutputPorts : out aDataPortArray(gNrPorts-1 downto 0);
    iOutputAck   : in  std_ulogic_vector(gNrPorts-1 downto 0);
    iFwIn        : in  aDataPort;
    oFwAck       : out std_ulogic;
    oP0 : out std_ulogic_vector(7 downto 0);
    oCpuRunning : out std_ulogic
    );
end entity ProtocolProcessor;
