-------------------------------------------------------------------------------
-- Title      : ISO 14443-4 abstraction layer
-- Project    : NfcEmu
-------------------------------------------------------------------------------
-- File       : unitIso14443_4-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-09-13
-- Last update: 2014-05-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Iso14443-4 Abstraction
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-09-13  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library global;
use global.Global.all;

library nfc;
use nfc.Nfc.all;
use nfc.Iso14443.all;

library misc;

library nfcemu;

entity Iso14443_4 is
  port (
    iClk         : in std_ulogic;
    inResetAsync : in std_ulogic;
    iEnable      : in std_ulogic;

    iRx       : in  aDataPort;
    oTx       : out aDataPort;
    oTxShortFrame : out std_ulogic;
    iTxAck    : in  std_ulogic;
    oSelected : out std_ulogic;

    oHostOut : out aDataPort;
    iHostOutAck : in std_ulogic;
    iHostIn  : in  aDataPort;
    oHostInAck : out std_ulogic;
    iFwIn    : in  aDataPort;
    oFwAck   : out std_ulogic;
    oCpuRunning : out std_ulogic;
    oCpuGpio : out std_ulogic
    );

end Iso14443_4;

architecture Rtl of Iso14443_4 is

  constant cRxBufSize : natural := 256;

  component T51Wrapper is
    generic (
      gRomWidth  : natural;
      gXRamWidth : natural);
    port (
      iClk         : in  std_ulogic;
      inResetAsync : in  std_ulogic;
      iP0          : in  std_ulogic_vector(7 downto 0);
      oP0          : out std_ulogic_vector(7 downto 0);
      oWbRdStb     : out std_ulogic;
      oWbWrStb     : out std_ulogic;
      iWbAck       : in  std_ulogic;
      oWbDout      : out std_ulogic_vector(7 downto 0);
      oWbAdr       : out std_ulogic_vector(15 downto 0);
      iWbDin       : in  std_ulogic_vector(7 downto 0));
  end component T51Wrapper;

  component T51Interface is
    generic (
      gNrPorts     : natural;
      gBufferSize  : natural;
      gBaseAdr     : natural;
      gWbAdrWidth  : natural := 16;
      gWbDataWidth : natural := 8);
    port (
      iClk         : in  std_ulogic;
      inResetAsync : in  std_ulogic;
      iInputPorts  : in  aDataPortArray(gNrPorts-1 downto 0);
      oInputAck    : out std_ulogic_vector(gNrPorts-1 downto 0);
      oOutputPorts : out aDataPortArray(gNrPorts-1 downto 0);
      iOutputAck   : in  std_ulogic_vector(gNrPorts-1 downto 0);
      iWbAdr       : in  std_ulogic_vector(gWbAdrWidth-1 downto 0);
      iWbData      : in  std_ulogic_vector(gWbDataWidth-1 downto 0);
      oWbData      : out std_ulogic_vector(gWbDataWidth-1 downto 0);
      iWbWrStb     : in  std_ulogic;
      iWbRdStb     : in  std_ulogic;
      oWbAck       : out std_ulogic);
  end component T51Interface;


  -- enables derived from wb bus
  signal sHostOutEnable, sRxBufEnable, sHostBufEnable : std_ulogic;

  -- port signals
  signal rHostPortId                : std_ulogic_vector(7 downto 0);
  signal sRxBufReset, sHostBufReset : std_ulogic;

  signal sInputPorts, sOutputPorts : aDataPortArray(2 downto 0);
  signal sInputAck, sOutputAck     : std_ulogic_vector(2 downto 0);
  signal sP0Out                    : std_ulogic_vector(7 downto 0);

  signal rResetCrcA, sEnableCrc, sCrcEof : std_ulogic;
  signal sCrcA                           : std_ulogic_vector(15 downto 0);

  signal sSendCrc, sCrcValidOut : std_ulogic;
  signal rCrcSendProgress       : natural range 0 to 2;
  signal sTx                    : aDataPort;
  signal rInitialized           : std_ulogic;

  signal sUart : aDataPortConnection;
  
  signal sCpuToHostBuffered : aDataPortConnection;
    
begin  -- architecture Rtl

  sInputPorts(0) <= iHostIn;
  oHostInAck       <= sInputAck(0);
  oHostOut       <= sCpuToHostBuffered.DPort;
  sCpuToHostBuffered.Ack  <= iHostOutAck;--sOutputPorts(0).Valid;

  sInputPorts(1) <= iRx;

  oTx <= sTx;

  sTx.Id   <= sOutputPorts(1).Id;
  sTx.Data <= --sCrcA(7 downto 0) when rCrcSendProgress = 1 else
              --sCrcA(15 downto 8) when rCrcSendProgress = 2 else
              sOutputPorts(1).Data;
  
  
  sTx.Valid <= sOutputPorts(1).Valid;-- or sCrcValidOut;
  sTx.Eof   <= sOutputPorts(1).Eof; --;when sEnableCrc = '0' else
               --;'1' when rCrcSendProgress = 2 else
               --'0';

  sOutputAck(1) <= iTxAck;

  oSelected <= '0';

  sEnableCrc <= sP0Out(1) and sOutputPorts(1).Valid and sOutputAck(1);

  sCrcValidOut <= '1' when rCrcSendProgress /= 0 else
                  '0';

 CpuToHostBuffer : entity misc.Fifo(Rtl)
    generic map (
      gDepth => 128)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sOutputPorts(0),
      oAck         => sOutputAck(0),
      oDout        => sCpuToHostBuffered.DPort,
      iAck         => sCpuToHostBuffered.Ack);


  
  CrcA_1 : entity nfc.CrcA(Rtl)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iSyncReset   => rResetCrcA,
      iDin         => sOutputPorts(1).Data,
      iValid       => sEnableCrc,
      oCrcSum      => sCrcA);

  EdgeDetector_1 : entity misc.EdgeDetector(Rtl)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sEnableCrc,
      iValid       => '1',
      oRising      => open,
      oFalling     => sSendCrc);

  oTxShortFrame <= '0';

  SendCrc : process (iClk, inResetAsync) is
  begin  -- process SendCrc
    if inResetAsync = '0' then          -- asynchronous reset (active low)
      rCrcSendProgress <= 0;
      rInitialized     <= '0';
    elsif rising_edge(iClk) then        -- rising clock edge
      rResetCrcA <= '0';
      if rInitialized = '0' then
        if sP0Out = x"00" then
          rInitialized <= '1';
          rResetCrcA <= '1';
        end if;
      else
        if sP0Out(1) = '1' then
          rInitialized <= '0';
        else
          if sSendCrc = '1' then
            rCrcSendProgress <= 1;
          end if;

          if rCrcSendProgress = 1 then
            if iTxAck = '1' then
              rCrcSendProgress <= 2;
            end if;
          elsif rCrcSendProgress = 2 then
            if iTxAck = '1' then
              rResetCrcA       <= '1';
              rCrcSendProgress <= 0;
            end if;
          end if;
        end if;
        
      end if;
    end if;
  end process SendCrc;

  ProtocolProcessor_1 : entity nfcemu.ProtocolProcessor(Rtl)
    generic map (
      gNrPorts => sInputPorts'length)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iInputPorts  => sInputPorts,
      oInputAck    => sInputAck,
      oOutputPorts => sOutputPorts,
      iOutputAck   => sOutputAck,
      iFwIn        => iFwIn,
      oFwAck       => oFwAck,
      oP0          => sP0Out,
      oCpuRunning => oCpuRunning);


  -- buffers ack'd tx data for uart
  UartBuffer : entity misc.Fifo(Rtl)
    generic map (
      gDepth => 128)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sOutputPorts(2),
      oAck         => sOutputAck(2),
      oDout        => sUart.DPort,
      iAck         => sUart.Ack);

  UartTx_1: entity misc.UartTx(Rtl)
    generic map (
      gClkFreq  => 2*cNfcFc,
      gBaudrate => 115200,
      gDataBits => 8)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sUart.DPort,
      oAckIn       => sUart.Ack,
      oTx          => oCpuGpio);


  
end architecture Rtl;
