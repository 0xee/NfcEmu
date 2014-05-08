
-- Title      : ISO14443A PCD Rx
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Iso14443aPcdRx-Rtl-a.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-15
-- Last update: 2014-04-27
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: ISO 14443A PCD Receiver
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-15  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;

library dsp;
use dsp.FilterCoefficients.all;

library nfc;
use nfc.Nfc.all;

library misc;

architecture Rtl of Iso14443aPcdRx is

  constant cMatchedFilterCoeffs : aCoeffArray := (-1.0, -1.0, -1.0, -1.0,
                                                  1.0, 1.0, 1.0, 1.0,
                                                  1.0, 1.0, 1.0, 1.0,
                                                  -1.0, -1.0, -1.0, -1.0);

  constant cSubcarrierPeriod : natural := 16;

  constant cRxId : aUnitId := SetIdFlags(gId, cDirUp);
  
  signal sEnvelope : std_ulogic_vector(iEnvelope'length downto 0);

  signal sMatched      : std_ulogic_vector(12 downto 0);
  signal sMatchedValid : std_ulogic;

  signal sScDemod            : std_ulogic_vector(sMatched'left+3 downto 0);
  signal sScDemodValid       : std_ulogic;

  signal rThreshold : unsigned(sScDemod'range);
  
  signal sThresholded, sThresholdedValid : std_ulogic;

  signal sManchester, sManchesterValid : std_ulogic;
  signal sRxBit, sRxBitValid, sRxEof   : std_ulogic;

  signal rValidOut, rEofOut, rShortFrame : std_ulogic;
  signal rFrameBuffer, rDout : std_ulogic_vector(7 downto 0);
  signal rBitCount    : natural range 0 to 8;

  signal sRxData, sRxBuffered : aDataPort;
  
begin  -- Rtl

  sEnvelope <= '0' & iEnvelope;

  MatchedFilter : entity dsp.DigitalFir
    generic map (
      gCoeffs => cMatchedFilterCoeffs)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iEnable      => iEnable,
      iDin         => sEnvelope,
      iValid       => iValid,
      oDout        => sMatched,
      oValid       => sMatchedValid);

  ScDemod : entity dsp.AmDemod
    generic map (
      gPeriod => cSubcarrierPeriod/2)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sMatched,
      iValid       => sMatchedValid,
      oDout        => sScDemod,
      oValid       => sScDemodValid);

  SpikeFilter_1 : entity misc.SpikeFilter
    generic map (
      gSampleRate    => 1,
      gMinPulseWidth => 4 sec)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sThresholded,
      iValid       => sThresholdedValid,
      oDout        => sManchester,
      oValid       => sManchesterValid);

  ManchesterDecoder_1 : entity misc.ManchesterDecoder
    generic map (
      gStartBit      => '1',
      gSamplesPerBit => 16)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sManchester,
      iValid       => sManchesterValid,
      oDout        => sRxBit,
      oValid       => sRxBitValid,
      oEof         => sRxEof);

  FrameDecoder_1: entity nfc.FrameDecoder
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iRxBit       => sRxBit,
      iValid       => sRxBitValid,
      iEof         => sRxEof,
      oRxData      => sRxData);


  RxBuffer : entity misc.Fifo(Rtl)
    generic map (
      gDepth => 16)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sRxData,
      oAck         => open,
      oDout        => sRxBuffered,
      iAck         => iRxAck);

  
  oRxData <= SetId(sRxBuffered, cRxId);
  
  sThresholded <= '1' when unsigned(sScDemod(sScDemod'left downto sScDemod'right+3)) > unsigned(iThreshold) else
                  '0';

  sThresholdedValid <= sScDemodValid;

end Rtl;
