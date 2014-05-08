-------------------------------------------------------------------------------
-- Title      : Parallelizer
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Parallelizer-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2012-12-05
-- Last update: 2013-06-15
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Converts from wider to smaller vectorstreams using valid/stall
-- interface
-------------------------------------------------------------------------------
-- Copyright (c) 2012 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-12-05  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library	global;
use global.Global.all;


entity Parallelizer is
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iData        : in  std_ulogic_vector;
    oData        : out std_ulogic_vector;
    iValid       : in  std_ulogic;
    oValid       : out std_ulogic;
    oAck         : out std_ulogic;
    iAck         : in  std_ulogic;
    oEmpty       : out  std_ulogic);
begin
  assert (oData'length mod iData'length) = 0
    report "Output width must be multiple of input width"
    severity failure;
  
end entity Parallelizer;

architecture Rtl of Parallelizer is
  constant cSlices : natural := oData'length / iData'length;


  type aRegSet is record
    Slice     : unsigned(LogDualis(cSlices)-1 downto 0);
    DShift    : std_ulogic_vector(oData'length-1 downto 0);
    Dout      : std_ulogic_vector(oData'length-1 downto 0);
    ValidOut  : std_ulogic;
  end record;

  constant cRegInitVal : aRegSet := (Slice     => (others => '0'),
                                     DShift    => (others => '0'),
                                     Dout      => (others => '0'),
                                     ValidOut  => '0');

  signal R, NextR : aRegSet;
  
begin  -- architecture Rtl

  Comb : process (R, iValid, iData, iAck)
  begin  -- process Comb
    oAck  <= '0';
    NextR <= R;

    if R.ValidOut = '1' and iAck = '1' then
      NextR.ValidOut <= '0';
    end if;

    if iValid = '1' then
      if R.Slice = cSlices-1 then
        if R.ValidOut = '0' or iAck = '1' then
          oAck           <= '1';
          NextR.ValidOut <= '1';
          NextR.Slice    <= to_unsigned(0, R.Slice'length);
          NextR.Dout     <= iData & R.DShift(R.DShift'left downto iData'length);
        end if;
        
      else
        oAck         <= '1';
        NextR.Slice  <= R.Slice + 1;
        NextR.DShift <= iData & R.DShift(R.DShift'left downto iData'length);
      end if;
    end if;
    
  end process Comb;
  
  oValid <= R.ValidOut;
  oData  <= R.Dout;

  oEmpty <= '1' when R.Slice = 0 else
            '0';
  
  Reg : process (iClk, inResetAsync)
  begin  -- process Reg
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      R <= cRegInitVal;
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      R <= NextR;
    end if;
  end process Reg;

end architecture Rtl;
