
-------------------------------------------------------------------------------
-- Title      : tbProtocolProcessor
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tbProtocolProcessor-Bhv-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-09-20
-- Last update: 2014-04-03
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

entity tbProtocolProcessor is

end entity tbProtocolProcessor;

architecture Bhv of tbProtocolProcessor is
  constant gNrPorts : natural := 1;
  
  signal iClk         : std_ulogic := '1';
  signal inResetAsync : std_ulogic := '0';
  signal iInputPorts  : aDataPortArray(gNrPorts-1 downto 0);
  signal oInputAck    : std_ulogic_vector(gNrPorts-1 downto 0);
  signal oOutputPorts : aDataPortArray(gNrPorts-1 downto 0);
  signal iOutputAck   : std_ulogic_vector(gNrPorts-1 downto 0);

  signal sOut, sIn, sFwIn       : aDataPort;
  signal sAckIn, sAckOut, sFwAck : std_ulogic;

  signal sRomAdr : std_logic_vector(11 downto 0);
  signal sRomData : std_logic_vector(7 downto 0);
  
begin  -- architecture Bhv

  iClk         <= not iClk after 5 ns;
  inResetAsync <= '1'      after 20 ns;

  iInputPorts(0) <= sIn;
  sOut           <= oOutputPorts(0);
  iOutputAck(0)  <= sAckOut;
  sAckIn         <= oInputAck(0);

  Writer : process is
    constant cToSend : natural := 4;
  begin  -- process Writer
    InitPort(sIn);

    wait for 200 us;

    for n in 0 to 3 loop
      report "Sending " & integer'image(cToSend) & " bytes";
      sIn.Valid <= '1';
      for i in 0 to cToSend-1 loop
        sIn.Data <= std_ulogic_vector(to_unsigned(i, 8));
        if i = cToSend-1 then
          sIn.Eof <= '1';
        end if;
        wait until rising_edge(iClk) and sAckIn = '1';
      end loop;  -- i
      sIn.Valid <= '0';
      sIn.Eof   <= '0';
      report "Packet sent";
      wait for 100 us;
    end loop;  -- n
    wait;
  end process Writer;

  sAckOut <= sOut.Valid;

  Reader : process is
    variable vCount : natural := 0;
    
  begin  -- process Reader

    while true loop
      wait until rising_edge(iClk);
      if sOut.Valid = '1' then
        vCount := vCount + 1;
        if sOut.Eof = '1' then
          report "Received " & integer'image(vCount) & " bytes from id " & to_hstring(sOut.Id) severity note;
          vCount := 0;
        end if;
      end if;
    end loop;

    wait;
  end process Reader;

  ProtocolProcessor_1: entity nfcemu.ProtocolProcessor
    generic map (
      gNrPorts => gNrPorts)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iInputPorts  => iInputPorts,
      oInputAck    => oInputAck,
      oOutputPorts => oOutputPorts,
      iOutputAck   => iOutputAck,
      iFwIn        => sFwIn,
      oFwAck       => sFwAck);

  sFwIn.Data <= sRomData;
  sFwIn.Eof <= '0';
  
  WriteFw: process is
    constant cRomSize : natural := 2**12;
  begin  -- process WriteFw
    sRomAdr <= (others => '0');
    sFwIn.Valid <= '0';
    wait for 10 us;
    wait until rising_edge(iClk);
    sFwIn.Valid <= '1';
    
    for i in 1 to cRomSize-1 loop
      sRomAdr <= std_logic_vector(to_unsigned(i,12));
      wait until rising_edge(iClk) and sFwAck = '1';
    end loop;  -- i
    wait until rising_edge(iClk) and sFwAck = '1';
    sFwIn.Valid <= '0';
    wait;
  end process WriteFw;
  

  ROM52_1: entity fw.ROM52
    port map (
      Clk => iClk,
      A   => sRomAdr,
      D   => sRomData);



  
end architecture Bhv;


