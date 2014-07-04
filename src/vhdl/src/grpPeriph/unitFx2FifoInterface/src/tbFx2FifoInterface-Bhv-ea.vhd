-------------------------------------------------------------------------------
-- Title      : tbFx2FifoInterface
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tbFx2FifoInterface-Bhv-ea.vhd
-- Author     : Lukas Schuller  <lukas@0xee.eu>
-- Company    : 
-- Created    : 2014-05-10
-- Last update: 2014-05-27
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-05-10  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library global;
use global.global.all;

library misc;
library periph;
library nfcemu;
use nfcemu.NfcEmuPkg.all;

entity tbFx2FifoInterface is

end entity tbFx2FifoInterface;

architecture Bhv of tbFx2FifoInterface is

  signal inResetAsync  : std_ulogic;
  signal iFx2Clk       : std_ulogic;
  signal ioFx2Data     : std_logic_vector(7 downto 0);
  signal oFx2Data      : std_logic_vector(7 downto 0);
  signal iFx2Data      : std_logic_vector(7 downto 0);
  signal onFx2RdStrobe : std_ulogic;
  signal onFx2WrStrobe : std_ulogic;
  signal iFx2Flags     : std_ulogic_vector(2 downto 0);
  signal onFx2DataOe   : std_ulogic;
  signal oFx2Wakeup    : std_ulogic;
  signal oFx2FifoAdr   : std_ulogic_vector(1 downto 0);
  signal onFx2PktEnd   : std_ulogic;
  signal oData         : std_ulogic_vector(7 downto 0);
  signal oValid        : std_ulogic;
  signal iAck          : std_ulogic;
  signal iData         : std_ulogic_vector(7 downto 0);
  signal iValid        : std_ulogic;
  signal oAck          : std_ulogic;
  signal iEndOfPacket  : std_ulogic;
  signal iTs : std_logic_vector(31 downto 0);
  
  signal sWdtReset : std_ulogic;
  signal sEndOfSim : std_ulogic := '0';

  signal sFromHost, sToHost : aDataPortConnection;

  signal sFifoDataAvailable, sFifoFull : std_ulogic;
  signal sPacketNr : natural := 0;
begin  -- architecture Bhv

  SimCtrl_1 : entity misc.SimCtrl
    generic map (
      gClkFreq    => 48e6,
      gWdtTimeout => 100 ms)
    port map (
      oClk      => iFx2Clk,
      onReset   => inResetAsync,
      iEndOfSim => sEndOfSim,
      iWdtReset => sWdtReset);

  iTs <= std_ulogic_vector(to_unsigned(integer(now/1 us), 32));
  
  DUT : entity periph.Fx2FifoInterface(Rtl)
    port map (
      inResetAsync  => inResetAsync,
      iFx2Clk       => iFx2Clk,
      ioFx2Data     => ioFx2Data,
      onFx2RdStrobe => onFx2RdStrobe,
      onFx2WrStrobe => onFx2WrStrobe,
      iFx2Flags     => iFx2Flags,
      onFx2DataOe   => onFx2DataOe,
      oFx2Wakeup    => oFx2Wakeup,
      oFx2FifoAdr   => oFx2FifoAdr,
      onFx2PktEnd   => onFx2PktEnd,
      oData         => oData,
      oValid        => oValid,
      iAck          => iAck,
      iData         => iData,
      iValid        => iValid,
      oAck          => oAck,
      iEndOfPacket  => iEndOfPacket);

  ioFx2Data <= iFx2Data when onFx2DataOe = '0' else
               (others => 'Z');
  oFx2Data <= ioFx2Data;

  iFx2Flags(0) <= sFifoDataAvailable;
  iFx2Flags(2) <= not sFifoFull;

  Host : process is

    procedure UsbSendPacket(cData : std_ulogic_vector) is
      constant cStart : std_logic_vector(47 downto 0) := FlipBytes(x"AA0100010203");
      constant cEnd   : std_logic_vector(15 downto 0) := FlipBytes(x"EECC");
    begin
      sFifoDataAvailable <= '1';

      for i in 0 to cStart'length/8-1 loop
        iFx2Data <= cStart(i*8+7 downto i*8);
        wait until rising_edge(iFx2Clk) and onFx2RdStrobe = '0';
      end loop;

      for i in 0 to cData'length/8-1 loop
        iFx2Data <= cData(i*8+7 downto i*8);
        wait until rising_edge(iFx2Clk) and onFx2RdStrobe = '0';
      end loop;

      for i in 0 to cEnd'length/8-1 loop
        iFx2Data <= cEnd(i*8+7 downto i*8);
        wait until rising_edge(iFx2Clk) and onFx2RdStrobe = '0';
      end loop;

      sFifoDataAvailable <= '0';
    end procedure;

    
  begin  -- process Host
    sFifoFull <= '0';
    wait until inResetAsync = '1';
    wait for 200 ns;

    UsbSendPacket(FlipBytes(x"CC"));
    wait for 10 ms;
    UsbSendPacket(FlipBytes(x"FFAAFFBBFFCCFF"));



    wait for 1 us;




    wait;
  end process Host;
 
  Sink : process is
  begin  -- process Sink

    ExpectPacket(sFromHost.DPort, iFx2Clk, FlipBytes(x"CC"));

        ExpectPacket(sFromHost.DPort, iFx2Clk, FlipBytes(x"FFAAFFBBFFCCFF"));
    wait for 10 ms;
    sEndOfSim <= '1';
    wait;
  end process Sink;
  sFromHost.Ack <= sFromHost.DPort.Valid;

  Source : process is
  begin  -- process T51Sim
    wait until inResetAsync = '1';
    wait for 100 ns;                    -- wait until interface is ready
    for i in 0 to 20000 loop
      sPacketNr <= sPacketNr + 1;
      SendPacket(sToHost.DPort, sToHost.Ack, iFx2Clk, FlipBytes(x"12345678123456781234567812345678"), cIdCpu);
    end loop;
    wait for 1 ms;
    wait;
  end process Source;



  PacketDecoder_1 : entity misc.PacketDecoder(Rtl)
    port map (
      iClk         => iFx2Clk,
      inResetAsync => inResetAsync,
      iDin         => oData,
      iValid       => oValid,
      oAckIn       => iAck,
      oDout        => sFromHost.DPort,
      iAckOut      => sFromHost.Ack);

  PacketEncoder_1 : entity misc.PacketEncoder(Rtl)
    port map (
      iClk         => iFx2Clk,
      inResetAsync => inResetAsync,
      iDin         => sToHost.DPort,
      oAckIn       => sToHost.Ack,
      oDout        => iData,
      oEof         => iEndOfPacket,
      oBusy        => open,
      iAckOut      => oAck,
      oValid       => iValid,
      iTs => iTs);



end architecture Bhv;
