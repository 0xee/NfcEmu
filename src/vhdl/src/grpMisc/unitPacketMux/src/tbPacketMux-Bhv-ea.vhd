-------------------------------------------------------------------------------
-- Title      : tbPacketMux
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tbPacketMux-Bhv-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2014-03-29
-- Last update: 2014-04-10
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: testbench for unit PacketMux
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-03-29  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library osvvm;
use osvvm.RandomPkg.all;

library global;
use global.global.all;
use global.SimUtil.all;

library misc;

entity tbPacketMux is

end entity tbPacketMux;

architecture Bhv of tbPacketMux is
  constant cSources : natural := 4;
  constant cToSend  : natural := cSources*100;
  constant cMaxLen : natural := 32;
  constant cClkPeriod : time := 10 ns;

  signal iClk         : std_ulogic := '1';
  signal inResetAsync : std_ulogic;
  signal iPortIn      : aDataPortArray(cSources-1 downto 0);
  signal oPortOut     : aDataPort;
  signal iAckOut      : std_ulogic;
  signal oAckIn       : std_ulogic_vector(cSources-1 downto 0);

  signal sEnableSources, sEndOfSim : std_ulogic;
  signal sSinkBusy                 : std_ulogic;


  signal oDleInData   : integer_vector(cSources-1 downto 0);
  signal oTxBytes     : integer_vector(cSources-1 downto 0);
  signal oPacketLen   : integer_vector(cSources-1 downto 0);
  signal oPacketCount : integer_vector(cSources-1 downto 0);

  signal sTotalPacketCount, sRxPacketCount, sRxPacketLen, sRxBytes, sDleInRxData : integer;
  signal sSerialOut, sId                                                    : std_ulogic_vector(7 downto 0);
  signal sSerialAck, sSerialValid, sEncoderBusy                             : std_ulogic;

  signal sSelectedPort : natural;

  
begin  -- architecture Bhv

  inResetAsync <= '0' after 0 ns,
                  '1' after 2*cClkPeriod;

  iClk <= (not iClk) and (not sEndOfSim) after cClkPeriod/2;

  sEndOfSim <= '1' when sTotalPacketCount = cToSend else
               '0';
  sEnableSources <= not sEndOfSim;

  Sources : for i in 0 to cSources-1 generate

    RandomPacketSource_1 : entity misc.RandomPacketSource
      generic map (
        gSeed => i,
        gMaxInterval => 16*cSources*(2+i)*cMaxLen,
        gMaxLen => cSources*(2+i)*cMaxLen)
      port map (
        iClk         => iClk,
        inInit       => inResetAsync,
        iEnable      => sEnableSources,
        iBusy        => sSinkBusy,
        oDout        => iPortIn(i),
        iAckOut      => oAckIn(i),
        oDleInData   => oDleInData(i),
        oTxBytes     => oTxBytes(i),
        oPacketLen   => oPacketLen(i),
        oPacketCount => oPacketCount(i));

  end generate Sources;

  sTotalPacketCount <= Sum(oPacketCount);

  DUT : entity misc.PacketMux
    generic map (
      gScheduler => RoundRobin)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iPortIn      => iPortIn,
      oPortOut     => oPortOut,
      iAckOut      => iAckOut,
      oDbgSelected => sSelectedPort,
      oAckIn       => oAckIn);

  PacketEncoder_1 : entity misc.PacketEncoder
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => oPortOut,
      oAckIn       => iAckOut,
      oDout        => sSerialOut,
      oBusy        => sEncoderBusy,
      iAckOut      => sSerialAck,
      oValid       => sSerialValid);

  SerialPacketSink_1 : entity misc.SerialPacketSink
    port map (
      iClk         => iClk,
      inInit       => inResetAsync,
      iDin         => sSerialOut,
      iValid       => sSerialValid,
      oAckIn       => sSerialAck,
      iEnable      => '1',
      oId          => sId,
      oDleInData   => sDleInRxData,
      oRxBytes     => sRxBytes,
      oPacketLen   => sRxPacketLen,
      oPacketCount => sRxPacketCount);


  Checker : process (sRxPacketLen, oPacketLen) is
  begin  -- process Checker
    
    if sRxPacketLen'event then
      assert sRxPacketLen = oPacketLen(sSelectedPort) report "Data length error (" & integer'image(sRxPacketLen) & " vs " & integer'image(oPacketLen(sSelectedPort)) & ")" severity failure;

      assert sId = iPortIn(sSelectedPort).Id report "Id error" severity failure;

      assert oDleInData(sSelectedPort) = sDleInRxData report "DLE count error" severity failure;
      
    end if;
    
  end process Checker;

  DistributionChecker : process (sEndOfSim, sTotalPacketCount, oPacketCount)
    constant cMinShare : natural := 40;
    variable vMin    : natural;
  begin
    if sEndOfSim = '1' then
      
      vMin := cMinShare*sTotalPacketCount/(100*oPacketCount'length);
      for i in oPacketCount'range loop
        assert vMin < oPacketCount(i) report "Port " & integer'image(i) &
          " has only contributed " & integer'image(oPacketCount(i)) &
          " of " & integer'image(sTotalPacketCount) & " Packets" severity failure;
      end loop;  -- i
    end if;
  end process DistributionChecker;

  

end architecture Bhv;
