-------------------------------------------------------------------------------
-- Title      : Package NFC
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Nfc-p.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-06-16
-- Last update: 2014-04-27
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-16  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library nfc;
use nfc.Nfc.all;

library global;
use global.Global.all;


package NfcEmuPkg is

  constant cNfcClkFreq : natural := 3*cNfcFc;
  constant cAdcClkFreq : natural := 8*cNfcFc;


  constant cStartByte    : std_ulogic_vector := x"AA";
  constant cEofByte      : std_ulogic_vector := x"E0";
  constant cEofShortByte : std_ulogic_vector := x"E1";

  -----------------------------------------------------------------------------
  -- Unit addressing
  -----------------------------------------------------------------------------
  constant cControlReg     : natural := 0;
  constant cCpu            : natural := 1;
  constant cCpuFw          : natural := 2;
  constant cEnvelopeStream : natural := 3;
  constant cTestStream     : natural := 4;
  constant cIso14443aPicc  : natural := 5;
  constant cIso14443aPcd   : natural := 6;
  constant cIsoLayer4Picc  : natural := 7;
  constant cIsoLayer4Pcd   : natural := 8;

  -- ID Structure
  --       3b          5b         
  --  +–––––––––+––––––––––––––––+
  --  |  Flags  |    Unit ID     |
  --  +–––––––––+––––––––––––––––+
  --
  --  Flags:
  --
  --      1b           2b          
  --   +–––––––+––––––––––––––––––+
  --   |Special|    Direction     |
  --   +–––––––+––––––––––––––––––+



  constant cIdCtrl  : std_ulogic_vector := IntToVec(cControlReg, 8);
  constant cIdCpu   : std_ulogic_vector := IntToVec(cCpu, 8);
  constant cIdCpuFw : std_ulogic_vector := IntToVec(cCpuFw, 8);

  constant cIdEnvelope      : std_ulogic_vector := IntToVec(cEnvelopeStream, 8);
  constant cIdTestStream    : std_ulogic_vector := IntToVec(cEnvelopeStream, 8);
  constant cIdIso14443aPicc : std_ulogic_vector := IntToVec(cIso14443aPicc, 8);
  constant cIdIso14443aPcd  : std_ulogic_vector := IntToVec(cIso14443aPcd, 8);
  constant cIdIsoLayer4Picc : std_ulogic_vector := IntToVec(cIsoLayer4Picc, 8);
  constant cIdIsoLayer4Pcd  : std_ulogic_vector := IntToVec(cIsoLayer4Pcd, 8);

  
  function MatchId (
    cIdIn    : std_ulogic_vector(cIdWidth-1 downto 0);
    cToMatch : std_ulogic_vector(cIdWidth-1 downto 0))
    return boolean;

  type aCounterArray is array (natural range <>) of std_ulogic_vector(7 downto 0);

  subtype aSDacVal is std_ulogic_vector(7 downto 0);


-------------------------------------------------------------------------------
-- Configuration
-------------------------------------------------------------------------------

  -- command bytes for writing/reading config register
  constant cCmdRead  : std_ulogic_vector := x"01";
  constant cCmdWrite : std_ulogic_vector := x"02";


  subtype aEnableReg is std_ulogic_vector(31 downto 0);
  constant cInitialEnables : aEnableReg := (cControlReg => '1', cCpuFw => '1', others => '0');


  subtype aFlagReg is std_ulogic_vector(31 downto 0);
  constant cInitialFlags : aFlagReg := (others => '0');

  constant cFlagRxOnly       : natural := 0;  -- enable 'sniffer' mode
  constant cFlagNfcField     : natural := 1;  -- RF field enable/status
  constant cFlagUidLenDouble : natural := 2;  -- select 7 byte uid
  constant cFlagCpuRunning : natural := 3;  -- read only, '1' when cpu is running

  type aNfcEmuCfg is record
    Enable      : aEnableReg;           -- 4
    Flags       : aFlagReg;             -- 4
    SDacA       : aSDacVal;             -- 1
    SDacB       : aSDacVal;             -- 1
    SDacC       : aSDacVal;             -- 1
    SDacD       : aSDacVal;             -- 1
    FieldTh     : aThreshold;           -- 1
    ScThreshold : aThreshold;           -- 1
    Uid         : aUid;                 -- 7
  end record;
  function CfgToVector (
    constant Cfg : aNfcEmuCfg)
    return std_ulogic_vector;

  function CfgFromVector (
    constant vec : std_ulogic_vector)
    return aNfcEmuCfg;

  constant cNfcCfgLen : natural := 21;
  
  constant cInitCfg : aNfcEmuCfg := (Enable      => cInitialEnables,
                                     Flags       => cInitialFlags,
                                     SDacA       => x"F0",
                                     SDacB       => x"30",
                                     SDacC       => (others => '0'),
                                     SDacD       => (others => '0'),
                                     FieldTh     => x"14",
                                     ScThreshold => x"20",
                                     Uid         => x"07060504030201");

  constant cReadBackMaskCfg : aNfcEmuCfg := (Enable      => (others => '1'),
                                             Flags       => (cFlagNfcField => '0',
                                                           cFlagCpuRunning => '0',
                                                             others => '1'),
                                             SDacA       => (others => '1'),
                                             SDacB       => (others => '1'),
                                             SDacC       => (others => '1'),
                                             SDacD       => (others => '1'),
                                             FieldTh     => (others => '1'),
                                             ScThreshold => (others => '1'),
                                             Uid         => (others => '1'));
-- TODO: return pcd uid on read
  
  constant cCfgReadBackMask : std_ulogic_vector;
  
  
end NfcEmuPkg;



package body NfcEmuPkg is

  function CfgToVector (
    constant Cfg : aNfcEmuCfg)
    return std_ulogic_vector is
    variable vec : std_ulogic_vector(cNfcCfgLen*8-1 downto 0) := (others => '0');
  begin
                                        --vec := Cfg.Mode & Cfg.SDacA & Cfg.SDacB & Cfg.SDacC &
                                        --       Cfg.SDacD & Cfg.MillerTh & Cfg.ScThreshold &
                                        --       vIsoFlags & Cfg.Uid;
    vec := Cfg.Uid &
           Cfg.ScThreshold &
           Cfg.FieldTh &
           Cfg.SDacD &
           Cfg.SDacC &
           Cfg.SDacB &
           Cfg.SDacA &
           Cfg.Flags &
           Cfg.Enable;
    
    return vec;
  end function;

  function CfgFromVector (
    constant vec : std_ulogic_vector)
    return aNfcEmuCfg is
    variable vCfg : aNfcEmuCfg;
    variable pos  : natural := 0;
  begin
    vCfg.Enable      := vec(pos+vCfg.Enable'left downto pos); pos := pos + vCfg.Enable'length;
    vCfg.Flags       := vec(pos+vCfg.Flags'left downto pos); pos := pos + vCfg.Flags'length;
    vCfg.SDacA       := vec(pos+7 downto pos); pos := pos + 8;
    vCfg.SDacB       := vec(pos+7 downto pos); pos := pos + 8;
    vCfg.SDacC       := vec(pos+7 downto pos); pos := pos + 8;
    vCfg.SDacD       := vec(pos+7 downto pos); pos := pos + 8;
    vCfg.FieldTh     := vec(pos+7 downto pos); pos := pos + 8;
    vCfg.ScThreshold := vec(pos+7 downto pos); pos := pos + 8;
    vCfg.Uid         := vec(pos+cUidLenDouble*8-1 downto pos); pos := pos + cUidLenDouble*8;
    return vCfg;
  end function;

  constant cCfgReadBackMask : std_ulogic_vector := CfgToVector(cReadBackMaskCfg);
  

  function MatchId (
    cIdIn    : std_ulogic_vector(cIdWidth-1 downto 0);
    cToMatch : std_ulogic_vector(cIdWidth-1 downto 0))
    return boolean is
  begin
    return cIdIn(4 downto 0) = cToMatch(4 downto 0);
  end;
  
end NfcEmuPkg;
