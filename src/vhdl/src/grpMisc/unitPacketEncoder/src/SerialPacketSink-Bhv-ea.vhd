-------------------------------------------------------------------------------
-- Title      : SerialPacketSink
-- Project    : 
-------------------------------------------------------------------------------
-- File       : SerialPacketSink-Bhv-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2014-03-29
-- Last update: 2014-04-23
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

entity SerialPacketSink is
  generic (
    gStartByte : std_ulogic_vector(7 downto 0) := x"AA";
    gStopByte  : std_ulogic_vector(7 downto 0) := x"CC";
    gDle       : std_ulogic_vector(7 downto 0) := x"EE";
    gEnableStats : boolean := true);

  port (
    iClk         : in  std_ulogic;
    inInit       : in  std_ulogic;
    iDin         : in  std_ulogic_vector(7 downto 0);
    iValid       : in  std_ulogic;
    oAckIn       : out std_ulogic;
    iEnable      : in  std_ulogic;
    oId          : out std_ulogic_vector(7 downto 0);
    oDleInData   : out natural;
    oRxBytes     : out natural;
    oPacketLen   : out natural;
    oPacketCount : out natural
    );
end entity SerialPacketSink;

architecture Bhv of SerialPacketSink is
  signal sDleInData, sTxBytes, sPacketCount : natural;
begin  -- architecture Bhv

  Receiver : process is
    variable rv : RandomPType;

    procedure Ack is
      variable vWait : natural;
    begin
      WaitRandom(iClk, rv, 4);

      oAckIn <= '1';
      wait until rising_edge(iClk);
      oAckIn <= '0';
    end;

    variable vEsc       : boolean;
    variable vBreak     : boolean;
    variable vDleCount  : natural;
    variable vDataCount : natural;
  begin
    rv.InitSeed(0);

    rv.InitSeed(RV'instance_name);
    wait until rising_edge(iClk) and inInit = '1';

    while iEnable = '1' loop
      
      
      oAckIn <= '0';
      wait until rising_edge(iClk) and iValid = '1';
      -- start byte
      assert iDin = gStartByte report "Start byte error" severity failure;
      Ack;

      -- id
      wait until rising_edge(iClk) and iValid = '1';
      oId <= iDin;
--      assert iDin = iId report "Id error" severity failure;
      Ack;


      -- ts
      for i in 0 to 3 loop
        wait until rising_edge(iClk) and iValid = '1';
        Ack;
      end loop;  -- i



      -- data
      vBreak     := false;
      vDleCount  := 0;
      vEsc       := false;
      vDataCount := 0;
      oRxBytes   <= 0;

      while not vBreak loop

        wait until rising_edge(iClk) and iValid = '1';



        if vEsc then
          -- if escaped, only stop or dle allowed
          if iDin = gStopByte then
            vBreak := true;
          elsif iDin = gDle then
            vEsc       := false;
            vDleCount  := vDleCount + 1;
--              report "rx dle" severity note;
            vDataCount := vDataCount + 1;
          else
            assert false report "DLE error" severity failure;
          end if;
        else

          if iDin = gDle then
            vEsc := true;
          else
--              report "rx" severity note;
            vDataCount := vDataCount + 1;
          end if;


        end if;

        Ack;

        oRxBytes <= vDataCount;
        
      end loop;

      --wait until rising_edge(iClk) and iValid = '1';
      --report "Stats: " & ToHex(iDin);
      --Ack;
      
      sPacketCount <= sPacketCount + 1;
      wait until rising_edge(iClk);

--      report "Packet Received" severity note;
    end loop;

    wait;
  end process Receiver;

  oPacketCount <= sPacketCount;

end architecture Bhv;
