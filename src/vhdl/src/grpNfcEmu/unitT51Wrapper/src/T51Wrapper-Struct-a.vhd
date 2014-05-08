-------------------------------------------------------------------------------
-- Title      : T51Wrapper
-- Project    : 
-------------------------------------------------------------------------------
-- File       : T51Wrapper-Struct-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-09-20
-- Last update: 2014-04-16
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 

-- Revisions  :
-- Date        Version  Author  Description
-- 2013-09-20  1.0      lukas	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library t51;

architecture Struct of T51Wrapper is

  signal sWbCyc, sWbStb, sWbWe : std_ulogic;
  signal sP0 : std_logic_vector(oP0'range);
signal sWbDout : std_logic_vector(oWbDout'range);
  signal sWbAdr : std_logic_vector(oWbAdr'range);

  signal sRomAdr : std_logic_vector(gRomWidth-1 downto 0);
begin  -- architecture Struct

  oP0 <= std_ulogic_vector(sP0);
oWbDout <= std_ulogic_vector(sWbDout);
  oWbAdr <= std_ulogic_vector(sWbAdr);
  
  
  T8052_1: entity t51.T8052
    generic map (
      ROMAddressWidth  => gRomWidth,
      XRAMAddressWidth => gXRamWidth)
    port map (
      Clk        => iClk,
      Rst_n      => inResetAsync,
      P0_in      => std_logic_vector(iP0),
      P1_in      => (others => '0'),
      P2_in      => (others => '0'),
      P3_in      => (others => '0'),
      P0_out     => sP0,
      P1_out     => open,
      P2_out     => open,
      P3_out     => open,
      INT0       => '0', INT1       => '0',
      T0         => '0', T1         => '0',
      T2         => '0', T2EX       => '0',
      RXD        => '0',
      RXD_IsO    => open, RXD_O      => open,
      TXD        => open,
      XRAM_WE_O  => sWbWe,
      XRAM_STB_O => sWbStb,
      XRAM_CYC_O => sWbCyc,
      XRAM_ACK_I => iWbAck,
      XRAM_DAT_O => sWbDout,
      XRAM_ADR_O => sWbAdr,
      XRAM_DAT_I => std_logic_vector(iWbDin),
      oRomAdr => sRomAdr,
      iRomData => std_logic_vector(iRomData));  

  oRomAdr <= std_ulogic_vector(sRomAdr);
  
  oWbWrStb <= sWbCyc and sWbStb and sWbWe;
  oWbRdStb <= sWbCyc and sWbStb and not sWbWe;
  
end architecture Struct;
