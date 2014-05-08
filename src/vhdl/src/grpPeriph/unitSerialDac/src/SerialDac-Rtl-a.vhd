-------------------------------------------------------------------------------
-- Title      : Serial DAC RTL
-- Project    : 
-------------------------------------------------------------------------------
-- File       : SerialDac-Rtl-a.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-06
-- Last update: 2013-07-03
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Control for Saxo Q pre-amp DACs. Uses single output pin for dac
-- control:
--                                                    D
-- ______                   -------------------------|>|----------------o LOAD
--       |DACctrl           |                             |    |
--  FPGA |--------------------------------o DCLK       C ===   Z  R
-- ______|                  |                             |    Z
--                          --NNNN--|-----o DATA          |----|
--                             R    |                    _|_
--                                 === C                  V  GND
--                                  |   
--                                 _|_ 
--                                  V  GND
--                                  
--                                   
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-06  1.0      lukas   Created - todo: single channel update for faster response
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture Rtl of SerialDac is

  constant cChargeBits : natural := 5;
  constant cPauseBits  : natural := 128;

  constant cOptimumClkFreq : natural := 10e6;
  constant cClkDiv         : natural := gClkFreq / cOptimumClkFreq;

  type aState is (Init, Idle, Charge, Address, Rng, Data, Pause);

  type aRegSet is record
    State         : aState;
    LastBitStrobe : std_ulogic;
    BitCounter    : natural range 0 to cPauseBits-1;
    DacAdr        : unsigned(1 downto 0);
    DacCtrlOut    : std_ulogic;
  end record;

  constant cRegInitVal : aRegSet := (State         => Init,
                                     LastBitStrobe => '0',
                                     BitCounter    => 0,
                                     DacAdr        => "00",
                                     DacCtrlOut    => '0');

  signal R     : aRegSet := cRegInitVal;
  signal NextR : aRegSet;

  signal sDacIn   : std_ulogic_vector(7 downto 0);
  signal sDacData : std_ulogic;

  signal sBitStrobe, sResetStrobe : std_ulogic;
  signal sRegEnable               : std_ulogic;

  component StrobeGen
    generic (
      gClkFreq    : natural;
      gStrobeFreq : natural);
    port (
      iClk         : in  std_ulogic;
      inResetAsync : in  std_ulogic;
      iEnable      : in  std_ulogic;
      iSyncReset   : in  std_ulogic;
      oStrobe      : out std_ulogic);
  end component;
  
begin

  BitStrobeGen : StrobeGen
    generic map (
      gClkFreq    => cOptimumClkFreq,
      gStrobeFreq => gSClkFreq)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iEnable      => sRegEnable,
      iSyncReset   => sResetStrobe,
      oStrobe      => sBitStrobe);

  ClkDivStrobeGen : StrobeGen
    generic map (
      gClkFreq    => gClkFreq,
      gStrobeFreq => cOptimumClkFreq)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iEnable      => '1',
      iSyncReset   => '0',
      oStrobe      => sRegEnable);

  
  Comb : process (R, iValid, iDacA, iDacB, iDacC, iDacD, iUpdateCD, sDacData, sDacIn, sBitStrobe)
  begin  -- process Comb
    NextR        <= R;
    sDacData     <= '0';
    oAck         <= '0';
    sResetStrobe <= '0';

    case R.State is
      when Init =>
        NextR.State <= Idle;

      when Idle =>
        if iValid = '1' then
          NextR.State      <= Charge;
          sResetStrobe     <= '1';
          NextR.BitCounter <= 0;
        end if;

      when Charge =>
        sDacData <= '1';
        if sBitStrobe = '1' then
          if R.BitCounter = cChargeBits-1 then
            NextR.BitCounter <= 0;
            NextR.State      <= Address;
          else
            NextR.BitCounter <= R.BitCounter + 1;
          end if;
          
        end if;

      when Address =>
        sDacData <= R.DacAdr(1 - (R.BitCounter mod 2));
        if sBitStrobe = '1' then
          if R.BitCounter = 1 then
            NextR.State <= Rng;
          else
            NextR.BitCounter <= 1;
          end if;
        end if;

      when Rng =>
        sDacData <= '1';
        if sBitStrobe = '1' then
          NextR.BitCounter <= 0;
          NextR.State      <= Data;
        end if;

      when Data =>
        --sDacData <= '0';
        --if R.BitCounter /= 7 then
        sDacData <= sDacIn(7-R.BitCounter);  --R.DacData(7);
        --end if;

        if sBitStrobe = '1' then
          if R.BitCounter = 7 then      -- +1 for last sclk edge
            NextR.BitCounter <= 0;
            NextR.State      <= Pause;
          else
            NextR.BitCounter <= R.BitCounter + 1;
          end if;
        end if;

      when Pause =>

        sDacData <= '0';
        if sBitStrobe = '1' then
          if R.BitCounter = cPauseBits-1 then
            NextR.BitCounter <= 0;
            NextR.DacAdr     <= R.DacAdr + 1;
            if R.DacAdr = 3 or
              (iUpdateCD = '0' and R.DacAdr = 1) then
              oAck <= iValid;

              NextR.State <= Idle;
            else
              NextR.State <= Charge;
            end if;
          else
            NextR.BitCounter <= R.BitCounter + 1;
          end if;
        end if;

      when others =>
        NextR.State <= Idle;
    end case;

    NextR.LastBitStrobe <= sBitStrobe;
    -- generate rising edge on dacctrl on each strobe 
    if R.State = Charge or R.State = Data or R.State = Rng or R.State = Address then
      NextR.DacCtrlOut <= (sDacData or sBitStrobe) and not (R.LastBitStrobe);
    else
      NextR.DacCtrlOut <= '0';
    end if;
    
  end process Comb;

  oDacCtrl <= R.DacCtrlOut;

  sDacIn <= iDacA when R.DacAdr = "00" else
            iDacB when R.DacAdr = "01" else
            iDacC when R.DacAdr = "10" else
            iDacD;

  Reg : process (iClk, inResetAsync)
  begin  -- process Reg
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      R <= cRegInitVal;
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      if sRegEnable = '1' then
        R <= NextR;
      end if;
    end if;
  end process Reg;
  
  
end Rtl;
