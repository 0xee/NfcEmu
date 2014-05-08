-------------------------------------------------------------------------------
-- Title      : FX2 Fifo Interface
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Fx22FifoInterface-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-05-31
-- Last update: 2013-09-19
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: FX2 fifo interface
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

entity Fx2FifoInterface is

  port (
    inResetAsync  : in    std_ulogic;
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
    --iFx2PA7       : in    std_ulogic;
    -- internal interface (rd)
    oData         : out   std_ulogic_vector(7 downto 0);
    oValid        : out   std_ulogic;
    iAck          : in    std_ulogic;
    -- internal interface (wr)
    iData         : in    std_ulogic_vector(7 downto 0);
    iValid        : in    std_ulogic;
    oAck          : out   std_ulogic;
    iEndOfPacket  : in    std_ulogic
    );


end Fx2FifoInterface;
