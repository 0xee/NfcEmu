-------------------------------------------------------------------------------
-- Title      : StreamPacketizer
-- Project    : 
-------------------------------------------------------------------------------
-- File       : StreamPacketizer-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2014-04-06
-- Last update: 2014-04-06
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Packs a continous data stream into DataPort packets
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-04-06  1.0      lukas   Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library global;
use global.Global.all;

library misc;

entity StreamPacketizer is
  
  generic (
    gId         : std_ulogic_vector;
    gMaxLen     : natural := 512;
    gFifoLength : natural := 32
    -- todo: idle timeout
    );

  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iDin         : in  std_ulogic_vector;
    iValid       : in  std_ulogic;
    oPacket      : out aDataPort;
    iPacketAck   : in  std_ulogic);

end entity StreamPacketizer;

architecture Rtl of StreamPacketizer is

  signal rPacketLen : natural range 0 to gMaxLen-1;
  signal sPacket    : aDataPort;
  signal sEof       : std_ulogic;
begin  -- architecture Rtl

  Fifo_1 : entity misc.Fifo
    generic map (
      gDepth => gFifoLength)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => ComposePort(x"00", iDin, iValid, '0', '-'),
      oAck         => open,
      oDout        => sPacket,
      iAck         => iPacketAck);

  sEof <= '1' when rPacketLen = gMaxLen-1 else
          '0';

  oPacket <= SetId(SetEof(sPacket, sEof), gId);

  Counter : process (iClk, inResetAsync) is
  begin  -- process Counter
    if inResetAsync = '0' then          -- asynchronous reset (active low)
      rPacketLen <= 0;
    elsif rising_edge(iClk) then        -- rising clock edge
      if iPacketAck then
        if sEof then
          rPacketLen <= 0;
        else
          rPacketLen <= rPacketLen + 1;
        end if;
      end if;
    end if;
  end process Counter;

end architecture Rtl;
