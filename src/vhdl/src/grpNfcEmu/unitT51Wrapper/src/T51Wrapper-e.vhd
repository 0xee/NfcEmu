-------------------------------------------------------------------------------
-- Title      : T51Wrapper
-- Project    : 
-------------------------------------------------------------------------------
-- File       : T51Wrapper-Struct-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-09-20
-- Last update: 2013-09-22
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 

-- Revisions  :
-- Date        Version  Author  Description
-- 2013-09-20  1.0      lukas	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity T51Wrapper is
  generic (
    gRomWidth : natural := 12;
    gXRamWidth : natural := 11);
  port (

    iClk        : in  std_ulogic;
    inResetAsync      : in  std_ulogic;
    iP0      : in  std_ulogic_vector(7 downto 0);
    oP0 : out std_ulogic_vector(7 downto 0);

    -- External XRAM Wishbone:
    oWbRdStb  : out std_ulogic;
    oWbWrStb : out std_ulogic;
    iWbAck : in  std_ulogic;
    oWbDout : out std_ulogic_vector(7 downto 0);
    oWbAdr : out std_ulogic_vector(15 downto 0);
    iWbDin : in  std_ulogic_vector(7 downto 0);
    oRomAdr : out std_ulogic_vector(gRomWidth-1 downto 0);
    iRomData : in std_ulogic_vector(7 downto 0)
    
    );
end entity T51Wrapper;

