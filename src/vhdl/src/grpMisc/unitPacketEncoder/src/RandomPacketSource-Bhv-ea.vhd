-------------------------------------------------------------------------------
-- Title      : RandomPacketSource
-- Project    : 
-------------------------------------------------------------------------------
-- File       : RandomPacketSource-Bhv-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2014-03-29
-- Last update: 2014-04-30
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-03-29  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library osvvm;
use osvvm.RandomPkg.all;

library global;
use global.global.all;

library global;
use global.SimUtil.all;

entity RandomPacketSource is
  generic (
    gMaxLen      : natural                       := 512;
    gMaxInterval : natural                       := 1000;
    gStaticId    : boolean                       := false;
    gSeed        : natural                       := 1234;
    gId          : std_ulogic_vector(7 downto 0) := x"99";
    gDle         : std_ulogic_vector(7 downto 0) := x"EE");

  port (
    iClk         : in  std_ulogic;
    inInit       : in  std_ulogic;
    iEnable      : in  std_ulogic;
    iBusy        : in  std_ulogic;
    oDout        : out aDataPort;
    iAckOut      : in  std_ulogic;
    oDleInData   : out natural;
    oTxBytes     : out natural;
    oPacketLen   : out natural;
    oPacketCount : out natural
    );
end entity RandomPacketSource;

architecture Bhv of RandomPacketSource is
  signal sDleInData, sTxBytes, sPacketCount : natural;
begin  -- architecture Bhv

  oDleInData   <= sDleInData;
  oTxBytes     <= sTxBytes;
  oPacketCount <= sPacketCount;

  Sender : process is
    variable vDel : natural;
    variable rv   : RandomPType;
    procedure SendPacket is
      variable vLen    : natural;
      variable vId, vD : std_ulogic_vector(7 downto 0);
    begin
      InitPort(oDout);
      if gStaticId then
        vId := gId;
      else
        vId := rv.RandSlv(vId'length);
      end if;

      report "Id: " & integer'image(to_integer(unsigned(vId))) severity note;
      oDout.Id   <= vId;
      sDleInData <= 0;
      vLen       := rv.RandInt(1, gMaxLen);
      oPacketLen <= vLen;
      sTxBytes   <= 0;
      wait for 0 ns;

      for i in 0 to vLen-1 loop
        vD := rv.RandSlv(vD'length);
        if vD = gDle then
          sDleInData <= sDleInData + 1;
        end if;

        WaitRandom(iClk, rv, 4);
        sTxBytes <= sTxBytes + 1;
        wait for 0 ns;
        Send(oDout, iAckOut, iClk, vD, i = vLen -1);
      end loop;  -- i

      
    end;

  begin  -- process Send

    rv.InitSeed(RV'instance_name);
    wait until rising_edge(iClk) and inInit = '1';

    for i in 0 to 5 loop
      Send(oDout, iAckOut, iClk, x"0A", false);
      wait for 200 ns;
    end loop; 
    Send(oDout, iAckOut, iClk, x"0B", true);
    wait for 1 us;
    while iEnable = '1' loop
      
      report "Sending packet #" & integer'image(sPacketCount) severity note;
      --   wait until rising_edge(iClk) and iBusy = '0';
      SendPacket;
      sPacketCount <= sPacketCount + 1;
--      wait until rising_edge(sReceived);
      WaitRandom(iClk, rv, gMaxInterval);

      wait until rising_edge(iClk);
    end loop;

    wait;
    
  end process Sender;


end architecture Bhv;
