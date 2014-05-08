-------------------------------------------------------------------------------
-- Title      : FwRam
-- Project    : 
-------------------------------------------------------------------------------
-- File       : FwRam-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-09-22
-- Last update: 2013-10-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Updateable Firmware RAM for T51
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-09-22  1.0      lukas	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FwRam is
  
  generic (
    gWidth : natural := 12);
  port (
    iClk   : in std_ulogic;
    iWrStb    : in std_ulogic;
    iWrAdr : in std_ulogic_vector(gWidth-1 downto 0);
    iData : in std_ulogic_vector(7 downto 0);
    iRdAdr : in std_ulogic_vector(gWidth-1 downto 0);
    oData : out std_ulogic_vector(7 downto 0)
    );
end entity FwRam;

architecture Rtl of FwRam is
  constant cRamSize : natural := 2**gWidth;

  type aRamImage is array (cRamSize-1 downto 0) of std_ulogic_vector(7 downto 0);

  signal sRam : aRamImage;
  
begin  -- architecture FwRam

  RamAccess: process (iClk) is
  begin  -- process RamAccess
    if rising_edge(iClk) then        -- rising clock edge

      if iWrStb = '1' then
        sRam(to_integer(unsigned(iWrAdr))) <= iData;
      else
        oData <= sRam(to_integer(unsigned(iRdAdr)));
      end if;
      
    end if;
  end process RamAccess;

end architecture Rtl;
