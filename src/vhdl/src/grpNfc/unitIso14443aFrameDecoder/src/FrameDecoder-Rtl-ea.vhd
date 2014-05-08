-------------------------------------------------------------------------------
-- Title      : ISO 14443a PICC Rx framing decoder
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Iso14443aPiccRxFraming-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-08-13
-- Last update: 2014-04-16
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-08-13  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library nfc;
use nfc.Nfc.all;
library global;
use global.Global.all;

entity FrameDecoder is
  generic (
    gId : std_ulogic_vector := x"FF");    
  port (
    iClk          : in  std_ulogic;
    inResetAsync  : in  std_ulogic;
    iRxBit        : in  std_ulogic;
    iValid        : in  std_ulogic;
    iEof          : in  std_ulogic;
    oRxData       : out aDataPort;
    oRxShortFrame : out std_ulogic
    );

end entity FrameDecoder;


architecture Rtl of FrameDecoder is
  type aRegSet is record
    RxData         : std_ulogic_vector(8 downto 0);
    BitCount       : natural range 0 to 8;
    RxByte         : std_ulogic_vector(7 downto 0);
    ValidOut       : std_ulogic;
    EofOut         : std_ulogic;
    ByteAvailable  : std_ulogic;
    ShortFrame     : std_ulogic;
    FirstFrameByte : std_ulogic;
  end record aRegSet;

  constant cRegInitVal : aRegSet := (RxData         => (others => '0'),
                                     BitCount       => 0,
                                     RxByte         => (others => '0'),
                                     ValidOut       => '0',
                                     EofOut         => '0',
                                     ByteAvailable  => '0',
                                     ShortFrame     => '0',
                                     FirstFrameByte => '1');

  signal R, NextR : aRegSet;
  
begin  -- architecture Rtl
  oRxData.Id    <= gId;
  oRxData.Data  <= R.RxByte;
  oRxData.Eof   <= R.EofOut;
  oRxData.Valid <= R.ValidOut;
  oRxData.error <= '0';
  oRxShortFrame <= R.ShortFrame;

  Comb : process (R, iRxBit, iValid, iEof) is
  begin  -- process Comb
    NextR            <= R;
    NextR.ShortFrame <= '0';
    NextR.ValidOut   <= '0';
    NextR.EofOut     <= '0';

    if iValid = '1' then
      if R.BitCount = 8 then  -- current bit is parity or eof, throw away
        NextR.ByteAvailable <= '1';
        NextR.RxByte        <= R.RxData(R.RxByte'range);
        NextR.RxData        <= (others => '0');
        NextR.BitCount      <= 0;
      else
        NextR.RxData(R.BitCount) <= iRxBit;
        NextR.BitCount           <= R.BitCount + 1;
      end if;
    end if;


    if R.ByteAvailable = '1' and
      (iValid = '1' and R.BitCount = 1) then  -- next byte is coming in
      NextR.FirstFrameByte <= '0';
      NextR.ByteAvailable  <= '0';
      NextR.ValidOut       <= '1';
    end if;

    if iEof = '1' then
      NextR.RxData         <= (others => '0');
      NextR.FirstFrameByte <= '1';
      NextR.ByteAvailable  <= '0';
      NextR.EofOut         <= '1';
      NextR.ValidOut       <= '1';
      NextR.BitCount       <= 0;

      if R.BitCount > 1 then
        NextR.RxByte     <= R.RxData(R.RxByte'range);
        NextR.ShortFrame <= '1';
      elsif R.FirstFrameByte = '1' then
        NextR.ValidOut <= '0';
        NextR.EofOut   <= '0';
      end if;

    end if;

    
    
    
  end process Comb;




  Reg : process (iClk, inResetAsync) is
  begin  -- process Reg
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      R <= cRegInitVal;
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      R <= NextR;
    end if;
  end process Reg;


end architecture Rtl;
