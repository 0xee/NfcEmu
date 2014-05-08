-------------------------------------------------------------------------------
-- Title      : DualClockedFifo
-- Project    : 
-------------------------------------------------------------------------------
-- File       : DualClockedFifo-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-16
-- Last update: 2013-06-19
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

entity DualClockedFifo is
  generic (
    gWidth : natural := 8);
  port (
    iWrClk       : in std_ulogic;
    iRdClk       : in std_ulogic;
    inResetAsync : in std_ulogic;

    iValid : in  std_ulogic;
    iDin   : in  std_ulogic_vector(gWidth-1 downto 0);
    oAck   : out std_ulogic;

    oValid : out std_ulogic;
    oDout  : out std_ulogic_vector(gWidth-1 downto 0);
    iAck   : in  std_ulogic);

end DualClockedFifo;

architecture Rtl of DualClockedFifo is

  component alt_fifo_10x128
    port (
      aclr    : in  std_logic := '0';
      data    : in  std_logic_vector (9 downto 0);
      rdclk   : in  std_logic;
      rdreq   : in  std_logic;
      wrclk   : in  std_logic;
      wrreq   : in  std_logic;
      q       : out std_logic_vector (9 downto 0);
      rdempty : out std_logic;
      wrfull  : out std_logic);
  end component;

  component alt_fifo_8x32
    port (
      aclr    : in  std_logic := '0';
      data    : in  std_logic_vector (7 downto 0);
      rdclk   : in  std_logic;
      rdreq   : in  std_logic;
      wrclk   : in  std_logic;
      wrreq   : in  std_logic;
      q       : out std_logic_vector (7 downto 0);
      rdempty : out std_logic;
      wrfull  : out std_logic);
  end component;

  signal sFull, sEmpty : std_logic;
  signal sRdReq, sWrReq : std_ulogic;

  signal sDout : std_logic_vector(iDin'range);
  signal snReset : std_ulogic;          
begin  -- Rtl

  snReset <= not inResetAsync;
  
  sWrReq <= iValid and (not sFull);
  oAck <= sWrReq;

  oValid <= not sEmpty;
  sRdReq <= iAck and not sEmpty;

  
  SelectFifoWidth8 : if iDin'length = 8 generate
    alt_fifo_8x32_1 : alt_fifo_8x32
      port map (
        aclr    => snReset,
        data    => std_logic_vector(iDin),
        rdclk   => iRdClk,
        rdreq   => sRdReq,
        wrclk   => iWrClk,
        wrreq   => sWrReq,
        q       => sDout(7 downto 0),
        rdempty => sEmpty,
        wrfull  => sFull);

  end generate SelectFifoWidth8;

  SelectFifoWidth10 : if iDin'length /= 8 generate
    
    alt_fifo_10x128_1 : alt_fifo_10x128
      port map (
        aclr    => snReset,
        data    => std_logic_vector(iDin),
        rdclk   => iRdClk,
        rdreq   => sRdReq,
        wrclk   => iWrClk,
        wrreq   => sWrReq,
        q       => sDout,
        rdempty => sEmpty,
        wrfull  => sFull);
  end generate SelectFifoWidth10;
  
oDout <= std_ulogic_vector(sDout(oDout'range));
  
end Rtl;
