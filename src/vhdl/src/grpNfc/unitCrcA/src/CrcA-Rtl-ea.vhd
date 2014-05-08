-------------------------------------------------------------------------------
-- Title      : CRCA
-- Project    : 
-------------------------------------------------------------------------------
-- File       : CrcA-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-08-29
-- Last update: 2013-12-20
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Calculates CRCA of an bitstream
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-08-29  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity CrcA is

  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iSyncReset   : in  std_ulogic;
    iDin         : in  std_ulogic_vector(7 downto 0);
    iValid       : in  std_ulogic;
    oCrcSum      : out std_ulogic_vector(15 downto 0)
    );

end entity CrcA;

architecture Rtl of CrcA is

  signal rCrcReg : std_ulogic_vector(15 downto 0);

  constant cPoly    : std_ulogic_vector(15 downto 0) := x"1021";
  constant cInitVal : std_ulogic_vector(15 downto 0) := x"6363";

begin  -- architecture Rtl
  
  oCrcSum <= rCrcReg;

  UpdateCrc : process (iClk, inResetAsync) is
    variable vC : std_ulogic_vector(7 downto 0);
  begin  -- process UpdateCrc
    if inResetAsync = '0' then          -- asynchronous reset (active low)
      rCrcReg <= cInitVal;
    elsif rising_edge(iClk) then        -- rising clock edge
      if iSyncReset = '1' then
        rCrcReg <= cInitVal;
      elsif iValid = '1' then

        vC := iDin xor rCrcReg(7 downto 0);
        vC := vC xor (vC(3 downto 0) & "0000");

        rCrcReg <= (x"00" & rCrcReg(15 downto 8)) xor
                   (vC & x"00") xor
                   ("00000" & vC & "000") xor
                   (x"000" & vC(7 downto 4));
        
      end if;
    end if;
  end process UpdateCrc;

end architecture Rtl;
