-------------------------------------------------------------------------------
-- Title      : GenFifo
-- Project    : 
-------------------------------------------------------------------------------
-- File       : GenFifo-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-12-20
-- Last update: 2014-05-15
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Generic FIFO
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-12-20  1.0      lukas   Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library global;
use global.Global.all;


entity GenFifo is
  
  generic (
    gDepth : natural;
    gWidth : natural
    );
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iDin         : in  std_ulogic_vector(gWidth-1 downto 0);
    iValid       : in  std_ulogic;
    oAck         : out std_ulogic;
    oDout        : out std_ulogic_vector(gWidth-1 downto 0);
    oValid       : out std_ulogic;
    iAck         : in  std_ulogic);

end entity GenFifo;

architecture Rtl of GenFifo is

  subtype aWord is std_ulogic_vector(iDin'range);
  type aMemory is array (0 to gDepth-1) of aWord;

  -- augmented counter uses N+1 bits for 2^N slots
  subtype aPointer is unsigned(LogDualis(gDepth) downto 0);

  signal RdPtr  : aPointer := (others => '0');  -- to avoid metavalue warning
  signal WrPtr  : aPointer := (others => '0');  -- to avoid metavalue warning
  signal Memory : aMemory;

  signal sEmpty, sFull : std_ulogic;
    
  function CheckFull(rd : aPointer; wr : aPointer) return boolean is
    variable vTmp : aPointer := wr;
    begin
      vTmp(vTmp'left) := not vTmp(vTmp'left);
      return vTmp = rd;
    end;
    
begin  -- architecture Rtl

  sEmpty <= '1' when WrPtr = RdPtr else
            '0';
  
  sFull <=  '1' when CheckFull(WrPtr, RdPtr) else
            '0';

  oAck   <= iValid and not sFull;
  oValid <= not sEmpty;
  oDout  <= Memory(to_integer(RdPtr(RdPtr'left-1 downto 0)));

  ReadWrite : process (iClk, inResetAsync) is
  begin  -- process ReadWrite
    if inResetAsync = '0' then          -- asynchronous reset (active low)
      RdPtr <= (others => '0');
      WrPtr <= (others => '0');
    elsif rising_edge(iClk) then        -- rising clock edge
      
      if iValid = '1' and sFull = '0' then
        Memory(to_integer(WrPtr(WrPtr'left-1 downto 0))) <= iDin;
        WrPtr                     <= WrPtr + 1;
      end if;

      if sEmpty = '0' and iAck = '1' then
        RdPtr <= RdPtr + 1;
      end if;
      
    end if;
  end process ReadWrite;
  

end architecture Rtl;
