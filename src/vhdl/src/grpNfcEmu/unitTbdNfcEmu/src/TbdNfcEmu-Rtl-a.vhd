-------------------------------------------------------------------------------
-- Title      : TbdNfcEmu
-- Project    : 
-------------------------------------------------------------------------------
-- File       : TbdNfcEmu-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-05-31
-- Last update: 2014-05-10
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

library global;
use global.Global.all;

library nfcemu;
use nfcemu.NfcEmuPkg.all;

library nfc;
use nfc.nfc.all;


library misc;
library periph;
library dsp;

architecture Rtl of TbdNfcEmu is
  component nfc_pll
    port (
      areset : in  std_logic := '0';
      inclk0 : in  std_logic := '0';
      c0     : out std_logic;
      c1     : out std_logic;
      locked : out std_logic);
  end component;

  -- clocks, resets
  signal sNfcClk, sAdcClk       : std_ulogic;
  signal snFx2Reset, snNfcReset : std_ulogic;

  -- fifo signals
  signal sFifoDin, sFifoDout         : std_ulogic_vector(7 downto 0);
  signal sFifoValidIn, sFifoValidOut : std_ulogic;
  signal sFifoAckIn, sFifoAckOut     : std_ulogic;
  signal sFifoEndOfPacket            : std_ulogic;


  -- nfc io signals
  signal sNfcDin, sNfcDout : aDataPortConnection;

  signal sSerialInValid, sSerialInAck : std_ulogic;
  signal sSerialInVec                 : std_ulogic_vector(sFifoDin'range);


  signal sPacketEncoderBusy, sPacketOutEof, sPacketOutValid, sPacketOutAck : std_ulogic;

  signal sPacketOut : std_ulogic_vector(7 downto 0);

  signal sFifoDoutBundle : std_ulogic_vector(sNfcDout.DPort.Data'left+2 downto 0);


  signal sAsyncNfcReset : std_ulogic;

  signal sSDacAVal, sSDacBVal, sSDacCVal, sSDacDVal : std_ulogic_vector(7 downto 0);
  signal sSDacUpdate, sSDacEnableCD, sSDacAck       : std_ulogic;


  signal sAdcData       : std_ulogic_vector(7 downto 0);
  signal sAdcDataSigned : std_ulogic_vector(8 downto 0);
  signal sAdcAc         : std_ulogic_vector(8 downto 0);
  signal sAdcAcValid    : std_ulogic;
  signal sEnvelope      : std_ulogic_vector(11 downto 0);
  signal sEnvelopeValid : std_ulogic;


  signal sFifoValidOutCDC, sFifoAckOutCDC : std_ulogic;

  signal sNfcLoadSwitch : std_ulogic;

  constant cAltFifo : boolean := true;
  
begin


  oSDac2Ctrl <= '0';

-------------------------------------------------------------------------------
--  FX2 clock domain (48MHz)
-------------------------------------------------------------------------------

  Fx2ResetSynchronizer : entity misc.ResetSynchronizer
    port map (
      iClk         => iFx2Clk,
      inResetAsync => iFx2PA7,
      oSyncReset   => snFx2Reset);

  sFifoDout <= sFifoDoutBundle(sFifoDout'range);

  sFifoEndOfPacket <= sFifoDoutBundle(sFifoDout'left+1);  -- eof flag

  Fx2FifoInterface_1 : entity periph.Fx2FifoInterface
    port map (
      inResetAsync  => snFx2Reset,
      iFx2Clk       => iFx2Clk,
      ioFx2Data     => ioFx2Data,
      onFx2RdStrobe => onFx2RdStrobe,
      onFx2WrStrobe => onFx2WrStrobe,
      iFx2Flags     => iFx2Flags,
      onFx2DataOe   => onFx2DataOe,
      oFx2Wakeup    => oFx2Wakeup,
      oFx2FifoAdr   => oFx2FifoAdr,
      onFx2PktEnd   => onFx2PktEnd,
      oData         => sFifoDin,
      oValid        => sFifoValidIn,
      iAck          => sFifoAckIn,
      iData         => sFifoDout,
      iValid        => sFifoValidOut,
      oAck          => sFifoAckOut,
      iEndOfPacket  => sFifoEndOfPacket);

-------------------------------------------------------------------------------
-- FX2 => NFC domain crossing
-------------------------------------------------------------------------------

  FIFO_In : if cAltFifo generate

    CDC_in : entity work.DualClockedFifo
      generic map (
        gWidth => 8)
      port map (
        iWrClk       => iFx2Clk,
        iRdClk       => sNfcClk,
        inResetAsync => snFx2Reset,
        iValid       => sFifoValidIn,
        iDin         => sFifoDin,
        oAck         => sFifoAckIn,
        oValid       => sSerialInValid,
        oDout        => sSerialInVec,
        iAck         => sSerialInAck);

  else generate
         
         
         --CDC_in : entity misc.DcFifo
         --  generic map (
         --    gDepth => 256)
         --  port map (
         --    iWrClk       => iFx2Clk,
         --    iRdClk       => sNfcClk,
         --    inResetAsync => snFx2Reset,
         --    iSyncReset   => not snFx2Reset,
         --    iValid       => sFifoValidIn,
         --    iDin         => sFifoDin,
         --    oAckIn       => sFifoAckIn,
         --    oValid       => sSerialInValid,
         --    oDout        => sSerialInVec,
         --    iAckOut      => sSerialInAck);
       end generate FIFO_In;

         PacketDecoder_1 : entity misc.PacketDecoder
           port map (
             iClk         => sNfcClk,
             inResetAsync => snNfcReset,
             iDin         => sSerialInVec,
             iValid       => sSerialInValid,
             oAckIn       => sSerialInAck,
             oDout        => sNfcDin.DPort,
             iAckOut      => sNfcDin.Ack);


         PacketEncoder_1 : entity misc.PacketEncoder
           port map (
             iClk         => sNfcClk,
             inResetAsync => snNfcReset,
             iDin         => sNfcDout.DPort,
             oAckIn       => sNfcDout.Ack,
             oDout        => sPacketOut,
             oEof         => sPacketOutEof,
             iAckOut      => sPacketOutAck,
             oBusy        => sPacketEncoderBusy,
             oValid       => sPacketOutValid);  

         --cdc_fifo_1: entity work.cdc_fifo
         --  port map (
         --    aclr    => snNfcReset,
         --    data    => sPacketOutEof & sPacketOut,
         --    rdclk   => iFx2Clk,
         --    rdreq   => sFifoAckOut,
         --    wrclk   => sNfcClk,
         --    wrreq   => sPacketOutValid,
         --    q       => sFifoDoutBundle,
         --    rdempty => sFifoOutEmpty,
         --    wrfull  => sFifoOutFull);
         
         FIFO_Out : if cAltFifo generate

           CDC_out : entity work.DualClockedFifo
             generic map (
               gWidth => 10)
             port map (
               iWrClk       => sNfcClk,
               iRdClk       => iFx2Clk,
               inResetAsync => snNfcReset,
               iValid       => sPacketOutValid,
               iDin         => '0' & sPacketOutEof & sPacketOut,
               oAck         => sPacketOutAck,
               oValid       => sFifoValidOut,
               oDout        => sFifoDoutBundle,
               iAck         => sFifoAckOut);
         else  generate
             --CDC_out : entity misc.DcFifo
             --  generic map (
             --    gDepth => 256)
             --  port map (
             --    iWrClk       => sNfcClk,
             --    iRdClk       => iFx2Clk,
             --    inResetAsync => snNfcReset,
             --    iSyncReset   => not snNfcReset,
             --    iValid       => sPacketOutValid,
             --    iDin         => '0' & sPacketOutEof & sPacketOut,
             --    oAckIn       => sPacketOutAck,
             --    oValid       => sFifoValidOut,
             --    oDout        => sFifoDoutBundle,
             --    iAckOut      => sFifoAckOut);
           end generate FIFO_Out;

-------------------------------------------------------------------------------
--  NFC clock domain (27.12 MHz)
-------------------------------------------------------------------------------

           nfc_pll_1 : nfc_pll
             port map (
               areset => '0',
               inclk0 => iXtal2Clk,
               c0     => sAdcClk,
               c1     => sNfcClk,
               locked => open);



           sAsyncNfcReset <= snFx2Reset;

           NfcResetSynchronizer : entity misc.ResetSynchronizer
             port map (
               iClk         => sNfcClk,
               inResetAsync => sAsyncNfcReset,
               oSyncReset   => snNfcReset);


           
           AdcReadout_1 : entity periph.AdcReadout
             port map (
               iClk         => sAdcClk,
               inResetAsync => snNfcReset,
               iAdcData     => iAdc1Data,
               oAdcClk      => oAdc1Clk,
               oAdcData     => sAdcData);

           -- high pass eliminating dc offset
           -- todo: optimize for less ressources
           sAdcDataSigned <= '0' & sAdcData;

           DcBlock_1 : entity dsp.DcBlock
             port map (
               iClk         => sAdcClk,
               inResetAsync => snNfcReset,
               iDin         => sAdcDataSigned,
               oDout        => sAdcAc,
               iValid       => '1',
               oValid       => sAdcAcValid);

           -- envelope detector
           AmDemod_1 : entity dsp.AmDemod
             generic map (
               gPeriod => cAdcClkFreq/cNfcFc)
             port map (
               iClk         => sAdcClk,
               inResetAsync => snNfcReset,
               iDin         => sAdcAc,
               iValid       => sAdcAcValid,
               oDout        => sEnvelope,
               oValid       => open);


           StrobeGen_1 : entity misc.StrobeGen
             generic map (
               gClkFreq    => cNfcClkFreq,
               gStrobeFreq => cNfcFc)
             port map (
               iClk         => sNfcClk,
               inResetAsync => snNfcReset,
               iEnable      => '1',
               iSyncReset   => '0',
               oStrobe      => sEnvelopeValid);



           NfcEmu_1 : entity nfcemu.NfcEmu
             port map (
               iClk         => sNfcClk,
               inResetAsync => snNfcReset,

               iDin   => sNfcDin.DPort,
               oAckIn => sNfcDin.Ack,

               oDout   => sNfcDout.DPort,
               iAckOut => sNfcDout.Ack,

               oDacOut => oDac1Out,

               iEnvelope      => sEnvelope(8 downto 0),
               iEnvelopeValid => sEnvelopeValid,
               oSDacAVal      => sSDacAVal,
               oSDacBVal      => sSDacBVal,
               oSDacUpdate    => sSDacUpdate,
               oSDacEnableCD  => sSDacEnableCD,
               iSDacAck       => sSDacAck,
               oNfcLoadSwitch => sNfcLoadSwitch);

           -- oDac1Out <= sNfcDin.Ack & sNfcDin.DPort.Data &  sNfcDin.DPort.Valid;
           
           oDacClk <= sNfcClk;

           oSecCon1 <= sNfcLoadSwitch;
           oSecCon2 <= '0';


           SerialDac_1 : entity periph.SerialDac
             generic map (
               gClkFreq  => cNfcClkFreq,
               gSClkFreq => 100e3)
             port map (
               iClk         => sNfcClk,
               inResetAsync => snNfcReset,
               iValid       => sSDacUpdate,
               iUpdateCD    => sSDacEnableCD,
               oAck         => sSDacAck,
               iDacA        => sSDacAVal,
               iDacB        => sSDacBVal,
               iDacC        => (others => '1'),
               iDacD        => (others => '0'),
               oDacCtrl     => oSDac1Ctrl);
--  sSDacAck <= sSDacUpdate;

         end Rtl;


