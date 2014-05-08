------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : DataGen-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-02
-- Last update: 2013-06-10
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: <cursor>
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-02  1.0      lukas   Created
-------------------------------------------------------------------------------


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity DataGen is
  generic (
    gWidth : natural := 32);
  port (
    inResetAsync : in std_ulogic;
    iClk         : in std_ulogic;

    oData        : out std_ulogic_vector(31 downto 0);
    oValid       : out std_ulogic;
    iAck         : in  std_ulogic;
    oEndOfPacket : out std_ulogic;

    iData  : in  std_ulogic_vector(7 downto 0);
    iValid : in  std_ulogic;
    oAck   : out std_ulogic
    );


end DataGen;


architecture Rtl of DataGen is

  type aState is (Idle, Start, Run);

  type aRegSet is record
    State   : aState;
    Counter : unsigned(gWidth-1 downto 0);
  end record;

  constant cRegInitval : aRegSet := (State   => Idle,
                                     Counter => (others => '0'));
  signal R     : aRegSet := cRegInitval;
  signal NextR : aRegSet;

  
begin  -- Rtl


  
  Comb : process (R, iData, iValid, iAck)
  begin  -- process Comb
    oValid       <= '0';
    oEndOfPacket <= '0';
    oAck         <= '0';
    NextR        <= R;

    case R.State is
      when Idle =>
        if iValid = '1' then
          oAck          <= '1';
          NextR.State   <= Start;
          NextR.Counter <= (others => '0');
        end if;

      when Start =>
        NextR.State <= Run;

      when Run =>
        oValid <= '1';
        if iAck = '1' then
          NextR.Counter <= R.Counter + 1;
        end if;

      when others => null;
    end case;


  end process Comb;

  oData <= std_ulogic_vector(R.Counter);

  Sync : process (iClk, inResetAsync)
  begin  -- process Sync
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      R <= cRegInitval;
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      R <= NextR;
    end if;
  end process Sync;


end Rtl;

