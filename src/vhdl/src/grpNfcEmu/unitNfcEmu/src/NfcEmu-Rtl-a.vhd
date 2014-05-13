-------------------------------------------------------------------------------
-- Title      : NfcEmu
-- Project    : 
-------------------------------------------------------------------------------
-- File       : NfcEmu-Rtl-a.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-15
-- Last update: 2014-05-11
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:  NfcEmu main unit
--                                            sDoutSource
--     \|/                         _________       |                                  
--      |    _____      ____     ->|-------->|--->|\                                   
--      |   |     |    |    |   /  |         |    | \               ___________
--       ---| ADC |-/->| HP |-/--->| PCD Rx  |--->|  |   u8        |           |       
--          |_____| u8 |____|   \  |         |    |  |------------>| Host FIFO |       
--                            s9 ->| PICC Rx |--->|  |      /------|___________|       
--                                 |_________|    |  |      |                          
--                                  _________     | /       |                          
--                                 | Control |--->|/        |                          
--                                 |_________|<-------------/
--                                                                          
-------------------------------------------------------------------------------
-- Modes
-------------------------------------------------------------------------------
--
--             NFC               ACQ
--   sniffer   PCD   PICC      ADC   AM
--              |      |        |     |
--          14443-2AB  |     (clkdiv) |
--         +14443-3AB  |          (clkdiv, fc)
--           +14443-4  |
--            +7816    |
--                     |
--                  14443-2A
--                  14443-2B
--                  +14443-3
--                  +14443-4
--                   +7816
--
-- 
--  Op mode
--    nfc/acq
--  nfc  mode
--    enable picc rx/tx
--    enable pcd  rx/tx
--    sniff
--    enable standards
--      decoder flags (14443a/b,15693,7816,...)
--  acq mode
--    adc
--     fs
--    am demod
--     fs, fc
--  
--
--
-- 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-15  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;

library global;
use global.Global.all;

library nfc;
use nfc.Nfc.all;
use nfc.Iso14443.all;
--use nfc.DebugCodes.all;

library NfcEmu;
use NfcEmu.NfcEmuPkg.all;

library misc;

architecture Rtl of NfcEmu is

--------------------------------------------------------------------------------
-- DSP signals
--------------------------------------------------------------------------------
  signal sDacDout  : unsigned(9 downto 0);
  signal sTestData : std_ulogic_vector(7 downto 0);

  signal sNfcFieldDig, sNfcFieldSteady : std_ulogic;



--------------------------------------------------------------------------------
-- Config signals
--------------------------------------------------------------------------------

  signal sCfgVec, sStatusVec   : std_ulogic_vector(cNfcCfgLen*8-1 downto 0);
  signal sCfg, sStatus         : aNfcEmuCfg;
  signal sCfgValid, sUpdateCfg : std_ulogic;
  signal sEnableAcq            : std_ulogic;
  signal sEnRxDebug            : std_ulogic;

--------------------------------------------------------------------------------
-- Connections Units -> Host
--------------------------------------------------------------------------------

  constant cNrOfHostPorts : natural := 8;

  signal sToHost  : aDataPortArray(cNrOfHostPorts-1 downto 0);
  signal sHostAck : std_ulogic_vector(sToHost'range);


  signal sPiccATxToHost,
    sPiccARxToHost,
    sPiccALogicToHost,
    sPcdARxToHost,
    sControlToHost,
    sCpuToHost,
    sStreamData,
    sDebugData
    : aDataPortConnection;

  signal rDbgActive : std_ulogic;
-------------------------------------------------------------------------------
-- Connections between Units 
-------------------------------------------------------------------------------

  signal sLayer4Rx, sLayer4Tx : aDataPortConnection;

-------------------------------------------------------------------------------
-- Host to Units 
-------------------------------------------------------------------------------

  signal sFromHost : aDataPort;

  signal sHostToCpu,
    sHostToCpuFw,
    sHostToControl,
    sHostToLayer4,
    sHostToPiccA,
    sHostToPcdA
    :aDataPortConnection;



--------------------------------------------------------------------------------
-- NFC control signals
--------------------------------------------------------------------------------
  
  signal sPiccALayer4Selected : std_ulogic;

  signal sPiccARxShortFrame, sIsoLayer4TxShortFrame, sPiccATxShortframe : std_ulogic;

  signal sPiccATxLoadSwitch : std_ulogic;

--------------------------------------------------------------------------------
-- Other signals
--------------------------------------------------------------------------------

  signal sStreamIn    : std_ulogic_vector(7 downto 0);
  signal sStreamValid : std_ulogic;
  signal sCpuRunning  : std_ulogic;
  
begin  -- Rtl

  Status : process (all) is
  begin  -- process status
    sStatus                        <= cInitCfg;
    sStatus.Flags(cFlagCpuRunning) <= sCpuRunning;
    sStatus.Flags(cFlagNfcField)   <= sNfcFieldSteady;
    
  end process status;

  sStatusVec <= CfgToVector(sStatus);
  sEnableAcq <= sCfgValid;

  -----------------------------------------------------------------------------
  -- DSP
  -----------------------------------------------------------------------------
  sCfg           <= CfgFromVector(sCfgVec);
  oSDacEnableCD  <= '0';
  oSDacAVal      <= sCfg.SDacA;
  oSDacBVal      <= sCfg.SDacB;
  oSDacUpdate    <= sUpdateCfg;
  oNfcLoadSwitch <= sPiccATxLoadSwitch;
  sEnRxDebug     <= sCfg.Enable(cRxDebug);

-------------------------------------------------------------------------------
-- Data from host
-------------------------------------------------------------------------------
  sFromHost <= iDin;

  sHostToCpu.DPort <= iDin when MatchId(sFromHost.Id, cIdCpu) or MatchId(sFromHost.Id, cIdIsoLayer4Picc) else
                      cEmptyPort;
  
  sHostToCpuFw.DPort <= iDin when MatchId(sFromHost.Id, cIdCpuFw) else
                        cEmptyPort;

  sHostToControl.DPort <= iDin when MatchId(sFromHost.Id, cIdCtrl) else
                          cEmptyPort;

  --sHostToPcdAValid <= iDin.Valid when MatchId(sFromHost.Id, cIdIso14443aPcd) else
  --                   '0';
  --sHostToPiccAValid <= iDin.Valid when MatchId(sFromHost.Id, cIdIso14443aPicc) else
  --                   '0';

  oAckIn <= (sHostToCpuFw.DPort.Valid and sHostToCpuFw.Ack) or
            (sHostToCpu.DPort.Valid and sHostToCpu.Ack) or
            (sHostToControl.DPort.Valid and sHostToControl.Ack);  -- or
--            (sHostToPiccAValid and sHostToPiccAAck) or
--              (sHostToPcdAValid and sHostToPcdAAck);

  assert iDin.Valid /= '1' or
    (MatchId(sFromHost.Id, cIdCpu) or
     MatchId(sFromHost.Id, cIdCpuFw) or
     MatchId(sFromHost.Id, cIdCtrl))

    report "Illegal ID on incoming packet"
    severity error;

-------------------------------------------------------------------------------
-- Data to host
-------------------------------------------------------------------------------

  sToHost(0) <= sPiccARxToHost.DPort;
  sToHost(1) <= sPiccALogicToHost.DPort;
  sToHost(2) <= sPiccATxToHost.DPort;
  sToHost(3) <= sPcdARxToHost.DPort;
  sToHost(4) <= sControlToHost.DPort;
  sToHost(5) <= sCpuToHost.DPort;
  sToHost(6) <= sStreamData.DPort;
  sToHost(7) <= sDebugData.DPort;  -- to make packetmux scheduler more efficient

  RxDbg : process(iClk, inResetAsync) is
  begin
    if inResetAsync = '0' then
      rDbgActive <= '0';
    elsif rising_edge(iClk) then
      if sEnRxDebug = '1' then
        if rDbgActive then
          if sDebugData.Ack then
            rDbgActive <= '0';
          end if;
        else
          if sHostToCpu.DPort.Eof and sHostToCpu.Ack then
            rDbgActive <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

  sDebugData.DPort.Data  <= x"EE";
  sDebugData.DPort.Id    <= x"EE";
  sDebugData.DPort.Eof   <= sDebugData.DPort.Valid;
  sDebugData.DPort.Valid <= rDbgActive;

  sPiccARxToHost.Ack    <= sHostAck(0);
  sPiccALogicToHost.Ack <= sHostAck(1);
  sPiccATxToHost.Ack    <= sHostAck(2);
  sPcdARxToHost.Ack     <= sHostAck(3);
  sControlToHost.Ack    <= sHostAck(4);
  sCpuToHost.Ack        <= sHostAck(5);
  sStreamData.Ack       <= sHostAck(6);
  sDebugData.Ack        <= sHostAck(7);
  PacketMux_1 : entity misc.PacketMux(Rtl)
    generic map (
      gScheduler => RoundRobin)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iPortIn      => sToHost,
      oPortOut     => oDout,
      iAckOut      => iAckOut,
      oDbgSelected => open,
      oAckIn       => sHostAck);




  ControlReg_1 : entity misc.ControlReg(Rtl)
    generic map (
      gCmdRead  => cCmdRead,
      gCmdWrite => cCmdWrite,
      gInitCfg  => CfgToVector(cInitCfg),
      gReadBack => cCfgReadBackMask,
      gId       => cIdCtrl)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sHostToControl.DPort,
      oAckIn       => sHostToControl.Ack,
      oDout        => sControlToHost.DPort,
      iAckOut      => sControlToHost.Ack,
      oCtrl        => sCfgVec,
      iStatus      => sStatusVec,
      oUpdateCfg   => sUpdateCfg,
      oCfgValid    => sCfgValid);

  oDacOut <= "000000000" & sCpuRunning;

  sStreamValid <= sEnableAcq and iEnvelopeValid when sCfg.Enable(cEnvelopeStream) else
                  sEnableAcq and iEnvelopeValid when sCfg.Enable(cTestStream) else
                  '0';

  sStreamIn <= iEnvelope(7 downto 0) when sCfg.Enable(cEnvelopeStream) else
               sTestData when sCfg.Enable(cTestStream) else
               (others => '-');

  StreamPacketizer_1 : entity misc.StreamPacketizer
    generic map (
      gId     => cIdEnvelope,
      gMaxLen => 512)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sStreamIn,
      iValid       => sStreamValid,
      oPacket      => sStreamData.DPort,
      iPacketAck   => sStreamData.Ack);

--------------------------------------------------------------------------------
-- DSP stuff
--------------------------------------------------------------------------------

  sNfcFieldDig <= '1' when iEnvelope > sCfg.FieldTh else
                  '0';

  FieldDetector : entity misc.SpikeFilter
    generic map (
      gSampleRate    => cNfcFc,
      gMinPulseWidth => 20 us)          -- ca two bit periods
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sNfcFieldDig,
      iValid       => iEnvelopeValid,
      oDout        => sNfcFieldSteady,
      oValid       => open);


  sDacDout <= unsigned(iEnvelope) & '0';

--  oDacOut <= std_ulogic_vector(sDacDout);

-----------------------------------------------------------------------------
-- Dummy data for comm test
-----------------------------------------------------------------------------

  TestDataGen : process (iClk, inResetAsync)
  begin  -- process TestDataGen
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      sTestData <= (others => '0');
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      sTestData <= std_ulogic_vector(unsigned(sTestData) + 1);
    end if;
  end process TestDataGen;

  Iso14443aPcdRx_1 : entity nfc.Iso14443aPcdRx(Rtl)
    generic map (
      gId => cIdIso14443aPcd)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iEnable      => sCfg.Enable(cIso14443aPcd),
      iEnvelope    => iEnvelope,
      iValid       => iEnvelopeValid,
      iThreshold   => sCfg.ScThreshold,
      oRxData      => sPcdARxToHost.DPort,
      iRxAck       => sPcdARxToHost.Ack);

  sPiccATxShortFrame <= '0';

  Iso14443aPicc_1 : entity nfc.Iso14443aPicc(Rtl)
    generic map (
      gClkFreq  => cNfcClkFreq,
      gLayer4Id => cIdIsoLayer4Picc,
      gRxId     => SetIdFlags(cIdIso14443aPicc, cDirDown),
      gTxId     => SetIdFlags(cIdIso14443aPicc, cDirUp),
      gLogicId  => SetIdFlags(cIdIso14443aPicc, cDirLogic))
    port map (
      iClk            => iClk,
      inResetAsync    => inResetAsync,
      iEnable         => sCfg.Enable(cIso14443aPicc),
      iRxOnly         => sCfg.Flags(cFlagRxOnly),
      iNfcFieldActive => sNfcFieldDig,
      iNfcFieldSteady => sNfcFieldSteady,
      iNfcFieldValid  => iEnvelopeValid,
      oTxLoadSwitch   => sPiccATxLoadSwitch,

      oRxData       => sPiccARxToHost.DPort,
      oRxShortFrame => sPiccARxShortFrame,
      iRxAck        => sPiccARxToHost.Ack,

      oSentTxData         => sPiccATxToHost.DPort,
      iSentTxAck          => sPiccATxToHost.Ack,
      oPiccLogicData      => sPiccALogicToHost.DPort,
      iPiccLogicAck       => sPiccALogicToHost.Ack,
      oLayer4Rx           => sLayer4Rx.DPort,
      iLayer4RxAck        => sLayer4Rx.Ack,
      iLayer4Tx           => sLayer4Tx.DPort,
      oLayer4TxAck        => sLayer4Tx.Ack,
      iLayer4TxShortFrame => sPiccATxShortFrame,
      iIsoLayer4Selected  => sPiccALayer4Selected,
      iUid                => sCfg.Uid,
      iUidLenDouble       => sCfg.Flags(cFlagUidLenDouble));


  Iso14443_4_1 : entity nfc.Iso14443_4(Rtl)
    port map (
      iClk          => iClk,
      inResetAsync  => inResetAsync,
      iEnable       => sCfg.Enable(cIsoLayer4Picc),
      iRx           => sLayer4Rx.DPort,   -- TODO: buffer & ack      
      oTx           => sLayer4Tx.DPort,
      iTxAck        => sLayer4Tx.Ack,
      oTxShortFrame => sIsoLayer4TxShortFrame,
      oHostOut      => sCpuToHost.DPort,  -- TODO: ack
      iHostOutAck   => sCpuToHost.Ack,

      iHostIn     => sHostToCpu.DPort,
      oHostInAck  => sHostToCpu.Ack,
      oSelected   => sPiccALayer4Selected,
      iFwIn       => sHostToCpuFw.DPort,
      oFwAck      => sHostToCpuFw.Ack,
      oCpuRunning => sCpuRunning);


  sLayer4Rx.Ack <= sLayer4Rx.DPort.Valid;

end Rtl;
