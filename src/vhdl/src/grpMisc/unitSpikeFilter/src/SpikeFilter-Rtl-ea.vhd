-------------------------------------------------------------------------------
-- Title      : SpikeFilter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : SpikeFilter-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-04-10
-- Last update: 2013-09-05
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-04-10  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SpikeFilter is
  
  generic (
    gSampleRate    : natural := 50e6;
    gMinPulseWidth : time    := 1 us);
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iValid       : in  std_ulogic;
    iDin         : in  std_ulogic;
    oDout        : out std_ulogic;
    oValid       : out std_ulogic);

end SpikeFilter;


architecture Rtl of SpikeFilter is

  constant cSamplePeriod : time    := 1 sec / gSampleRate;
  constant cMinSamples   : natural := gMinPulseWidth / cSamplePeriod;

  signal rState, rValid : std_ulogic;
  signal rOtherStateLen : natural range 0 to cMinSamples-1;
  
begin  -- Rtl

  assert cMinSamples /= 0
    report "Min Pulse width is smaller than sample period"
    severity failure;

  Reg : process (iClk, inResetAsync)

  begin  -- process Reg
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      RState         <= '0';
      rOtherStateLen <= 0;
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      if iValid = '1' then
        if iDin /= rState then
          if rOtherStateLen = cMinSamples-1 then
            rOtherStateLen <= 0;
            rState         <= not rState;
          else
            rOtherStateLen <= rOtherStateLen + 1;
          end if;
        else
          rOtherStateLen <= 0;
        end if;
      else
      end if;
      rValid <= iValid;
      
    end if;
  end process Reg;

  oValid <= rValid;
  oDout  <= rState;
  
end Rtl;
