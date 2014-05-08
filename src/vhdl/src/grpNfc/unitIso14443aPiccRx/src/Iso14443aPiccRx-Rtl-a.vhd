-------------------------------------------------------------------------------
-- Title      : ISO14443A Rx
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Iso14443ARx-Rtl-a.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-15
-- Last update: 2014-05-06
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: ISO 14443A Receiver
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-15  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;

library nfc;
use nfc.Nfc.all;

library misc;

architecture Rtl of Iso14443aPiccRx is
  
  signal sMiller, sMillerValid    : std_ulogic;
  signal sRxBit, sRxValid, sRxEof : std_ulogic;
  signal sRxData : aDataPort;
  signal rCyclesToBitStart : unsigned(oCyclesToBitStart'range);
  signal rBitGridIndex     : unsigned(oBitGridIndex'range);

  signal rByteOut : std_ulogic_vector(7 downto 0);
  signal rBitCount : natural range 0 to 7;
  signal rValidOut, rEofOut : std_ulogic;
  
begin  -- Rtl

  SpikeFilter_1 : entity misc.SpikeFilter
    generic map (
      gSampleRate    => cNfcFc,
      gMinPulseWidth => 1 us)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => iNfcFieldActive,
      iValid       => iNfcFieldValid,
      oDout        => sMiller,
      oValid       => sMillerValid);


  MillerDec_1 : entity nfc.MillerDec
    generic map (
      gClkFrequency => gClkFrequency)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iEnable      => iEnable,
      iMiller      => sMiller,
      iValid       => sMillerValid,
      oRxBit       => sRxBit,
      oValid       => sRxValid,
      oEof         => sRxEof);

  FrameDecoder_1: entity nfc.FrameDecoder
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iRxBit       => sRxBit,
      iValid       => sRxValid,
      iEof         => sRxEof,
      oRxShortFrame => oRxShortFrame,
      oRxData      => sRxData);

  oRxData <= SetId(sRxData, gId);

  BitGrid : process (iClk, inResetAsync)
  begin  -- process BitGrid
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      rCyclesToBitStart <= (others => '0');
      rBitGridIndex     <= (others => '0');
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      if sMillerValid = '1' then
        rCyclesToBitStart <= rCyclesToBitStart - 1;
        if rCyclesToBitStart = 0 then
          rBitGridIndex <= rBitGridIndex + 1;
        end if;
      end if;
      if sRxEof = '1' then
        rBitGridIndex     <= to_unsigned(1, rBitGridIndex'length);
        rCyclesToBitStart <= to_unsigned(64, rCyclesToBitStart'length);
      end if;
    end if;
  end process BitGrid;

  oCyclesToBitStart <= std_ulogic_vector(rCyclesToBitStart);
  oBitGridIndex     <= std_ulogic_vector(rBitGridIndex);
  
  --oDataOut <= "0000000" & sMiller;
  --oValid   <= sMillerValid;
  --oEof     <= '0';
end Rtl;
