-------------------------------------------------------------------------------
-- Title      : Envelope searching AM Demodulator
-- Project    : 
-------------------------------------------------------------------------------
-- File       : AmDemod-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-07-07
-- Last update: 2013-08-27
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- calculates the envelope of a signal by integrating over the magnitude of
-- each sample for one carrier period
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

entity AmDemod is
  
  generic (
    gPeriod : natural := 8);
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iDin         : in  std_ulogic_vector;
    iValid       : in  std_ulogic;
    oDout        : out std_ulogic_vector;
    oValid       : out std_ulogic);


end AmDemod;

architecture Rtl of AmDemod is

  constant cStages : natural := LogDualis(gPeriod);

  subtype aSample is signed(iDin'range);
  type    aSampleBuffer is array (0 to gPeriod-1) of aSample;
  type    aPipelinedSampleBuffer is array (0 to cStages) of aSampleBuffer;

  subtype aSampleCount is natural range 0 to gPeriod-1;

  type aRegSet is record
    Accu        : unsigned(iDin'left + LogDualis(gPeriod) downto 0);
    SampleCount : aSampleCount;
    Dout        : std_ulogic_vector(iDin'left + LogDualis(gPeriod) downto 0);
    DoutValid   : std_ulogic;
  end record;

  constant cRegInitVal : aRegSet := (Accu        => (others => '0'),
                                     SampleCount => 0,
                                     Dout        => (others => '0'),
                                     DoutValid   => '0');

  signal R, NextR : aRegSet;
 
begin  -- architecture Rtl
  
  Comb : process (R, iValid, iDin)
  begin  -- process Comb
    NextR           <= R;
    NextR.DoutValid <= '0';
    
    if iValid = '1' then
      if iDin(iDin'left) = '1' then
        NextR.Accu <= R.Accu + resize(unsigned(not iDin), R.Accu'length) + 1;
      else
        NextR.Accu <= R.Accu + resize(unsigned(iDin), R.Accu'length);
      end if;

      if R.SampleCount = gPeriod-1 then
        NextR.SampleCount <= 0;
        NextR.DoutValid   <= '1';
        NextR.Dout        <= std_ulogic_vector(R.Accu);
        if iDin(iDin'left) = '1' then
          NextR.Accu <= resize(unsigned(not iDin), R.Accu'length) + 1;
        else
          NextR.Accu <= resize(unsigned(iDin), R.Accu'length);
        end if;
      else
        NextR.SampleCount <= R.SampleCount + 1;
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
