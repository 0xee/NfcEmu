-------------------------------------------------------------------------------
-- Title      : Maximum Polyphase ASK Demodulator
-- Project    : 
-------------------------------------------------------------------------------
-- File       : MaxPPAskDemod-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-07-07
-- Last update: 2013-07-08
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Demodulates ASK by downsampling to the nyquist rate, then
-- taking the abs value of the signal.
-- It is assumed that the carrier frequency is equal to Fs_in / (2*gR) and that
-- the input signal is free of DC.
-- Because ASK doesn't need phase information, it is sufficient to select the
-- polyphase with the highest amplitude over the last gL samples instead of
-- synchronizing to the carrier's phase. An additional AA filter should be used
-- if the signal's spectrum continues above fc.
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-07-07  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library global;
use global.Global.all;

entity MaxPPAskDemod is
  
  generic (
    gL : natural := 8;
    gR : natural := 4);

  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iDin         : in  std_ulogic_vector;
    iValid       : in  std_ulogic;
    oAck         : out std_ulogic;
    oDout        : out std_ulogic_vector;
    oValid       : out std_ulogic;
    iAck         : in  std_ulogic);


end MaxPPAskDemod;

architecture Rtl of MaxPPAskDemod is

  subtype aAbsSample is unsigned(iDin'range);

  subtype aAccu is unsigned(aAbsSample'high + LogDualis(gL) downto 0);

  type aPPBuffer is array (0 to gR-1) of aAbsSample;
  type aPPArray is array (0 to gL-1) of aPPBuffer;

  type aAccuArray is array (0 to gR-1) of aAccu;

  type aRegSet is record
    SignalHistory : aPPArray;
    AmpAccu       : aAccuArray;
    MaxAmpA       : aAccu;
    MaxAmpB       : aAccu;
    MaxSigA       : aAbsSample;
    MaxSigB       : aAbsSample;
    DinCount      : unsigned(LogDualis(gR)-1 downto 0);
    Dout          : std_ulogic_vector(iDin'range);
    DoutValid     : std_ulogic;
  end record;

  constant cRegInitVal : aRegSet := (SignalHistory => (others => (others => (others => '0'))),
                                     AmpAccu       => (others => (others => '0')),
                                     DinCount      => (others => '0'),
                                     MaxAmpA       => (others => '0'),
                                     MaxAmpB       => (others => '0'),
                                     MaxSigA       => (others => '0'),
                                     MaxSigB       => (others => '0'),
                                     Dout          => (others => '0'),
                                     DoutValid     => '0');

  signal R, NextR : aRegSet;
  
begin  -- architecture Rtl

  Comb : process (R, iValid, iDin, iAck)
    variable vMaxPP  : natural range 0 to gR-1;
    variable vAbsDin : unsigned(iDin'range);
  begin  -- process Comb
    oAck            <= '0';
    NextR           <= R;
    NextR.DoutValid <= '0';

    if signed(iDin) < 0 then
      vAbsDin := unsigned(-signed(iDin));
    else
      vAbsDin := unsigned(iDin);
    end if;

    if iValid = '1' then
      oAck                                           <= '1';
      NextR.DinCount                                 <= R.DinCount + 1;
      NextR.SignalHistory(0)(to_integer(R.DinCount)) <= vAbsDin;

      NextR.AmpAccu(to_integer(R.DinCount)) <= R.AmpAccu(to_integer(R.DinCount)) +
                                               vAbsDin -
                                               R.SignalHistory(gL-1)(to_integer(R.DinCount));
      
      NextR.SignalHistory(0)(to_integer(R.DinCount)) <= vAbsDin;

      if R.DinCount = 0 then
        NextR.SignalHistory(1 to gL-1) <= R.SignalHistory(0 to gL-2);

        vMaxPP := 0;
        for pp in 1 to gR/2-1 loop
          if R.AmpAccu(pp) > R.AmpAccu(vMaxPP) then
            vMaxPP        := pp;
            NextR.MaxSigA <= R.SignalHistory(0)(pp);
          end if;
        end loop;  -- pp
        NextR.MaxAmpA <= R.AmpAccu(vMaxPP);

        vMaxPP := gR/2;
        for pp in gR/2+1 to gR-1 loop
          if R.AmpAccu(pp) > R.AmpAccu(vMaxPP) then
            vMaxPP        := pp;
            NextR.MaxSigB <= R.SignalHistory(0)(pp);
          end if;
        end loop;  -- pp
        NextR.MaxAmpB <= R.AmpAccu(vMaxPP);
        
      end if;

      if R.DinCount = 1 then

        if R.MaxAmpA > R.MaxAmpB then
          NextR.Dout <= std_ulogic_vector(R.MaxSigA);
        else
          NextR.Dout <= std_ulogic_vector(R.MaxSigB);
        end if;


        NextR.DoutValid <= '1';
      end if;
      
    end if;

    
  end process Comb;

  oValid <= R.DoutValid;
  oDout  <= R.Dout;

  Reg : process (iClk, inResetAsync)
  begin  -- process Reg
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      R <= cRegInitVal;
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      R <= NextR;
    end if;
  end process Reg;

end Rtl;
