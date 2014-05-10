-------------------------------------------------------------------------------
-- Title      : T51 Interface
-- Project    : 
-------------------------------------------------------------------------------
-- File       : T51Interface-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-09-19
-- Last update: 2014-05-09
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Wishbone peripheral for T51 to communicate with nfc ports
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-09-19  1.0      lukas   Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library global;
use global.Global.all;

library nfcemu;
use nfcemu.NfcEmuPkg.all;

library misc;

entity T51Interface is
  
  generic (
    gNrPorts     : natural := 2;
    gBufferSize  : natural := 512;
    gBaseAdr     : natural := 16#1000#;
    gWbAdrWidth  : natural := 16;
    gWbDataWidth : natural := 8
    );
  port (
    iClk          : in  std_ulogic;
    inResetAsync  : in  std_ulogic;
    iInputPorts   : in  aDataPortArray(gNrPorts-1 downto 0);
    oInputAck     : out std_ulogic_vector(gNrPorts-1 downto 0);
    oOutputPorts  : out aDataPortArray(gNrPorts-1 downto 0);
    oTxShortFrame : out std_ulogic_vector(gNrPorts-1 downto 0);
    iOutputAck    : in  std_ulogic_vector(gNrPorts-1 downto 0);

    -- wb signals
    iWbAdr   : in  std_ulogic_vector(gWbAdrWidth-1 downto 0);
    iWbData  : in  std_ulogic_vector(gWbDataWidth-1 downto 0);
    oWbData  : out std_ulogic_vector(gWbDataWidth-1 downto 0);
    iWbWrStb : in  std_ulogic;
    iWbRdStb : in  std_ulogic;
    oWbAck   : out std_ulogic

    );

end entity T51Interface;

architecture Rtl of T51Interface is

  -- address offsets for each port
  constant cRxOffset      : natural := 0;
  constant cTxOffset      : natural := gBufferSize;
  constant cControlOffset : natural := gBufferSize+1;
  constant cRxCountOffset : natural := gBufferSize+2;
  constant cIdOffset      : natural := gBufferSize+3;

  constant cPortOffset : natural := 2*gBufferSize;

  -- control register bits
  constant cEofIdx        : natural := 0;
  constant cRxResetIdx    : natural := 1;
  constant cShortFrameIdx : natural := 2;

  function IsAddr (
    constant cAddr  : in std_ulogic_vector;
    constant cBase  : in natural;
    constant cRange : in natural) return std_ulogic is
    constant cMask : std_ulogic_vector := not std_ulogic_vector(to_unsigned(cRange-1, cAddr'length));
  begin
    if (cAddr and cMask) = std_ulogic_vector(to_unsigned(cBase, cAddr'length)) then
      return '1';
    else
      return '0';
    end if;
  end;


  type aFlagSet is record
    Rx      : std_ulogic;
    Tx      : std_ulogic;
    Control : std_ulogic;
    RxCount : std_ulogic;
    Id      : std_ulogic;
  end record;

  type aFlagSetArray is array (natural range gNrPorts-1 downto 0) of aFlagSet;
  signal sEnables, sAcks : aFlagSetArray;

  constant cEmptyFlagSet : aFlagSet := (Rx => '0',
                                        Tx => '0',
                                        Control => '0',
                                        RxCount => '0',
                                        Id => '0');
  
  constant cEmptyEnables : aFlagSetArray := (others => cEmptyFlagSet);

  signal sRxReset                                              : std_ulogic_vector(gNrPorts-1 downto 0);
  signal rRxEof, rTxEof, rTxShortFrame, sRxBufAck, sRxBufValid : std_ulogic_vector(gNrPorts-1 downto 0);

  signal sRxCount, sRxDout, sPortDout, sControlWord, rTxIds : aCounterArray(gNrPorts-1 downto 0);

  
begin  -- architecture Rtl
    assert  (iWbWrStb or iWbRdStb ) /= '1' or (sEnables /= cEmptyEnables)
      report "Invalid XRAM Access"
      severity failure;

  Flags : for i in 0 to gNrPorts-1 generate
    sEnables(i).Rx <= IsAddr(std_ulogic_vector(iWbAdr), gBaseAdr+i*cPortOffset+cRxOffset,
                             gBufferSize);
    sEnables(i).Tx      <= IsAddr(std_ulogic_vector(iWbAdr), gBaseAdr+i*cPortOffset+cTxOffset, 1);
    sEnables(i).Control <= IsAddr(std_ulogic_vector(iWbAdr), gBaseAdr+i*cPortOffset+cControlOffset, 1);
    sEnables(i).RxCount <= IsAddr(std_ulogic_vector(iWbAdr), gBaseAdr+i*cPortOffset+cRxCountOffset, 1);
    sEnables(i).Id      <= IsAddr(std_ulogic_vector(iWbAdr), gBaseAdr+i*cPortOffset+cIdOffset, 1);

    sRxReset(i) <= sEnables(i).Control and iWbData(cRxResetIdx) and iWbWrStb;


    
    oOutputPorts(i).Data  <= iWbData;
    oOutputPorts(i).Valid <= iWbWrStb and sEnables(i).Tx;
    oOutputPorts(i).Eof   <= rTxEof(i) and iWbWrStb and sEnables(i).Tx;
    oOutputPorts(i).Id    <= rTxIds(i);
    oOutputPorts(i).error <= '0';
    oTxShortFrame(i)      <= rTxShortFrame(i) and iWbWrStb and sEnables(i).Tx;

    sRxBufValid(i) <= iInputPorts(i).Valid and not rRxEof(i);

    sAcks(i).Tx      <= iOutputAck(i) and sEnables(i).Tx and iWbWrStb;
    sAcks(i).Control <= sEnables(i).Control and (iWbRdStb or iWbWrStb);
    sAcks(i).RxCount <= sEnables(i).RxCount and (iWbRdStb or iWbWrStb);
    sAcks(i).Id      <= sEnables(i).Id and (iWbRdStb or iWbWrStb);
  end generate Flags;

  oInputAck <= sRxBufAck;

  DataMux : for i in 0 to gNrPorts-1 generate
    ControlWord : process (rRxEof) is
    begin  -- process ControlWord
      sControlWord(i)          <= (others => '0');
      sControlWord(i)(cEofIdx) <= rRxEof(i);
    end process ControlWord;

    sPortDout(i) <= sRxDout(i) when sEnables(i).Rx = '1' else
                    sControlWord(i) when sEnables(i).Control = '1' else
                    sRxCount(i)     when sEnables(i).RxCount = '1' else
                    (others => '-');
  end generate DataMux;

  CollectFlagsAndData : process (sAcks, sPortDout, sEnables) is
    variable vAck         : std_ulogic;
    variable vEnabledPort : natural range 0 to gNrPorts-1;
  begin  -- process CollectFlags
    oWbData      <= (others => '0');
    vAck         := '0';
    vEnabledPort := 0;
    for i in 0 to gNrPorts-1 loop
      vAck := vAck or sAcks(i).Rx or sAcks(i).Tx or
              sAcks(i).Control or sAcks(i).RxCount or sAcks(i).Id;

      if (sEnables(i).Rx or sEnables(i).Control or sEnables(i).RxCount) = '1' then
        vEnabledPort := i;
      end if;
    end loop;  -- i
    oWbData <= sPortDout(vEnabledPort);
    oWbAck  <= vAck;
  end process CollectFlagsAndData;

  CtrlFlagsAndIds : process (iClk, inResetAsync) is
  begin  -- process EofFlags
    if inResetAsync = '0' then          -- asynchronous reset (active low)
      rRxEof        <= (others => '0');
      rTxEof        <= (others => '0');
      rTxShortFrame <= (others => '0');
      rTxIds        <= (others => (others => '0'));
    elsif rising_edge(iClk) then        -- rising clock edge
      for i in 0 to gNrPorts-1 loop
        if sEnables(i).Control = '1' and iWbWrStb = '1' then
          rTxEof(i)        <= iWbData(cEofIdx);
          rTxShortFrame(i) <= iWbData(cShortFrameIdx);
        end if;

        if iOutputAck(i) = '1' then
          rTxEof(i)        <= '0';
          rTxShortFrame(i) <= '0';
        end if;

        if iInputPorts(i).Eof and sRxBufAck(i) then
          rRxEof(i) <= '1';
        elsif sRxReset(i) = '1' then
          rRxEof(i) <= '0';
        end if;

        if sEnables(i).Id = '1' and iWbWrStb = '1' then
          rTxIds(i) <= iWbData;
        end if;
      end loop;  -- i
    end if;
  end process CtrlFlagsAndIds;

  RxBuffers : for i in 0 to gNrPorts-1 generate
    RxBuffer : entity misc.RxBuffer
      generic map (
        gWidth => gWbDataWidth,
        gSize  => gBufferSize)
      port map (
        iClk            => iClk,
        inResetAsync    => inResetAsync,
        iSyncReset      => sRxReset(i),
        iDin            => iInputPorts(i).Data,
        iValid          => sRxBufValid(i),
        oAck            => sRxBufAck(i),
        iEnable         => sEnables(i).Rx,
        iRdAdr          => iWbAdr(LogDualis(gBufferSize)-1 downto 0),
        oDout           => sRxDout(i),
        iRdStb          => iWbRdStb,
        oRdAck          => sAcks(i).Rx,
        oBytesAvailable => sRxCount(i));
  end generate RxBuffers;
  
end architecture Rtl;
