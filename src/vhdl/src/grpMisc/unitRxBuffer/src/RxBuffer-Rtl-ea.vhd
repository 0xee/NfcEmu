-------------------------------------------------------------------------------
-- Title      : Rx buffer
-- Project    : 
-------------------------------------------------------------------------------
-- File       : RxBuffer-Rtl-ea.vhd<2>
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-09-18
-- Last update: 2013-09-20
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Ram with streaming port for writing and address interface for
-- reading
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-09-18  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library	global;
use global.Global.all;

entity RxBuffer is
  
  generic (
    gWidth : natural := 8;
    gSize  : natural := 256);
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iSyncReset   : in  std_ulogic;
    iDin         : in  std_ulogic_vector(gWidth-1 downto 0);
    iValid       : in  std_ulogic;
    oAck         : out std_ulogic;

    iEnable         :     std_ulogic;
    iRdAdr          : in  std_ulogic_vector(LogDualis(gSize)-1 downto 0);
    oDout           : out std_ulogic_vector(gWidth-1 downto 0);
    iRdStb          : in  std_ulogic;
    oRdAck          : out std_ulogic;
    oBytesAvailable : out std_ulogic_vector(7 downto 0)
    );
end entity RxBuffer;


architecture Rtl of RxBuffer is
  type aRamImage is array (0 to gSize-1) of std_ulogic_vector(gWidth-1 downto 0);

  signal sRam                    : aRamImage;
  signal rFull, rAck : std_ulogic;
  signal rWriteAdr               : natural range 0 to gSize-1;
  
begin  -- architecture Rtl

  Writer : process (iClk, inResetAsync) is
  begin  -- process Writer
    if inResetAsync = '0' then          -- asynchronous reset (active low)
      rWriteAdr  <= 0;
      rFull      <= '0';

    elsif rising_edge(iClk) then        -- rising clock edge

        if iValid = '1' and rFull = '0' then
          sRam(rWriteAdr) <= iDin;
          if rWriteAdr = gSize-1 then
            rFull <= '1';
          else
            rWriteAdr <= rWriteAdr + 1;
          end if;
        end if;

        if iSyncReset = '1' then
          rFull      <= '0';
          rWriteAdr  <= 0;
        end if;

        
      
    end if;
  end process Writer;

  oAck            <= iValid and not rFull;
  oRdAck          <= iRdStb and rAck;
  oBytesAvailable <= std_ulogic_vector(to_unsigned(rWriteAdr, oBytesAvailable'length));

  Reader : process (iClk, inResetAsync) is
  begin  -- process interface
    if rising_edge(iClk) then           -- rising clock edge
      rAck <= '0';
      if iRdStb = '1' and iEnable = '1' then
        oDout <= sRam(to_integer(unsigned(iRdAdr)));
        rAck  <= '1';
      end if;
    end if;
  end process Reader;

end architecture Rtl;
