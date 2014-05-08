-------------------------------------------------------------------------------
-- Title      : Iso14443aPicc
-- Project    : 
-------------------------------------------------------------------------------
-- File       : unitIso14443aPicc-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2014-04-04
-- Last update: 2014-04-18
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: ISO 14443-A PICC implementation up to ISO 14443-3. Layer 4 can
-- be implemented by connecting to the Layer4 Ports
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-04-04  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library global;
use global.Global.all;

library nfc;
use nfc.Nfc.all;
use nfc.Iso14443.all;


library misc;

entity Iso14443aPicc is
  generic (
    gClkFreq  : natural;
    gLayer4Id : std_ulogic_vector;
    gRxId     : std_ulogic_vector;
    gTxId     : std_ulogic_vector;
    gLogicId  : std_ulogic_vector);
  port (
    iClk         : in std_ulogic;
    inResetAsync : in std_ulogic;
    iEnable      : in std_ulogic;
    iRxOnly      : in std_ulogic;

    -- DSP i/o
    iNfcFieldActive : in  std_ulogic;
    iNfcFieldSteady : in  std_ulogic;
    iNfcFieldValid  : in  std_ulogic;
    oTxLoadSwitch   : out std_ulogic;

    -- rx/tx data copied streams
    oRxData       : out aDataPort;
    oRxShortFrame : out std_ulogic;
    iRxAck        : in  std_ulogic;
    oSentTxData   : out aDataPort;
    iSentTxAck    : in  std_ulogic;

    -- picc logic i/o
    oPiccLogicData : out aDataPort;
    iPiccLogicAck  : in  std_ulogic;

    -- layer 4 i/o data
    oLayer4Rx           : out aDataPort;
    iLayer4RxAck        : in  std_ulogic;
    iLayer4Tx           : in  aDataPort;
    iLayer4TxShortFrame : in  std_ulogic;
    oLayer4TxAck        : out std_ulogic;
    iIsoLayer4Selected  : in  std_ulogic;

    -- configuration
    iUid          : in std_ulogic_vector(cUidLenDouble*8-1 downto 0);
    iUidLenDouble : in std_ulogic

    );
end entity Iso14443aPicc;


architecture Rtl of Iso14443aPicc is

  signal sTx, sSentTxBuffered                              : aDataPortConnection;
  signal sRx, sRxBuffered, sLayer4Rx, sLogicDataUnbuffered : aDataPort;

  signal sRxShortFrame, sTxShortFrame : std_ulogic;

  signal sPiccARxCtbi : std_ulogic_vector(LogDualis(cCyclesPerBit)-1 downto 0);
  signal sPiccARxBgi  : std_ulogic_vector(LogDualis(cFrameDelayMaxN)-1 downto 0);
  
begin  -- architecture Rtl

  Iso14443aPiccRx_1 : entity nfc.Iso14443aPiccRx(Rtl)
    generic map (
      gClkFrequency => gClkFreq,
      gId           => gRxId)
    port map (
      iClk              => iClk,
      inResetAsync      => inResetAsync,
      iEnable           => iEnable,
      iNfcFieldActive   => iNfcFieldActive,
      iNfcFieldValid    => iNfcFieldValid,
      oRxData           => sRx,
      oRxShortFrame     => sRxShortFrame,
      oCyclesToBitStart => sPiccARxCtbi,
      oBitGridIndex     => sPiccARxBgi
      );

  RxBuffer : entity misc.Fifo(Rtl)
    generic map (
      gDepth => 16)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => SetErrorFlag(sRx, sRxShortFrame),
      oAck         => open,
      oDout        => sRxBuffered,
      iAck         => iRxAck);

  LogicToHostBuffer : entity misc.Fifo(Rtl)
    generic map (
      gDepth => 16)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sLogicDataUnbuffered,
      oAck         => open,
      oDout        => oPiccLogicData,
      iAck         => iPiccLogicAck);

  
  oRxData <= SetId(SetErrorFlag(sRxBuffered, '0'), gRxId);

  oRxShortFrame <= sRxBuffered.error;   -- shortframe flag is tunneled through
                                        -- error bit


  Iso14443aPiccLogic_1 : entity nfc.Iso14443aPiccLogic(Rtl)
    generic map (
      gClkFreq  => gClkFreq,
      gLayer4Id => gLayer4Id,
      gPiccId   => gLogicId)

    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iEnable      => iEnable and not iRxOnly,
      iFieldActive => iNfcFieldSteady,

      iRxData       => sRx,
      iRxShortFrame => sRxShortFrame,

      oHostData     => sLogicDataUnbuffered,
      oTxData       => sTx.DPort,
      oTxShortFrame => sTxShortframe,
      oTxBits       => open,            -- todo: remove
      iTxAck        => sTx.Ack,

      iBitGridIdx         => sPiccARxBgi,
      iCyclesToBitStart   => sPiccARxCtbi,
      iUidLenDouble       => iUidLenDouble,
      iUid                => iUid,
      oLayer4RxData       => sLayer4Rx,
      iLayer4TxData       => iLayer4Tx,
      iLayer4TxShortFrame => iLayer4TxShortFrame,
      oLayer4TxAck        => oLayer4TxAck,
      iIsoLayer4Selected  => iIsoLayer4Selected
      );



  Iso14443aPiccTx_1 : entity nfc.Iso14443aPiccTx(Rtl)
    generic map (
      gClkFrequency => gClkFreq)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      oLoadSwitch  => oTxLoadSwitch,
      iTxData      => sTx.DPort,
      iShortFrame  => sTxShortframe,
      iTxBits      => (others => '-'),  -- todo: remove port
      oAck         => sTx.Ack,
      oIdle        => open);

  TxBuffer : entity misc.Fifo
    generic map (
      gDepth => 16)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => SetValid(sTx.DPort, sTx.Ack),
      oAck         => open,
      oDout        => sSentTxBuffered.DPort,
      iAck         => sSentTxBuffered.Ack);

  oSentTxData <= SetId(sSentTxBuffered.DPort, gTxId);
  sSentTxBuffered.Ack <= iSentTxAck;

  Layer4RxBuffer : entity misc.Fifo
    generic map (
      gDepth => 16)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sLayer4Rx,
      oAck         => open,
      oDout        => oLayer4Rx,
      iAck         => iLayer4RxAck);


end architecture Rtl;
