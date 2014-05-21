
-- Title      : PacketMux
-- Project    : 
-------------------------------------------------------------------------------
-- File       : PacketMux-Rtl-ea.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2014-03-29
-- Last update: 2014-05-15
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
    oTimeStamp   : out std_ulogic_vector(31 downto 0);
    iAckOut      : in  std_ulogic;
    oDbgSelected : out natural;
    oAckIn       : out std_ulogic_vector);


end entity PacketMux;

architecture Rtl of PacketMux is

  type aState is (Idle, Sending);
  type aPortState is (Idle, InFifo, Sending);
  type aPortStateArray is array (natural range <>) of aPortState;

  subtype aTimeStamp is unsigned(31 downto 0);
  subtype aPortIdx is unsigned(LogDualis(iPortIn'length)-1 downto 0);

  type aRegSet is record
    State      : aState;
    TsNow      : aTimeStamp;
    PortStates : aPortStateArray(iPortIn'range);
  end record;

  signal R, NextR : aRegSet;
  constant cRegInitVal : aRegSet := (State      => Idle,
                                     TsNow      => (others => '0'),
                                     PortStates => (others => Idle));

  function Bundle (Ts : aTimeStamp; Idx : natural) return std_ulogic_vector is
  begin
    return std_ulogic_vector(Ts) & IntToVec(Idx, aPortIdx'length);
  end;

  function TsFromBundle (Bundle : std_ulogic_vector) return aTimeStamp is
  begin
    return unsigned(Bundle(Bundle'left downto Bundle'length-aTimeStamp'length));
  end;

  function IdxFromBundle (Bundle : std_ulogic_vector) return integer is
  begin
    return VecToInt(Bundle(aPortIdx'range));
  end;

  signal sTsFifoIn, sTsFifoOut : std_ulogic_vector(aTimeStamp'length + aPortIdx'length -1 downto 0);

  signal sTsFifoAckIn, sTsFifoValidIn,
    sTsFifoAckOut, sTsFifoValidOut : std_ulogic;

  signal sAckIn : std_ulogic_vector(iPortIn'range);
begin  -- architecture Rtl

  Fifo_1 : entity work.GenFifo(Rtl)
    generic map (
      gDepth => iPortIn'length,
      gWidth => sTsFifoIn'length)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sTsFifoIn,
      iValid       => sTsFifoValidIn,
      oAck         => sTsFifoAckIn,
      oDout        => sTsFifoOut,
      oValid       => sTsFifoValidOut,
      iAck         => sTsFifoAckOut);

  oTimeStamp <= std_ulogic_vector(TsFromBundle(sTsFifoOut));

  oAckIn <= sAckIn;
  
  Comb : process(all) is
    variable vToInsert : natural range 0 to iPortIn'length;
  begin  -- process Comb
    NextR       <= R;
    NextR.TsNow <= R.TsNow + 1;
    sAckIn <= (others => '0');
    sTsFifoAckOut <= '0';
    sTsFifoIn <= (others => '0');
    sTsFifoValidIn <= '0';
    oPortOut <= cEmptyPort;
    
    -- look for a port with pending data
    vToInsert := iPortIn'length;
    for i in iPortIn'range loop
      if R.PortStates(i) = Idle and iPortIn(i).Valid = '1' then
        vToInsert := i;
      end if;
    end loop;
    
    -- if a port has been found, insert ts+index into fifo
    if vToInsert /= iPortIn'length then
      sTsFifoIn      <= Bundle(R.TsNow, vToInsert);
      sTsFifoValidIn <= '1';
      if sTsFifoAckIn then              -- if fifo acks, update portstate
        NextR.PortStates(vToInsert) <= InFifo;
      end if;
    end if;

    case R.State is
      when Idle =>
        if sTsFifoValidOut then
          NextR.State                                 <= Sending;
          NextR.PortStates(IdxFromBundle(sTsFifoOut)) <= Sending;
        end if;

      when Sending =>
        oPortOut <= iPortIn(IdxFromBundle(sTsFifoOut));

        if iAckOut then
           sAckIn(IdxFromBundle(sTsFifoOut)) <= '1';
          
          if iPortIn(IdxFromBundle(sTsFifoOut)).Eof then
            sTsFifoAckOut <= '1';
            NextR.PortStates(IdxFromBundle(sTsFifoOut)) <= Idle;
            NextR.State                                 <= Idle;
          end if;
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




--architecture Rtl of PacketMux is

--  type aState is (Idle, CopyTs, Busy);

--  constant cNrOfPorts : natural := iPortIn'length;

--  constant cScheduler : aSchedulerType := gScheduler;

--  type aTimeStampArray is array (natural range <>) of unsigned(31 downto 0);

--  type aRegSet is record
--    State       : aState;
--    ActivePort  : unsigned(LogDualis(cNrOfPorts)-1 downto 0);
--    CurrentTime : unsigned(31 downto 0);
--    TsOut       : unsigned(31 downto 0);
--    FirstSeen   : aTimeStampArray(iPortIn'range);
--  end record aRegSet;

--  constant cRegInitVal : aRegSet := (State       => Idle,
--                                     ActivePort  => (others => '0'),
--                                     CurrentTime => (others => '0'),
--                                     TsOut       => (others => '0'),
--                                     FirstSeen   => (others => (others => '0')));

--  signal R, NextR     : aRegSet := cRegInitVal;  -- to avoid metavaue warning
--  signal sAckIn       : std_ulogic_vector(oAckIn'range);
--  signal sPacketStart : std_ulogic_vector(iPortIn'range);
--begin  -- architecture Rtl

--  assert iPortIn'length = oAckIn'length report "Array length mismatch" severity failure;

--  oAckIn <= sAckIn;

--  oTimeStamp <= std_ulogic_vector(R.TsOut);


--  Comb : process (R, iPortIn, iAckOut) is
--    variable vSelected : natural range 0 to iPortIn'length;

--    procedure DetermineNextPort is
--      variable vI     : natural range 0 to iPortIn'length := 0;
--      variable vFound : boolean                           := false;
--    begin
--      vSelected := 0;
--      case cScheduler is

--        when OrderedPriority =>         -- priority scheduler based on
--                                        -- port numbers
--          for i in 0 to iPortIn'length-1 loop
--            if not vFound and iPortIn(i).Valid = '1' then
--              vSelected := i;
--              vFound    := true;
--            end if;
--          end loop;  -- i

--        when RoundRobin =>              -- simple round robin scheduler
--          vI := to_integer(R.ActivePort);
--          for i in 0 to iPortIn'length-1 loop
--            vI := (vI + 1) mod iPortIn'length;

--            if not vFound and iPortIn(vI).Valid = '1' then
--              vSelected := vI;
--              vFound    := true;
--            end if;
--          end loop;  -- i

--        when EarliestFirst =>
--          for i in 0 to iPortIn'length-1 loop
--            if iPortIn(i).Valid = '1' then
--              if R.FirstSeen(i) < R.FirstSeen(vSelected) then
--                vSelected := i;
--              end if;
--            end if;
--          end loop;  -- i


--        when StaticFirstOnly => null;   -- just forward the first port

--      end case;

--    end;

--  begin  -- process Comb

--    NextR       <= R;
--    sAckIn      <= (others => '0');
--    InitPort(oPortOut);
--    oPortOut.Id <= (others => '-');

--    NextR.CurrentTime <= R.CurrentTime + 1;

--    for i in sPacketStart'range loop
--      if sPacketStart(i) then
--        NextR.FirstSeen(i) <= R.CurrentTime;
--      end if;
--    end loop;  -- i


--    case R.State is
--      when Idle =>
--        DetermineNextPort;
--        if iPortIn(vSelected).Valid = '1' then  -- port has data
--          NextR.ActivePort <= to_unsigned(vSelected, R.ActivePort'length);
--          NextR.State      <= CopyTs;
--        end if;

--      when CopyTs =>
--        NextR.TsOut <= R.FirstSeen(vSelected);
--        NextR.State <= Busy;

--      when Busy =>
--        oPortOut                         <= iPortIn(to_integer(R.ActivePort));
--        sAckIn(to_integer(R.ActivePort)) <= iAckOut;

--        if iPortIn(to_integer(R.ActivePort)).Eof = '1' and iAckOut = '1' then
--          NextR.State <= Idle;
--        end if;


--    end case;


--  end process Comb;

--  oDbgSelected <= to_integer(R.ActivePort);


--  Reg : process (iClk, inResetAsync) is
--  begin  -- process Reg
--    if inResetAsync = '0' then          -- asynchronous reset (active low)
--      R <= cRegInitVal;
--    elsif rising_edge(iClk) then        -- rising clock edge
--      R <= NextR;
--    end if;
--  end process Reg;

--end architecture Rtl;

