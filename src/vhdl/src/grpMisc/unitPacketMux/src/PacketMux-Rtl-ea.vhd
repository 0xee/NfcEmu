
-- Title      : PacketMux
-- Project    : 
-------------------------------------------------------------------------------
-- File       : PacketMux-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2014-03-29
-- Last update: 2014-05-09
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Multiplexer connecting multiple packet sources to a single sink
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-03-29  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library global;
use global.global.all;

entity PacketMux is
  generic (
    gScheduler : aSchedulerType := RoundRobin);  -- see global.aSchedulerType
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iPortIn      : in  aDataPortArray;
    oPortOut     : out aDataPort;
    iAckOut      : in  std_ulogic;
    oDbgSelected : out natural;
    oAckIn       : out std_ulogic_vector);


end entity PacketMux;

architecture Rtl of PacketMux is

  type aState is (Idle, Busy);

  constant cNrOfPorts : natural := iPortIn'length;

  constant cScheduler : aSchedulerType := gScheduler;

  type aRegSet is record
    State      : aState;
    ActivePort : unsigned(LogDualis(cNrOfPorts)-1 downto 0);
  end record aRegSet;

  constant cRegInitVal : aRegSet := (State => Idle, ActivePort => (others => '0'));

  signal R, NextR : aRegSet := cRegInitVal;  -- to avoid metavaue warning
  signal sAckIn   : std_ulogic_vector(oAckIn'range);
begin  -- architecture Rtl

  assert iPortIn'length = oAckIn'length report "Array length mismatch" severity failure;

  oAckIn <= sAckIn;

  Comb : process (R, iPortIn, iAckOut) is
    variable vSelected : natural range 0 to iPortIn'length;

    procedure DetermineNextPort is
      variable vI     : natural range 0 to iPortIn'length := 0;
      variable vFound : boolean                           := false;
    begin
      vSelected := 0;
      case cScheduler is

        when OrderedPriority =>         -- priority scheduler based on
                                        -- port numbers
          for i in 0 to iPortIn'length-1 loop
            if not vFound and iPortIn(i).Valid = '1' then
              vSelected := i;
              vFound := true;
            end if;
          end loop;  -- i
          
        when RoundRobin =>              -- simple round robin scheduler
          vI := to_integer(R.ActivePort);
          for i in 0 to iPortIn'length-1 loop
            vI := (vI + 1) mod iPortIn'length;
				
            if not vFound and iPortIn(vI).Valid = '1' then
              vSelected := vI;
              vFound := true;
            end if;


          end loop;  -- i


        when StaticFirstOnly => null;   -- just forward the first port

      end case;
      
    end;

  begin  -- process Comb

    NextR  <= R;
    sAckIn <= (others => '0');
    InitPort(oPortOut);
    oPortOut.Id <= (others => '-');
    
    case R.State is
      when Idle =>
        DetermineNextPort;

        if iPortIn(vSelected).Valid = '1' then  -- port has data
          NextR.ActivePort <= to_unsigned(vSelected, R.ActivePort'length);
          NextR.State      <= Busy;
        end if;
      when Busy =>
        oPortOut <= iPortIn(to_integer(R.ActivePort));
        sAckIn(to_integer(R.ActivePort)) <= iAckOut;
        
        if iPortIn(to_integer(R.ActivePort)).Eof = '1' and iAckOut = '1' then
          NextR.State <= Idle;
        end if;
        
        
    end case;

    
  end process Comb;

  oDbgSelected <= to_integer(R.ActivePort);
  

  Reg : process (iClk, inResetAsync) is
  begin  -- process Reg
    if inResetAsync = '0' then          -- asynchronous reset (active low)
      R <= cRegInitVal;
    elsif rising_edge(iClk) then        -- rising clock edge
      R <= NextR;
    end if;
  end process Reg;
  
end architecture Rtl;

