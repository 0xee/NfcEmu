-------------------------------------------------------------------------------
-- Title      : Serial DAC
-- Project    : 
-------------------------------------------------------------------------------
-- File       : SerialDac-e.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-06
-- Last update: 2013-06-13
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Control for Saxo Q pre-amp DACs
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-06  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SerialDac is
  
  generic (
    gClkFreq  : natural := 48e6;
    gSClkFreq : natural := 100e3);       -- ~100khz (48e6/512)
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iValid       : in  std_ulogic;
    iUpdateCD    : in  std_ulogic;
    oAck         : out std_ulogic;
    iDacA        : in  std_ulogic_vector(7 downto 0);
    iDacB        : in  std_ulogic_vector(7 downto 0);
    iDacC        : in  std_ulogic_vector(7 downto 0);
    iDacD        : in  std_ulogic_vector(7 downto 0);
    oDacCtrl     : out std_ulogic);

end SerialDac;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library periph;

entity tbSerialDac is

end tbSerialDac;

architecture Bhv of tbSerialDac is
  signal iClk         : std_ulogic := '0';
  signal inResetAsync : std_ulogic;
  signal iValid       : std_ulogic;
  signal oAck         : std_ulogic;
  signal iDacA        : std_ulogic_vector(7 downto 0);
  signal iDacB        : std_ulogic_vector(7 downto 0);
  signal iDacC        : std_ulogic_vector(7 downto 0);
  signal iDacD        : std_ulogic_vector(7 downto 0);
  signal oDacCtrl     : std_ulogic;

begin  -- Bhv

  SerialDac_1 : entity periph.SerialDac
    generic map (
      gClkFreq  => 48e6,
      gSClkFreq => 48e6/512)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iValid       => iValid,
      iUpdateCD    => '0',
      oAck         => oAck,
      iDacA        => iDacA,
      iDacB        => iDacB,
      iDacC        => iDacC,
      iDacD        => iDacD,
      oDacCtrl     => oDacCtrl);

  iClk <= not iClk after 5 ns;

  inResetAsync <= '0' after 0 ns,
                  '1' after 20 ns;

  iDacA <= "11000000";
  iDacB <= "10000000";
  iDacC <= "11000000";
  iDacD <= "10000000";

  iValid <= '0' after 0 ns,
            '1' after 573425 ns,
            '0' after 573435 ns;
end Bhv;
