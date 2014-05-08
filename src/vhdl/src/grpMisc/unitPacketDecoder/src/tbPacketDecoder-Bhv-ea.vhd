-------------------------------------------------------------------------------
-- Title      : PacketDecoder
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tbPacketDecoder-Bhv-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2014-04-03
-- Last update: 2014-04-03
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-04-03  1.0      lukas	Created
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;

library global;
use global.Global.all;

library misc;

entity tbPacketDecoder is
  
end entity tbPacketDecoder;


architecture Bhv of tbPacketDecoder is

    constant cToSend  : natural := 100;

    constant cClkPeriod : time := 10 ns;

  signal iClk         : std_ulogic := '1';
  signal inResetAsync : std_ulogic := '0';
  signal iDin         : std_ulogic_vector(7 downto 0);
  signal iValid       : std_ulogic;
  signal oAckIn       : std_ulogic;
  signal oDout, sPacketIn        : aDataPort;
    signal sSinkIn : std_ulogic_vector(7 downto 0);
  signal iAckOut, sPacketInAck, sSinkAckIn, sSinkValid      : std_ulogic;

    signal sEndOfSim : std_ulogic := '0';
    signal sPacketCount, sRxPacketCount : natural;
    signal sEncoderBusy : std_ulogic;
begin  -- architecture Bhv

  inResetAsync <= '0' after 0 ns,
                  '1' after 2*cClkPeriod;

  iClk <= (not iClk) and (not sEndOfSim) after cClkPeriod/2;

  sEndOfSim <= '1' when sRxPacketCount = cToSend else
               '0';

  RandomPacketSource_1 : entity misc.RandomPacketSource
    generic map (
      gMaxLen => 100)
    port map (
      iClk         => iClk,
      inInit       => inResetAsync,
      iEnable      => '1',
      iBusy        => sEncoderBusy,
      oDout        => sPacketIn,
      iAckOut      => sPacketInAck,
      oDleInData   => open, --sDleInData,
      oTxBytes     => open,
      oPacketLen   => open,
      oPacketCount => sPacketCount);
  
  PacketEncoder_1 : entity misc.PacketEncoder(Rtl)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sPacketIn,
      oAckIn       => sPacketInAck,
      oDout        => iDin,
      oBusy        => sEncoderBusy,
      iAckOut      => oAckIn,
      oValid       => iValid);

  DUT: entity work.PacketDecoder
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => iDin,
      iValid       => iValid,
      oAckIn       => oAckIn,
      oDout        => oDout,
      iAckOut      => iAckOut);
  
  PacketEncoder_2: entity work.PacketEncoder
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => oDout,
      oAckIn       => iAckOut,
      oDout        => sSinkIn,
      oEof         => open,
      oBusy        => open,
      iAckOut      => sSinkAckIn,
      oValid       => sSinkValid);

  SerialPacketSink_1 : entity misc.SerialPacketSink
    port map (
      iClk         => iClk,
      inInit       => inResetAsync,
      iDin         => sSinkIn,
      iValid       => sSinkValid,
      oAckIn       => sSinkAckIn,
      iEnable      => '1',
      oId          => open,
      oDleInData   => open,--sDleInRxData,
      oRxBytes     => open, --sRxBytes,
      oPacketLen   => open,--sRxPacketLen,
      oPacketCount => sRxPacketCount);

  
end architecture Bhv;
