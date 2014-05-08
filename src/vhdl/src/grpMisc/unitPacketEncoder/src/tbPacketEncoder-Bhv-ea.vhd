library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library global;
use global.Global.all;

library osvvm;
use osvvm.RandomPkg.all;

library misc;

entity tbPacketEncoder is

end entity tbPacketEncoder;

architecture Bhv of tbPacketEncoder is

  constant cClkPeriod : time := 10 ns;

  signal iClk          : std_ulogic := '0';
  signal inResetAsync  : std_ulogic;
  signal iDin          : aDataPort;
  signal oAckIn        : std_ulogic;
  signal oDout, sRxId  : std_ulogic_vector(7 downto 0);
  signal iAckOut       : std_ulogic;
  signal oValid, oBusy : std_ulogic;

  constant cStartByte : std_ulogic_vector := x"AA";
  constant cStopByte  : std_ulogic_vector := x"CC";
  constant cDle       : std_ulogic_vector := x"EE";

  signal sReceived : std_ulogic;
  signal sEndOfSim : std_ulogic := '0';
  signal sPacketLen, sRxPacketLen, sRxPacketCount,
    sRxBytes, sTxBytes, sDleInData, sDleInRxData, sPacketCount : natural;

  constant cToSend     : natural    := 1000;
  constant cMaxLen     : natural    := 512;
  signal sOne          : std_ulogic := '1';
  signal sEnableSender : std_ulogic;
  
begin  -- architecture Bhv

  iClk <= not iClk after cClkPeriod/2 when sEndOfSim = '0' else
          '0';

  
  inResetAsync <= '0' after 0 ns,
                  '1' after 20 ns;
  
  PacketEncoder_1 : entity misc.PacketEncoder(Rtl)
    generic map (
      gStartByte      => cStartByte,
      gStopByte       => cStopByte,
      gDataLinkEscape => cDle)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => iDin,
      oAckIn       => oAckIn,
      oDout        => oDout,
      oBusy        => oBusy,
      iAckOut      => iAckOut,
      oValid       => oValid);

  RandomPacketSource_1 : entity misc.RandomPacketSource
    generic map (
      gMaxLen => cMaxLen,
      gDle    => cDle)
    port map (
      iClk         => iClk,
      inInit       => inResetAsync,
      iEnable      => sEnableSender,
      iBusy        => oBusy,
      oDout        => iDin,
      iAckOut      => oAckIn,
      oDleInData   => sDleInData,
      oTxBytes     => sTxBytes,
      oPacketLen   => sPacketLen,
      oPacketCount => sPacketCount);

  sEndOfSim <= '1' when sPacketCount = cToSend else
               '0';
  sEnableSender <= not sEndOfSim;

  SerialPacketSink_1 : entity misc.SerialPacketSink
    generic map (
      gStartByte => cStartByte,
      gStopByte  => cStopByte,
      gDle       => cDle)
    port map (
      iClk         => iClk,
      inInit       => inResetAsync,
      iDin         => oDout,
      iValid       => oValid,
      oAckIn       => iAckOut,
      iEnable      => '1',
      oId          => sRxId,
      oDleInData   => sDleInRxData,
      oRxBytes     => sRxBytes,
      oPacketLen   => sRxPacketLen,
      oPacketCount => sRxPacketCount);

  Checker : process (sRxPacketLen, sPacketLen) is
  begin  -- process Checker
      
    if sRxPacketLen'event then
      assert sRxPacketLen = sPacketLen report "Data length error (" & integer'image(sRxPacketLen) & " vs " & integer'image(sPacketLen) & ")" severity failure;

      assert sRxId = iDin.Id report "Id error" severity failure;

      assert sDleInData = sDleInRxData report "DLE count error" severity failure;
      
    end if;
    
  end process Checker;
  
end architecture Bhv;
