-------------------------------------------------------------------------------
-- Title      : Iso14443 Package
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Iso14443-p.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-08-10
-- Last update: 2014-05-06
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Common constants for ISO 14443 communication
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-08-10  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library global;
use global.Global.all;

package Iso14443 is

  -- states of a type A PICC
  -- (PowerOff is not currently not implemented - necessary?)
  type aPiccState is (PowerOff, Idle, Anticol, Ready, Layer4, Halt);
  type aPiccWakeupState is (WaitForREQA, SendATQA);
  type aPiccAnticolState is (WaitForSEL, WaitForNVB, SelectCheckUid, SendUid, SendBCC, SendSAK);
  subtype aPiccHaltState is natural range 0 to 3;

  constant cCyclesPerBit      : natural := 128;
  constant cFrameDelayMaxN    : natural := 18;
  constant cAnticolFrameDelay : natural := 9;
  constant cLayer4MinFrameDelay : natural := 9;

  constant cPiccRxLatency        : natural := 20;
  constant cAmDemodLatency       : natural := 5;  -- ? not measured
  constant cPiccTxLatency        : natural := 0;   -- ? not measured
  constant cTotalInternalLatency : natural := cPiccRxLatency +
                                              cAmDemodLatency +
                                              cPiccTxLatency;
  
  subtype aPcdCommand is std_ulogic_vector(7 downto 0);
  type aCommandSequence is array (natural range <>) of aPcdCommand;

  -- don't forget short frame enable for REQA,WUPA,etc.!
  constant cREQA    : aPcdCommand := x"26";
  constant cATQA1   : aPcdCommand := x"04";
  constant cATQA2   : aPcdCommand := x"00";
  constant cWUPA    : aPcdCommand := x"52";
  constant cSEL_CL1 : aPcdCommand := x"93";
  constant cSEL_CL2 : aPcdCommand := x"95";
  constant cSEL_CL3 : aPcdCommand := x"97";

  constant cHLTA1 : aPcdCommand := x"50";
  constant cHLTA2 : aPcdCommand := x"00";
  constant cHLTA3 : aPcdCommand := x"57";
  constant cHLTA4 : aPcdCommand := x"CD";

  constant cHLTA : aCommandSequence := (cHLTA1, cHLTA2, cHLTA3, cHLTA4);

  constant cRatsStartByte : aPcdCommand := x"E0";

  
  constant cSelectPayloadLen : natural := 7;
  
end Iso14443;
