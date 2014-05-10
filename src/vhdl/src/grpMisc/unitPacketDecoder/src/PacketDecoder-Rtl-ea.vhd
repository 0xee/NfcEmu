-------------------------------------------------------------------------------
-- Title      : PacketDecoder
-- Project    : 
-------------------------------------------------------------------------------
-- File       : PacketDecoder-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2014-04-03
-- Last update: 2014-05-10
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-04-03  1.0      lukas   Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

library global;
use global.Global.all;

library misc;

entity PacketDecoder is
  generic (
    gStartByte      : std_ulogic_vector(cDataPortWidth-1 downto 0) := x"AA";
    gStopByte       : std_ulogic_vector(cDataPortWidth-1 downto 0) := x"CC";
    gDataLinkEscape : std_ulogic_vector(cDataPortWidth-1 downto 0) := x"EE");

  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iDin         : in  std_ulogic_vector(7 downto 0);
    iValid       : in  std_ulogic;
    oAckIn       : out std_ulogic;

    oDout   : out aDataPort;
    iAckOut : in  std_ulogic);


end entity PacketDecoder;

architecture Rtl of PacketDecoder is

  type aDleState is (Normal, Escaped);
  type aState is (Idle, Id, Timestamp, Data);

  type aRegSet is record
    State    : aState;
    DleState : aDleState;
    Id       : std_ulogic_vector(7 downto 0);
    TsIdx    : natural range 0 to 3;
  end record;

  constant cRegInitVal : aRegSet := (State    => Idle,
                                     DleState => Normal,
                                     Id       => (others => '-'),
                                     TsIdx    => 0
                                     );

  signal R, NextR : aRegSet;

  signal sPortBuffer    : aDataPort;
  signal sPortBufferAck : std_ulogic;
begin  -- architecture Rtl

  PortBuffer_1 : entity misc.PortBuffer
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sPortBuffer,
      oAckIn       => sPortBufferAck,
      oDout        => oDout,
      iAckOut      => iAckOut);

  Comb : process (R, iValid, iAckOut, iDin) is
  begin  -- process Comb
    NextR          <= R;
    oAckIn         <= '0';
    InitPort(sPortBuffer);
    sPortBuffer.Id <= R.ID;
    case R.State is
      
      when Idle =>
        if iValid = '1' and iDin = gStartByte then
          NextR.State    <= Id;
          NextR.DleState <= Normal;
        end if;
        oAckIn <= iValid;
        
      when Id =>
        if iValid then
          oAckIn      <= '1';
          NextR.Id    <= iDin;
          NextR.State <= Timestamp;
          NextR.TsIdx <= 0;
        end if;
        
        
      when Timestamp =>                 -- timestamp is thrown out        
        if iValid then
          oAckIn <= '1';
          if R.TsIdx = 3 then
            NextR.State    <= Data;
            NextR.DleState <= Normal;
          else
            NextR.TsIdx <= R.TsIdx + 1;
          end if;
        end if;

      when Data =>
        if iValid then
          
          if R.DleState = Escaped then

            if iDin = gStopByte then
              oAckIn          <= '1';
              sPortBuffer.Eof <= '1';
              NextR.State     <= Idle;
              NextR.DleState  <= Normal;
            elsif iDin = gDataLinkEscape then
              Send(sPortBuffer, iDin);
              if sPortBufferAck then
                oAckIn         <= '1';
                NextR.DleState <= Normal;
              end if;
            else
              oAckIn <= '1';
            end if;
            
          else

            if iDin = gDataLinkEscape then
              oAckIn         <= '1';
              NextR.DleState <= Escaped;
            else
              Send(sPortBuffer, iDin);
              oAckIn <= sPortBufferAck;
            end if;
            
          end if;
          
        end if;

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
