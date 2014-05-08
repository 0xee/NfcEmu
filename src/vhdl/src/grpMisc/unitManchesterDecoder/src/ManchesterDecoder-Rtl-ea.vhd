-------------------------------------------------------------------------------
-- Title      : ManchesterDecoder
-- Project    : 
-------------------------------------------------------------------------------
-- File       : ManchesterDecoder-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-07-16
-- Last update: 2013-09-05
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Decodes a manchester encoded signal to a bitstream
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-07-16  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library	global;
use global.Global.all;


entity ManchesterDecoder is
  
  generic (
    gStartBit      : std_ulogic := '0';
    gSamplesPerBit : natural    := 16);

  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iDin         : in  std_ulogic;
    iValid       : in  std_ulogic;
    oDout        : out std_ulogic;
    oValid       : out std_ulogic;
    oEof         : out std_ulogic);

end ManchesterDecoder;


architecture Rtl of ManchesterDecoder is

  type    aState is (Idle, Sof, Data);
  subtype aDelayPath is std_ulogic_vector(gSamplesPerBit-1 downto 0);

  type aRegSet is record
    State        : aState;
    Z            : aDelayPath;
    NextBitStart : natural range 0 to gSamplesPerBit-1;
    Dout         : std_ulogic;
    ValidOut     : std_ulogic;
    Eof          : std_ulogic;
  end record;

  constant cInitRegVal : aRegSet := (State        => Idle,
                                     Z            => (others => '0'),
                                     NextBitStart => 0,
                                     Dout         => '0',
                                     ValidOut     => '0',
                                     Eof          => '0'
                                     );

  signal R, NextR                           : aRegSet;
  signal sH1Count, sH2Count                 : natural range 0 to gSamplesPerBit/2;
  signal sRisingEdge, sValidOne, sValidZero : std_ulogic;
  component EdgeDetector
    port (
      iClk         : in  std_ulogic;
      inResetAsync : in  std_ulogic;
      iDin         : in  std_ulogic;
      iValid       : in  std_ulogic;
      oRising      : out std_ulogic;
      oFalling     : out std_ulogic);
  end component;

begin  -- Rtl

  EdgeDetector_1 : EdgeDetector
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => iDin,
      iValid       => iValid,
      oRising      => sRisingEdge,
      oFalling     => open);

  oValid   <= R.ValidOut;
  oDout    <= R.Dout;
  oEof     <= R.Eof;
  sH1Count <= PopCount(R.Z(gSamplesPerBit/2-1 downto 0));
  sH2Count <= PopCount(R.Z(R.Z'left downto gSamplesPerBit/2));

  sValidOne <= '1' when sH1Count >= gSamplesPerBit/3 and sH2Count <= gSamplesPerBit/6 else
               '0';
  
  sValidZero <= '1' when sH1Count <= gSamplesPerBit/6 and sH2Count >= gSamplesPerBit/3 else
                '0';

  Comb : process (iDin, iValid, sValidZero, sValidOne, sRisingEdge, R)
  begin  -- process Comb
    NextR          <= R;
    NextR.ValidOut <= '0';
    NextR.Eof      <= '0';

    if iValid = '1' then
      NextR.Z <= iDin & R.Z(R.Z'left downto 1);
    end if;

    case R.State is
      when Idle =>
        if sRisingEdge = '1' then
          NextR.State        <= Sof;
          NextR.NextBitStart <= gSamplesPerBit-1;
        end if;
        
      when Sof =>
        if iValid = '1' then
          if R.NextBitStart = 0 then
            -- check if current bit is valid manchester code
            if (sValidOne = '1' and gStartBit = '1') or
              (sValidZero = '1' and gStartBit = '0') then
              NextR.NextBitStart <= gSamplesPerBit-1;
              NextR.State        <= Data;
            else
              NextR.State <= Idle;
            end if;
          else
            NextR.NextBitStart <= R.NextBitStart - 1;
          end if;
        end if;
      when Data =>
        if iValid = '1' then
          if R.NextBitStart = 0 then
            -- check if current bit is valid manchester code
            if sValidZero = '1' then
              NextR.Dout         <= '0';
              NextR.ValidOut     <= '1';
              NextR.NextBitStart <= gSamplesPerBit-1;
            elsif sValidOne = '1' then
              NextR.Dout         <= '1';
              NextR.ValidOut     <= '1';
              NextR.NextBitStart <= gSamplesPerBit-1;
            else
              NextR.State <= Idle;
              NextR.ValidOut <= '1';
              NextR.Eof   <= '1';
            end if;
            
          else
            NextR.NextBitStart <= R.NextBitStart - 1;
          end if;
        end if;
      when others => null;
    end case;

  end process Comb;




  Reg : process (iClk, inResetAsync)
  begin  -- process Reg
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      R <= cInitRegVal;
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      R <= NextR;
    end if;
  end process Reg;

end Rtl;
