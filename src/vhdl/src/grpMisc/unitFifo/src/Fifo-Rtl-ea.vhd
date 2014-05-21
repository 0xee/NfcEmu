-------------------------------------------------------------------------------
-- Title      : Fifo
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Fifo-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-12-20
-- Last update: 2014-05-15
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: FIFO to be used with DataPorts
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-12-20  1.0      lukas   Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library	global;
use global.Global.all;


entity Fifo is
  
  generic (
    gDepth : natural
    );
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iDin         : in  aDataPort;
    oAck         : out std_ulogic;
    oDout        : out aDataPort;
    iAck         : in  std_ulogic);

end entity Fifo;

architecture Rtl of Fifo is
  signal sFifoOut : std_ulogic_vector(cEmptyPortVec'range);
  signal sFifoOutValid : std_ulogic; 
begin  -- architecture Rtl

  oDout <= ToDataPort(sFifoOut, sFifoOutValid);

  GenFifo_1: entity work.GenFifo(Rtl)
    generic map (
      gDepth => gDepth,
      gWidth => sFifoOut'length)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => ToSulv(iDin),
      iValid       => iDin.Valid,
      oAck         => oAck,
      oDout        => sFifoOut,
      oValid       => sFifoOutValid,
      iAck         => iAck);

end architecture Rtl;
