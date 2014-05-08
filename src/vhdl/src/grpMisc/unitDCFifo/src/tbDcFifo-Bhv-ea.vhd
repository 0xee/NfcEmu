-------------------------------------------------------------------------------
-- Title      : Testbench for design "DualClockedFifo"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tbDcFifo.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-17
-- Last update: 2014-04-10
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-17  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library osvvm;
use osvvm.RandomPkg.all;

library global;
use global.Global.all;

library global;
use global.SimUtil.all;


-------------------------------------------------------------------------------

entity tbDcFifo is

end tbDcFifo;

-------------------------------------------------------------------------------

architecture Bhv of tbDcFifo is

  constant cRdClkPeriod : time    := 1 sec / 30e6;
  constant cWrClkPeriod : time    := 1 sec / 201e6;
  constant cToSend      : natural := 1000;

  signal iWrClk       : std_ulogic := '1';
  signal iRdClk       : std_ulogic := '1';
  signal inResetAsync : std_ulogic := '0';
  signal iSyncReset   : std_ulogic;
  signal iDin         : std_ulogic_vector(7 downto 0);
  signal iValid       : std_ulogic;
  signal oAckIn       : std_ulogic;
  signal oDout        : std_ulogic_vector(7 downto 0);
  signal oValid       : std_ulogic;
  signal iAckOut      : std_ulogic;

  signal sEndOfSim : std_ulogic := '0';

begin  -- Bhv

  inResetAsync <= '0' after 0 ns,
                  '1' after 2*cRdClkPeriod;

  iSyncReset <= not inResetAsync;

  iRdClk <= (not iRdClk) and (not sEndOfSim) after cRdClkPeriod/2;
  iWrClk <= (not iWrClk) and (not sEndOfSim) after cWrClkPeriod/2;


  DcFifo_1 : entity work.DcFifo
    generic map (
      gDepth => 16)
    port map (
      iWrClk       => iWrClk,
      iRdClk       => iRdClk,
      inResetAsync => inResetAsync,
      iSyncReset   => iSyncReset,
      iDin         => iDin,
      iValid       => iValid,
      oAckIn       => oAckIn,
      oDout        => oDout,
      oValid       => oValid,
      iAckOut      => iAckOut);

  stimuli : process
    variable vRnd : RandomPType;
  begin  -- process stimuli
    vRnd.InitSeed(vRnd'instance_name);

    iDin   <= (others => '0');
    iValid <= '0';

    wait until inResetAsync <= '1';
    wait until rising_edge(iWrClk);

    for i in 0 to cToSend-1 loop

      iDin   <= vRnd.RandSlv(iDin'length);
      iValid <= '1';

      wait until rising_edge(iWrClk) and oAckIn = '1';
      iValid <= '0';
      WaitRandom(iWrClk, vRnd, 2);
      
    end loop;

    sEndOfSim <= '1';
    wait;
  end process stimuli;


  iAckOut <= oValid;
  
end Bhv;
