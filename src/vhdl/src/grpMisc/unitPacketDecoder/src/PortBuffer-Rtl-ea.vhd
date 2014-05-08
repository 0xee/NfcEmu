-------------------------------------------------------------------------------
-- Title      : PortBuffer
-- Project    : 
-------------------------------------------------------------------------------
-- File       : PortBuffer-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2014-04-03
-- Last update: 2014-05-01
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Buffers a word and forwards it as soon as the next one or the
-- eof flag appears, to make sure eof and last byte are synchronized at the
-- output port
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-04-03  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library Global;
use global.Global.all;

entity PortBuffer is
  
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iDin         : in  aDataPort;
    oAckIn       : out std_ulogic;
    oDout        : out aDataPort;
    iAckOut      : in  std_ulogic);

end entity PortBuffer;

architecture Rtl of PortBuffer is

  type aState is (Empty, DataStored, DataAndEof);

  type aRegSet is record
    State : aState;
    Data  : std_ulogic_vector(iDin.Data'range);
  end record;

  constant cRegInitVal : aRegSet := (State => Empty,
                                     Data  => (others => '-'));


  signal R, NextR : aRegSet;


  signal sStore : std_ulogic;
  
begin  -- architecture Rtl

  Comb : process (all) is
  begin  -- process Comb
    NextR    <= R;
    InitPort(oDout);
    oAckIn   <= '0';
    oDout.Id <= iDin.Id;

    case R.State is
      
      when Empty =>
        if iDin.Valid then
          oAckIn <= '1';
          NextR.Data <= iDin.Data;
          if iDin.Eof then
            NextR.State <= DataAndEof;
          else
            NextR.State <= DataStored;
          end if;
        end if;
        
      when DataStored =>
        if iDin.Eof then
          NextR.State <= DataAndEof;
        end if;
        if iDin.Valid then
          Send(oDout, R.Data);
          if iAckOut then
            oAckIn <= '1';
            NextR.Data <= iDin.Data;
          end if;
        end if;

      when DataAndEof =>
        Send(oDout, R.Data);
        oDout.Eof <= '1';
        if iAckOut then
          NextR.State <= Empty;
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
