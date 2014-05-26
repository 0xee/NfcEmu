
-------------------------------------------------------------------------------
-- Title      : tbProtocolProcessor
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tbProtocolProcessor-Bhv-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-09-20
-- Last update: 2014-05-22
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: T51 Interface testbench
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-09-20  1.0      lukas   Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library global;
use global.Global.all;

library nfc;
use nfc.Nfc.all;

library work;

library fw;

library nfcemu;
use nfcemu.nfcemupkg.all;

entity tbProtocolProcessor is

end entity tbProtocolProcessor;

architecture Bhv of tbProtocolProcessor is
  constant gNrPorts : natural := 2;

  signal iClk         : std_ulogic := '1';
  signal inResetAsync : std_ulogic := '0';
  signal iInputPorts  : aDataPortArray(gNrPorts-1 downto 0);
  signal oInputAck    : std_ulogic_vector(gNrPorts-1 downto 0);
  signal oOutputPorts : aDataPortArray(gNrPorts-1 downto 0);
  signal iOutputAck   : std_ulogic_vector(gNrPorts-1 downto 0);

  signal sCpuRunning : std_ulogic;

  signal sToHost, sFromHost, sFromPicc, sToPicc, sFwIn : aDataPortConnection;

  signal sRomAdr  : std_logic_vector(11 downto 0);
  signal sRomData : std_logic_vector(7 downto 0);

  constant cMaxPacketSize : natural := 256;

  signal sFilePacket      : std_ulogic_vector(8*cMaxPacketSize-1 downto 0);
  signal sFilePacketLen   : natural;
  signal sFilePacketValid : std_ulogic;
  signal sFileAck         : std_ulogic;

  signal sCpuReady : std_ulogic;
  
  constant cClkPeriod : time := 1 sec / cNfcClkFreq;

  
begin  -- architecture Bhv

  iClk         <= not iClk after cClkPeriod/2;
  inResetAsync <= '1'      after 20 ns;

  iInputPorts(0) <= sFromHost.DPort;
  sFromHost.Ack        <= oInputAck(0);

  iOutputAck(0)  <= sToHost.Ack;
  sToHost.DPort     <= oOutputPorts(0);

  iInputPorts(1) <= sFromPicc.DPort;
  sFromPicc.Ack <= oInputAck(1);

  iOutputAck(1) <= sToPicc.Ack;
  sToPicc.DPort <= oOutputPorts(1);
  
  LogReader_1 : entity work.LogReader(Bhv)
    generic map (
      gFileName      => "../sim/picc.log",
      gMaxPacketSize => cMaxPacketSize,
      gTsUnit        => 10 ns)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      oPacket      => sFilePacket,
      oLen         => sFilePacketLen,
      oValid       => sFilePacketValid,
      iAck         => sFileAck);

  sFileAck <= sFilePacketValid when rising_edge(iClk);

  Writer : process is
    constant cToSend : natural := 4;
  begin  -- process Writer
    InitPort(sFromHost.DPort);
    InitPort(sFromPicc.DPort);

    wait until sCpuReady;

    SendPacket(sFromHost.DPort, sFromHost.Ack, iClk, x"02");

    picc_packets : loop
      wait until rising_edge(iClk) and sFilePacketValid = '1';
      SendPacket(sFromPicc.DPort, sFromPicc.Ack, iClk, sFilePacket(sFilePacketLen-1 downto 0));
    end loop;
    
    wait;
  end process Writer;

  
  
  sToHost.Ack <= sToHost.DPort.Valid;

  HostReader : process is
    variable vCount : natural := 0;
    
  begin  -- process Reader
    sCpuReady <= '0';
    
    ExpectPacket(sToHost.DPort, sToHost.Ack, FlipBytes(x"08"));
    Info("CPU Ready");
    sCpuReady <= '1';
    
    ExpectPacket(sToHost.DPort, sToHost.Ack, FlipBytes(x"0002"));

    wait;
  end process HostReader;

  sToPicc.Ack <= sToPicc.DPort.Valid;
  
 PiccReader : process is
    variable vCount : natural := 0;
    
  begin  -- process Reader

    
    
    wait;
  end process PiccReader;






  

  
  ProtocolProcessor_1 : entity nfcemu.ProtocolProcessor
    generic map (
      gNrPorts => gNrPorts)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iInputPorts  => iInputPorts,
      oInputAck    => oInputAck,
      oOutputPorts => oOutputPorts,
      iOutputAck   => iOutputAck,
      iFwIn        => sFwIn.DPort,
      oFwAck       => sFwIn.Ack,
      oP0          => open,
      oCpuRunning  => sCpuRunning);

  sFwIn.DPort.Data <= sRomData;
  sFwIn.DPort.Eof  <= '0';

  WriteFw : process is
    constant cRomSize : natural := 2**12;
  begin  -- process WriteFw
    sRomAdr           <= (others => '0');
    sFwIn.DPort.Valid <= '0';
    wait for 10 us;
    wait until rising_edge(iClk);
    sFwIn.DPort.Valid <= '1';

    for i in 1 to cRomSize-1 loop
      sRomAdr <= std_logic_vector(to_unsigned(i, 12));
      wait until rising_edge(iClk) and sFwIn.Ack = '1';
    end loop;  -- i
    wait until rising_edge(iClk) and sFwIn.Ack = '1';
    sFwIn.DPort.Valid <= '0';
    wait;
  end process WriteFw;


  ROM52_1 : entity fw.ROM52(Rtl)
    port map (
      Clk => iClk,
      A   => sRomAdr,
      D   => sRomData);




end architecture Bhv;


