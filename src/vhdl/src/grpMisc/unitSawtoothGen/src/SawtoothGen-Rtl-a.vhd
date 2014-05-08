-------------------------------------------------------------------------------
-- Title      : SawtoothGen
-- Project    : 
-------------------------------------------------------------------------------
-- File       : SawtoothGen-Rtl-a.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-07
-- Last update: 2013-06-11
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-07  1.0      lukas	Created
-------------------------------------------------------------------------------

library	global;
use global.Global.all;


architecture Rtl of SawtoothGen is

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
  
  constant cClkDiv : natural := gClkFreq/gUpdateFreq;
  
  constant cCounterMax : natural := gMaxVal-gMinVal;
  
  signal sUpdateStrobe : std_ulogic;

  signal sCounter : unsigned(LogDualis(cCounterMax) downto 0) ;

begin  -- Rtl

  StrobeGen_1: StrobeGen
    generic map (
      gClkFreq    => gClkFreq,
      gStrobeFreq => gUpdateFreq)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iEnable      => iEnable,
      iSyncReset   => iSyncReset,
      oStrobe      => sUpdateStrobe);

  Reg: process (iClk, inResetAsync)
  begin  -- process Reg
    if inResetAsync = '0' then          -- asynchronous reset (active low)
      sCounter <= (others => '0');
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      oUpdate <= '0';
      if iSyncReset = '1' then
        sCounter <= (others => '0');
      else
        
        if iEnable = '1' then
          
          if sUpdateStrobe = '1' then
            oUpdate <= '1';
            if sCounter = cCounterMax then
              sCounter <= (others => '0');
            else
              sCounter <= sCounter + 1;              
            end if;
            
          end if;
          
        end if;
        
      end if;

      
    end if;
  end process Reg;

  oDout <= std_ulogic_vector(resize(to_unsigned(gMinVal, oDout'length) + sCounter, oDout'length));

end Rtl;
