-------------------------------------------------------------------------------
-- Title      : ISO 14443A PICC Logic
-- Project    : NfcEmu
-------------------------------------------------------------------------------
-- File       : Iso14443aPiccLogic-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-08-10
-- Last update: 2014-05-06
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
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

library nfc;
use nfc.Nfc.all;
use nfc.Iso14443.all;
--use nfc.DebugCodes.all;


entity Iso14443aPiccLogic is
  
  generic (
    gClkFreq           : natural;
    gLayer4Id, gPiccId : std_ulogic_vector);

  port (
    iClk         : in std_ulogic;
    inResetAsync : in std_ulogic;
    iEnable      : in std_ulogic;

    iFieldActive : in std_ulogic;

    iRxData       : in  aDataPort;
    iRxShortFrame : in  std_ulogic;
    oHostData     : out aDataPort;

    oTxData       : out aDataPort;
    oTxShortFrame : out std_ulogic;
    iTxAck        : in  std_ulogic;
    oTxBits       : out std_ulogic_vector(2 downto 0);
    iUidLenDouble : in  std_ulogic;
    iUid          : in  aUid;

    oLayer4RxData       : out aDataPort;
    iLayer4TxData       : in  aDataPort;
    iLayer4TxShortFrame : in  std_ulogic;
    oLayer4TxAck        : out std_ulogic;
    iIsoLayer4Selected  : in  std_ulogic;

    iBitGridIdx       : std_ulogic_vector(LogDualis(cFrameDelayMaxN)-1 downto 0);
    iCyclesToBitStart : std_ulogic_vector(LogDualis(cCyclesPerBit)-1 downto 0)
    );

end Iso14443aPiccLogic;

architecture Rtl of Iso14443aPiccLogic is

  constant cStatusId : aUnitId := SetIdFlags(gPiccId, cDirStatus);
  constant cLogicId  : aUnitId := SetIdFlags(gPiccId, cDirLogic);

  type aRegSet is record
    PiccState    : aPiccState;
    WakeupState  : aPiccWakeupState;
    AnticolState : aPiccAnticolState;
    HaltState    : aPiccHaltState;
    ByteCount    : natural range 0 to 7;
    XorBuf       : std_ulogic_vector(7 downto 0);
    CascadeBit   : std_ulogic;
  end record;
  
  constant cRegInitVal : aRegSet := (PiccState    => PowerOff,
                                     WakeupState  => WaitForREQA,
                                     AnticolState => WaitForSel,
                                     HaltState    => 0,
                                     ByteCount    => 0,
                                     XorBuf       => (others => '0'),
                                     CascadeBit   => '0'
                                     );

  signal R, NextR : aRegSet;

  signal sResetCrcA, sCrcAValidIn : std_ulogic;
  signal sCrcA                    : std_ulogic_vector(15 downto 0);

  signal sTxData : aDataPort;
  
begin  -- Rtl

  CrcA_1 : entity nfc.CrcA
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iSyncReset   => sResetCrcA,
      iDin         => sTxData.Data,
      iValid       => sCrcAValidIn,
      oCrcSum      => sCrcA);

  oTxData       <= sTxData;
  oTxShortFrame <= '0';                 -- TODO!

  Comb : process (R, iRxData, iBitGridIdx, iCyclesToBitStart, iFieldActive, iEnable, iTxAck, iUid, iUidLenDouble, sCrcA, iLayer4TxData, iIsoLayer4Selected, iRxShortFrame, iLayer4TxShortFrame) is

    procedure AlignTxToBitGrid(constant cMinBitsToWait : in natural) is
    begin
      if (VecToInt(iBitGridIdx) >= cMinBitsToWait-1 and
          cTotalInternalLatency = VecToInt(iCyclesToBitStart)) then
        sTxData.Valid <= '1';
      end if;

    end;
    
  begin  -- process Comb
    NextR <= R;
    InitPort(oHostData);
    InitPort(sTxData);

    InitPort(oLayer4RxData);
    oLayer4RxData.Id <= gLayer4Id;
    oLayer4TxAck     <= '0';
    oTxBits          <= (others => '0');
    oHostData.Id     <= gPiccId;
    sResetCrcA       <= '0';
    sCrcAValidIn     <= '0';


    if iEnable = '1' then

      if R.PiccState /= PowerOff and iFieldActive = '0' then
        SendDebugMsg(oHostData, cStatusId, cPiccPowerLost);
        NextR.PiccState <= PowerOff;
      else
        
        case R.PiccState is
          when PowerOff =>
            if iFieldActive = '1' then
              NextR.PiccState   <= Idle;
              NextR.WakeupState <= WaitForREQA;
              SendDebugMsg(oHostData, cStatusId, cPiccPowerOn);
            end if;
          when Idle =>
            
            case R.WakeupState is
              when WaitForREQA =>
                if iRxData.Valid = '1' then
                  if iRxData.Data = cREQA or iRxData.Data = cWUPA then
                    NextR.WakeupState <= SendATQA;
                    NextR.ByteCount   <= 0;
                  end if;
                end if;
                
              when SendATQA =>
                if R.ByteCount = 0 then
                  sTxData.Data <= cATQA1;
                  AlignTxToBitGrid(cAnticolFrameDelay);
                  if iTxAck = '1' then
                    NextR.ByteCount <= 1;
                  end if;
                else
                  sTxData.Data  <= cATQA2;
                  sTxData.Valid <= '1';

                  if iTxAck = '1' then
                    sTxData.Eof        <= '1';
                    NextR.PiccState    <= Ready;
                    SendDebugMsg(oHostData, cLogicId, cPiccIsReady);
                    NextR.AnticolState <= WaitForSel;
                  end if;
                  
                end if;

              when others => null;
            end case;

          when Ready =>
            case R.AnticolState is
              
              when WaitForSEL =>
                if iRxData.Valid = '1' and iRxData.Data = cSEL_CL1 then
                  NextR.AnticolState <= WaitForNVB;
                end if;
                
              when WaitForNVB =>
                if iRxData.Valid = '1' then
                  case iRxData.Data is
                    when x"20" =>
                      NextR.AnticolState <= SendUid;
                      -- we assume that the lower bits of NVB are always 0
                      -- which seems to be acceptable
                      NextR.ByteCount    <= 0;
                      NextR.XorBuf       <= (others => '0');
                    when x"70" =>
                      NextR.AnticolState <= SelectCheckUid;
                      NextR.ByteCount    <= 0;
                    when others =>
                      NextR.AnticolState <= WaitForSEL;
                  end case;
                end if;

              when SelectCheckUid =>    -- todo: actually check the uid
                if iRxData.Valid = '1' then
                  if R.ByteCount = cSelectPayloadLen-1 then
                    NextR.AnticolState <= SendSAK;
                    sResetCrcA         <= '1';
                    NextR.ByteCount    <= 0;
                  else
                    NextR.ByteCount <= R.ByteCount+1;
                  end if;
                end if;
                
              when SendUid =>
                if R.ByteCount = 0 then
                  AlignTxToBitGrid(cAnticolFrameDelay);
                else
                  sTxData.Valid <= '1';
                end if;

                sTxData.Data <= iUid(8*R.ByteCount+7 downto 8*R.ByteCount);
                if iTxAck = '1' then
                  
                  NextR.XorBuf <= R.XorBuf xor iUid(8*R.ByteCount+7 downto
                                                    8*R.ByteCount);
                  if (iUidLenDouble = '1' and R.ByteCount = cUidLenDouble-1) or
                    (iUidLenDouble = '0' and R.ByteCount = cUidLenSingle-1) then
                    NextR.AnticolState <= SendBCC;
                  else
                    NextR.ByteCount <= R.ByteCount+1;
                  end if;
                end if;

              when SendBCC =>
                sTxData.Valid <= '1';
                sTxData.Data  <= R.XorBuf;
                if iTxAck = '1' then
                  sTxData.Eof        <= '1';
                  NextR.AnticolState <= WaitForSEL;
                end if;

              when SendSAK =>

                case R.ByteCount is
                  when 0 =>
                    AlignTxToBitGrid(cAnticolFrameDelay);
                    sTxData.Data <= "00100" & R.CascadeBit & "00";
                    sCrcAValidIn <= iTxAck;
                  when 1 =>
                    sTxData.Data  <= sCrcA(7 downto 0);
                    sTxData.Valid <= '1';
                  when 2 =>
                    sTxData.Data  <= sCrcA(15 downto 8);
                    sTxData.Valid <= '1';
                  when others => null;
                end case;
                if iTxAck = '1' then
                  if R.ByteCount = 3-1 then
                    NextR.PiccState <= Layer4;
                    NextR.HaltState <= 0;
                    NextR.ByteCount <= 0;
                    sTxData.Eof     <= '1';
                    SendDebugMsg(oHostData, cLogicId, cPiccSelected);
                  else
                    NextR.ByteCount <= R.ByteCount+1;
                  end if;
                end if;

              when others =>
                NextR.AnticolState <= WaitForSEL;
            end case;

          when Layer4 =>
            if iRxData.Valid = '1' and iRxShortFrame = '1' then
              if iRxData.Data = cWUPA then
                NextR.PiccState   <= Idle;
                NextR.WakeupState <= SendATQA;
                NextR.ByteCount   <= 0;
                SendDebugMsg(oHostData, cLogicId, cIsoL4Deactivated);
              end if;
            end if;

            -- relay all data from/to layer 4 handlers until we get deselected
            oLayer4RxData <= iRxData;
            sTxData       <= iLayer4TxData;
            oLayer4TxAck  <= iTxAck;
            if iLayer4TxData.Data = x"04" and
              iLayer4TxShortFrame = '1' and iTxAck = '1' then
              NextR.PiccState   <= Idle;
              NextR.WakeupState <= WaitForREQA;
              SendDebugMsg(oHostData, cLogicId, cIsoL4Deactivated);
              NextR.ByteCount   <= 0;
            end if;
            -- make sure that the beginning of the frames are bit-aligned
            if R.ByteCount = 0 then
              sTxData.Valid <= '0';
              if iLayer4TxData.Valid = '1' then
                AlignTxToBitGrid(cLayer4MinFrameDelay);
                if iTxAck = '1' then
                  NextR.ByteCount <= 1;
                end if;
              end if;
            end if;
            if iLayer4TxData.Eof = '1' then
              NextR.ByteCount <= 0;
            end if;

            -- if 14443-4 is disabled or the picc is deselected,
            -- we may receive HLTA
            if iIsoLayer4Selected = '0' then
              
              if iRxData.Valid = '1' and iRxData.Data = cHLTA(R.HaltState) then
                if R.HaltState = aPiccHaltState'right then
                  NextR.WakeupState <= WaitForREQA;
                  NextR.PiccState   <= Idle;
                  SendDebugMsg(oHostData, cLogicId, cPiccHalted);
                else
                  NextR.HaltState <= R.HaltState + 1;
                end if;
              end if;

            end if;

          when Halt =>
            NextR.PiccState   <= Idle;
            NextR.WakeupState <= WaitForREQA;
          when others => null;
        end case;

      end if;
    end if;

  end process Comb;


  Reg : process (iClk, inResetAsync)
  begin  -- process reg
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      R <= cRegInitVal;
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      R <= NextR;
    end if;
  end process Reg;



end Rtl;
