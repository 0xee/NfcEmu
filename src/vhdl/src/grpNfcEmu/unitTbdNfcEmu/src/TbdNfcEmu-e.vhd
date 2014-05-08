-------------------------------------------------------------------------------
-- Title      : TbdNfcEmu
-- Project    : 
-------------------------------------------------------------------------------
-- File       : TbdNfcEmu-e.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-05-31
-- Last update: 2013-09-20
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Nfc Emu testbed for Saxo Q
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-05-31  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity TbdNfcEmu is
  port (
    -- fx2 interface    
    iFx2Clk       : in    std_ulogic;
    ioFx2Data     : inout std_logic_vector(7 downto 0);
    onFx2RdStrobe : out   std_ulogic;
    onFx2WrStrobe : out   std_ulogic;
    iFx2Flags     : in    std_ulogic_vector(2 downto 0);
    onFx2DataOe   : out   std_ulogic;
    oFx2Wakeup    : out   std_ulogic;   -- tie to vdd
    oFx2FifoAdr   : out   std_ulogic_vector(1 downto 0);  -- 00 for ep2, 10 for ep6
    onFx2PktEnd   : out   std_ulogic;
    iFx2PA7       : in    std_ulogic;
    -- xtal
    iXtal1Clk     : in    std_ulogic;
    iXtal2Clk     : in    std_ulogic;
    -- serial DACs
    oSDac1Ctrl    : out   std_ulogic;
    oSDac2Ctrl    : out   std_ulogic;
    -- ADCs
    iAdc1Data     : in    std_ulogic_vector(7 downto 0);
    oAdc1Clk      : out   std_ulogic;
    -- parallel DACs
    oDac1Out      : out   std_ulogic_vector(9 downto 0);
    oDacClk       : out   std_ulogic;
    -- sec con
    oSecCon1 : out std_ulogic;
    oSecCon2 : out std_ulogic
    );


end TbdNfcEmu;
