-------------------------------------------------------------------------------
-- Title      : DcFifo
-- Project    : 
-------------------------------------------------------------------------------
-- File       : DcFifo-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-16
-- Last update: 2014-04-10
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Wrapper for altera dual clock fifo. Intended for clock domain
-- crossings
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-16  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library global;
use global.Global.all;

entity DcFifo is
  generic (
    gDepth : natural := 32);
  port (
    iWrClk       : in std_ulogic;
    iRdClk       : in std_ulogic;
    inResetAsync : in std_ulogic;
    iSyncReset   : in std_ulogic;

    iDin   : in  std_ulogic_vector;
    iValid : in  std_ulogic;
    oAckIn : out std_ulogic;

    oDout   : out std_ulogic_vector;
    oValid  : out std_ulogic;
    iAckOut : in  std_ulogic);

end DcFifo;

architecture Rtl of DcFifo is

  constant cAddrWidth : natural := LogDualis(gDepth);

  type aRam is array (integer range <>)of std_ulogic_vector (iDin'range);
  signal Mem : aRam (0 to gDepth-1);

  signal pNextWordToWrite   : std_ulogic_vector (cAddrWidth-1 downto 0);
  signal pNextWordToRead    : std_ulogic_vector (cAddrWidth-1 downto 0);
  signal EqualAddresses     : std_ulogic;
  signal NextWriteAddressEn : std_ulogic;
  signal NextReadAddressEn  : std_ulogic;
  signal Set_Status         : std_ulogic;
  signal Rst_Status         : std_ulogic;
  signal Status             : std_ulogic;
  signal PresetFull         : std_ulogic;
  signal PresetEmpty        : std_ulogic;
  signal empty, full        : std_ulogic;

  signal rOutRegValid : std_ulogic;

  component GrayCounter is
    generic (
      COUNTER_WIDTH : integer := cAddrWidth
      );
    port (
      GrayCount_out : out std_ulogic_vector (COUNTER_WIDTH-1 downto 0);
      Enable_in     : in  std_ulogic;    --Count enable.
      Clear_in      : in  std_ulogic;    --Count reset.
      clk           : in  std_ulogic
      );
  end component;
begin
  oValid <= rOutRegValid;
  oAckIn <= NextWriteAddressEn;
  --------------Code--------------/
  --Data ports logic:
  --(Uses a dual-port RAM).
  --'Data_out' logic:
  process (iRdClk, inResetAsync)
  begin
    if inResetAsync = '0' then
      rOutRegValid <= '0';
    elsif rising_edge(iRdClk) then
      if iAckOut or not rOutRegValid then
        if not empty then          
          rOutRegValid <= '1';
          oDout        <= Mem(VecToInt(pNextWordToRead));
        else
          rOutRegValid <= '0';
        end if;
      end if;
    end if;
  end process;

  --'Data_in' logic:
  process (iWrClk)
  begin
    if rising_edge(iWrClk) then
      if (iValid = '1' and full = '0') then
        Mem(VecToInt(pNextWordToWrite)) <= iDin;
      end if;
    end if;
  end process;

  --Fifo addresses support logic: 
  --'Next Addresses' enable logic:
  NextWriteAddressEn <= iValid and not full;
  NextReadAddressEn  <= (iAckOut or not rOutRegValid) and not empty;

                                        --Addreses (Gray counters) logic:
  GrayCounter_pWr : GrayCounter
    port map (
      GrayCount_out => pNextWordToWrite,
      Enable_in     => NextWriteAddressEn,
      Clear_in      => iSyncReset,
      clk           => iWrClk
      );

  GrayCounter_pRd : GrayCounter
    port map (
      GrayCount_out => pNextWordToRead,
      Enable_in     => NextReadAddressEn,
      Clear_in      => iSyncReset,
      clk           => iRdClk
      );

                                        --'EqualAddresses' logic:
  EqualAddresses <= '1' when (pNextWordToWrite = pNextWordToRead) else '0';

                                        --'Quadrant selectors' logic:
  process (pNextWordToWrite, pNextWordToRead)
    variable set_status_bit0 : std_ulogic;
    variable set_status_bit1 : std_ulogic;
    variable rst_status_bit0 : std_ulogic;
    variable rst_status_bit1 : std_ulogic;
  begin
    set_status_bit0 := pNextWordToWrite(cAddrWidth-2) xnor pNextWordToRead(cAddrWidth-1);
    set_status_bit1 := pNextWordToWrite(cAddrWidth-1) xor pNextWordToRead(cAddrWidth-2);
    Set_Status      <= set_status_bit0 and set_status_bit1;

    rst_status_bit0 := pNextWordToWrite(cAddrWidth-2) xor pNextWordToRead(cAddrWidth-1);
    rst_status_bit1 := pNextWordToWrite(cAddrWidth-1) xnor pNextWordToRead(cAddrWidth-2);
    Rst_Status      <= rst_status_bit0 and rst_status_bit1;
  end process;

  --'Status' latch logic:
  process (Set_Status, Rst_Status, iSyncReset)
  begin  --D Latch w/ Asynchronous Clear & Preset.
    if (Rst_Status = '1' or iSyncReset = '1') then
      Status <= '0';                    --Going 'Empty'.
    elsif (Set_Status = '1') then
      Status <= '1';                    --Going 'Full'.
    end if;
  end process;

                                            --'Full_out' logic for the writing port:
  PresetFull <= Status and EqualAddresses;  --'Full' Fifo.

  process (iWrClk, PresetFull)
  begin  --D Flip-Flop w/ Asynchronous Preset.
    if (PresetFull = '1') then
      full <= '1';
    elsif (rising_edge(iWrClk)) then
      full <= '0';
    end if;
  end process;

                                                 --'Empty_out' logic for the reading port:
  PresetEmpty <= not Status and EqualAddresses;  --'Empty' Fifo.

  process (iRdClk, PresetEmpty)
  begin  --D Flip-Flop w/ Asynchronous Preset.
    if (PresetEmpty = '1') then
      empty <= '1';
    elsif (rising_edge(iRdClk)) then
      empty <= '0';
    end if;
  end process;

  
end Rtl;
