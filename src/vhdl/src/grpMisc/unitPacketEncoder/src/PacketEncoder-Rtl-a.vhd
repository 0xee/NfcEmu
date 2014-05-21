-------------------------------------------------------------------------------
-- Title      : PacketEncoder
-- Project    : 
-------------------------------------------------------------------------------
-- File       : PacketEncoder-Rtl-a.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2014-03-11
-- Last update: 2014-05-14
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-03-11  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library global;
use global.Global.all;

architecture Rtl of PacketEncoder is

  type aState is (Idle, Start, Id, Timestamp, Data, Stop, Stats);
  type aDleState is (Normal, Escaped);

  type aRegSet is record
    State    : aState;
    DleState : aDleState;
    TsTmp    : unsigned(31 downto 0);
    TsIdx    : natural range 0 to 3;
    DataCount : unsigned(iDin.Data'range);
  end record aRegSet;

  constant cRegInitVal : aRegSet := (State   => Idle, DleState => Normal,
                                     TsTmp   => (others => '0'),
                                     TsIdx   => 0,
                                     DataCount => (others => '0'));

  signal R, NextR : aRegSet;

  signal sDout     : std_ulogic_vector(7 downto 0);
  signal sValidOut : std_ulogic;

  procedure Set(signal s : out std_ulogic) is
  begin
    s <= '1';
  end procedure Set;


  
begin  -- architecture Rtl

  oDout  <= sDout;
  oValid <= sValidOut;

  Comb : process (R, iDin, iAckOut) is
  begin  -- process Comb
    NextR         <= R;
    oAckIn        <= '0';
    sValidOut     <= '0';
    sDout         <= (others => '-');
    oBusy         <= '1';
    oEof          <= '0';

    case R.State is
      when Idle =>
        oBusy <= '0';
        if DataValid(iDin) then
          NextR.State    <= Start;
          NextR.DleState <= Normal;
          NextR.TsTmp    <= unsigned(iTs);
        end if;
        
      when Start =>
        sDout     <= gStartByte;
        sValidOut <= '1';
        if iAckOut = '1' then
          NextR.DataCount <= (others => '0');
          NextR.State <= Id;
        end if;

      when Id =>
        sDout     <= iDin.Id;
        sValidOut <= '1';
        if iAckOut = '1' then
          NextR.State <= Timestamp;
          NextR.TsIdx <= 0;
        end if;
        
      when Timestamp =>
        sDout     <= std_ulogic_vector(R.TsTmp(sDout'range));
        sValidOut <= '1';
        if iAckOut then
          if R.TsIdx = 3 then
            NextR.State    <= Data;
            NextR.DleState <= Normal;
          else
            NextR.TsTmp <= x"00" & R.TsTmp(R.TsTmp'left downto 8);
            NextR.TsIdx <= R.TsIdx + 1;
          end if;
        end if;
        
      when Data =>
        if R.DleState = Escaped then
          sValidOut <= '1';
          sDout     <= gDataLinkEscape;
          
          if iAckOut = '1' then
            NextR.DataCount <= R.DataCount + 1;
            oAckIn         <= '1';
            NextR.DleState <= Normal;
            if iDin.Eof = '1' then
              NextR.State <= Stop;
            end if;
          end if;
        else

          if iDin.Valid = '1' then
            sValidOut <= '1';
            if iDin.Data = gDataLinkEscape then
              sDout <= gDataLinkEscape;
              if iAckOut = '1' then
                NextR.DataCount <= R.DataCount + 1;
                NextR.DleState <= Escaped;
              end if;
            else
              sDout <= iDin.Data;
              if iAckOut = '1' then
                oAckIn <= '1';
                if iDin.Eof = '1' then
                  NextR.State <= Stop;
                end if;
              end if;
            end if;

          end if;
          
        end if;

      when Stop =>
        sValidOut <= '1';
        case R.DleState is
          when Normal =>
            sDout <= gDataLinkEscape;
            if iAckOut = '1' then
              NextR.DleState <= Escaped;
            end if;
          when Escaped =>
            oEof  <= '1';
            sDout <= gStopByte;
            if iAckOut = '1' then
              NextR.State <= Idle;
            end if;
        end case;

      when Stats =>
        sValidOut <= '1';
        sDout <= std_ulogic_vector(R.DataCount);
        
        if iAckOut then
          NextR.State <= Idle;
        end if;
        
      when others => null;
    end case;
    
    
  end process Comb;



  Reg : process (iClk, inResetAsync) is
  begin  -- process Reg
    if inResetAsync = '0' then          -- asynchronous reset (active low)
      R <= cRegInitVal;
    elsif rising_edge(iClk) then        -- rising clock edge
      R <= NextR;
    end if;
  end process Reg;
  

end architecture Rtl;
