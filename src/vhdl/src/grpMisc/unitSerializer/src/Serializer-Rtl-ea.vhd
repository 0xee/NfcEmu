-------------------------------------------------------------------------------
-- Title      : Serializer
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Serializer-Rtl-ea.vhd
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


entity Serializer is
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iData        : in  std_ulogic_vector;
    oData        : out std_ulogic_vector;
    iValid       : in  std_ulogic;
    oValid       : out std_ulogic;
    oAck         : out std_ulogic;
    iAck         : in  std_ulogic);
begin
  assert (iData'length mod oData'length) = 0
    report "Input width must be multiple of output width"
    severity failure;
  
end entity Serializer;

architecture Rtl of Serializer is
  constant cSlices : natural := iData'length / oData'length;

  type aRegSet is record
    DataAvailable : std_ulogic;
    Data          : std_ulogic_vector(iData'length-1 downto 0);
    Slice         : unsigned(LogDualis(cSlices)-1 downto 0);
  end record;

  constant cRegInitVal : aRegSet := (DataAvailable => '0',
                                     Data          => (others => '0'),
                                     Slice         => (others => '0'));

  signal R, NextR : aRegSet;
  
begin  -- architecture Rtl

  Comb : process (R, iValid, iData, iAck)
  begin  -- process Comb
    oValid <= '0';
    oAck   <= '0';
    NextR  <= R;

    if R.DataAvailable = '0' then

      if iValid = '1' then
        oAck                <= '1';
        NextR.Data          <= iData;
        NextR.Slice         <= (others => '0');
        NextR.DataAvailable <= '1';
      end if;
      
    else
      oValid <= '1';
      if iAck = '1' then

        if R.Slice = cSlices - 1 then
          NextR.DataAvailable <= '0';
          --if iValid = '1' then
          --  oAck        <= '1';
          --  NextR.Data  <= iData;
          --  NextR.Slice <= (others => '0');
          --  NextR.DataAvailable <= '1';
          --end if;
        else
          NextR.Slice <= R.Slice + 1;
        end if;
        
      end if;

      
    end if;

    
  end process Comb;
 
  oData <= R.Data(oData'length*(to_integer(R.Slice)+1)-1 downto oData'length*to_integer(R.Slice));

  Reg : process (iClk, inResetAsync)
  begin  -- process Reg
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      R <= cRegInitVal;
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      R <= NextR;
    end if;
  end process Reg;

end architecture Rtl;
