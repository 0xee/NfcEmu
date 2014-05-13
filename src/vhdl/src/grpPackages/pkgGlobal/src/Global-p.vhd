-------------------------------------------------------------------------------
-- Title      : Global Project Package
-------------------------------------------------------------------------------
-- $Id: Global-p.vhd 482 2008-10-25 08:06:43Z pfaff $
-------------------------------------------------------------------------------
-- Author     : Copyright 2003: Markus Pfaff
-- Standard   : Using VHDL'93
-- Simulation : Model Technology Modelsim
-- Synthesis  : Exemplar Leonardo
-------------------------------------------------------------------------------
-- Description:
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package Global is

  constant cIdWidth       : natural := 8;
  constant cDataPortWidth : natural := 8;

  type aByteVector is array (natural range <>) of std_ulogic_vector(7 downto 0);

  function LogDualis(cNumber : natural) return natural;
  function PopCount(cV       : std_ulogic_vector) return natural;

  function ToString(constant v   : std_ulogic_vector) return string;
  function ToHex(constant v      : std_ulogic_vector) return string;
  function ToHex(constant cBV    : aByteVector) return string;
  procedure PrintSulv(constant v : std_ulogic_vector);

  function VecToInt(cV  : std_ulogic_vector) return natural;
  function IntToVec (cN : natural; cV : std_ulogic_vector) return std_ulogic_vector;
--  function IntToVec(cN : integer; cV : std_ulogic_vector) return std_ulogic_vector;
  function IntToVec(cN  : natural; cLen : natural) return std_ulogic_vector;
--  function IntToVec(cN : integer; cLen : natural) return std_ulogic_vector;

  function FlipBytes (
    constant cVec : std_ulogic_vector)
    return std_ulogic_vector;
  
  type aSchedulerType is (RoundRobin,   -- normal round robin w/o priorities
                          StaticFirstOnly,   -- selects only the first
                                             -- resource, for debugging
                          OrderedPriority);  -- selects by numerical order, not deadline safe


  subtype aUnitId is std_ulogic_vector(cIdWidth-1 downto 0);

  type aDataPort is record
    Id    : aUnitId;
    Data  : std_ulogic_vector(cDataPortWidth-1 downto 0);
    Valid : std_ulogic;
    Eof   : std_ulogic;
    error : std_ulogic;
  end record;

  type aDataPortArray is array (natural range <>) of aDataPort;

  type aDataPortConnection is record
    DPort : aDataPort;
    Ack   : std_ulogic;
  end record;

  type aDataPortConnectionArray is array (natural range <>) of aDataPortConnection;

  constant cEmptyPort : aDataPort := (Id    => (others => '-'),
                                      Data  => (others => '-'),
                                      Valid => '0',
                                      Eof   => '0',
                                      error => '-');

  
  function ToSulv(constant cPort : in aDataPort) return std_ulogic_vector;

  constant cEmptyPortVec : std_ulogic_vector(17 downto 0) := (others => '-');

  function ToDataPort(constant cVec : in std_ulogic_vector) return aDataPort;
  function ToDataPort(constant cVec   : in std_ulogic_vector;
                      constant cValid : in std_ulogic) return aDataPort;

  procedure InitPort (signal sPort : out aDataPort);
  procedure SendDebugMsg (signal sPort  : out aDataPort;
                          constant cId  : in  aUnitId;
                          constant cMsg :     natural);

  function SetValid (
    constant cPort  : aDataPort;
    constant cValid : std_ulogic) return aDataPort;

  function SetErrorFlag (
    constant cPort  : aDataPort;
    constant cError : std_ulogic) return aDataPort;

  function SetEof (
    constant cPort : aDataPort;
    constant cEof  : std_ulogic) return aDataPort;

  function SetId (
    constant cPort : aDataPort;
    constant cId   : std_ulogic_vector) return aDataPort;

  function SetIdFlags(constant cId    : in std_ulogic_vector;
                      constant cFlags : in std_ulogic_vector) return std_ulogic_vector;

  function ComposePort (constant cId    : std_ulogic_vector;
                        constant cData  : std_ulogic_vector;
                        constant cValid : std_ulogic;
                        constant cEof   : std_ulogic;
                        constant cError : std_ulogic) return aDataPort;

  function DataValid (constant cPort : aDataPort) return boolean;

  procedure Send(signal sPort   : out aDataPort;
                 constant cData : in  std_ulogic_vector);

  procedure Send(signal sPort   : out aDataPort;
                 signal sAck    : in  std_ulogic;
                 signal sClk    : in  std_ulogic;
                 constant cData : in  std_ulogic_vector(cDataPortWidth-1 downto 0));

  procedure Send(signal sPort   : out aDataPort;
                 signal sAck    : in  std_ulogic;
                 signal sClk    : in  std_ulogic;
                 constant cData : in  std_ulogic_vector(cDataPortWidth-1 downto 0);
                 constant cEof  : in  boolean);

  procedure SendPacket(signal sPort   : out aDataPort;
                       signal sAck    : in  std_ulogic;
                       signal sClk    : in  std_ulogic;
                       constant cData : in  std_ulogic_vector);


  procedure SendPacket(signal sPort   : out aDataPort;
                       signal sAck    : in  std_ulogic;
                       signal sClk    : in  std_ulogic;
                       constant cData : in  std_ulogic_vector;
                       constant cId   : in  std_ulogic_vector(cIdWidth-1 downto 0));

  procedure ExpectPacket (signal sPort     : in aDataPort;
                          signal sClk      : in std_ulogic;
                          constant cPacket : in std_ulogic_vector);



end Global;



package body Global is


  -- Function LogDualis returns the logarithm of base 2 as an integer.
  -- Although the implementation of this function was not done with synthesis
  -- efficiency in mind, the function has to be synthesizable, because it is
  -- often used in static calculations.
  function LogDualis(cNumber : natural) return natural is
    -- Initialize explicitly (will have warnings for uninitialized variables 
    -- from Quartus synthesis otherwise).
    variable vClimbUp : natural := 1;
    variable vResult  : natural := 0;
  begin
    while vClimbUp < cNumber loop
      vClimbUp := vClimbUp * 2;
      vResult  := vResult+1;
    end loop;
    return vResult;
  end LogDualis;


  function ToString(constant v : std_ulogic_vector) return string is
    variable s : string(3 downto 1);
    variable r : string((v'left+1) downto (v'right+1));
  begin
    for i in v'left downto v'right loop
      --report std_logic'image(v(i));
      s      := std_ulogic'image(v(i));
      --string must start/stop at 1
      --          '1' we need only the second character
      r(i+1) := s(2);
    end loop;
    return r;
  end;


  function ToHex(constant v : std_ulogic_vector) return string is
    variable c         : character;
    variable s         : string(((v'length+3)/4) downto 1);
    constant cOriented : std_ulogic_vector(v'length-1 downto 0) := v;
    variable vIdx      : natural                                := 0;
    variable vNibble   : std_ulogic_vector(3 downto 0);
  begin
    s := (others => 'x');
    while vIdx < cOriented'length loop
      
      vNibble := x"0";
      for j in vNibble'range loop
        if (j+vIdx) <= cOriented'left then
          vNibble(j) := cOriented(vIdx+j);
--          report "bit: " & std_ulogic'image(vNibble(j));
        end if;
      end loop;  -- j
--      report "nibble: " & ToString(vNibble) & " @" & integer'image(vIdx/4+1);

      case vNibble is
        when "0000" => c := '0';
        when "0001" => c := '1';
        when "0010" => c := '2';
        when "0011" => c := '3';
        when "0100" => c := '4';
        when "0101" => c := '5';
        when "0110" => c := '6';
        when "0111" => c := '7';
        when "1000" => c := '8';
        when "1001" => c := '9';
        when "1010" => c := 'A';
        when "1011" => c := 'B';
        when "1100" => c := 'C';
        when "1101" => c := 'D';
        when "1110" => c := 'E';
        when "1111" => c := 'F';
        when others => c := 'x';
      end case;

      s(vIdx/4+1) := c;
      vIdx        := vIdx + 4;
    end loop;
    return s;
  end;

  function ToHex(constant cBV : aByteVector) return string is
    variable vS   : string(cBV'length*3 downto 1) := (others => ' ');
    variable vIdx : natural                       := vS'left;
  begin
    for i in cBV'range loop
      vS(vIdx downto vIdx-1) := ToHex(cBV(i));
      vIdx                   := vIdx - 3;
    end loop;  -- cBV'range
    return vS;
  end;


  procedure PrintSulv(constant v : std_ulogic_vector) is
    variable s : string(3 downto 1);
    variable r : string((v'left+1) downto (v'right+1));
  begin
    for i in v'left downto v'right loop
      --report std_logic'image(v(i));
      s      := std_ulogic'image(v(i));
      --string must start/stop at 1
      --          '1' we need only the second character
      r(i+1) := s(2);
    end loop;
    report "Debug: " & v'instance_name & " = " & r;
  end PrintSulv;

  function PopCount(cV : std_ulogic_vector) return natural is
    variable vCnt : natural range 0 to cV'length := 0;
  begin
    for i in cV'range loop
      if cV(i) = '1' then
        vCnt := vCnt + 1;
      end if;
    end loop;
    return vCnt;
  end;

  function VecToInt(cV : std_ulogic_vector) return natural is
  begin
    return to_integer(unsigned(cV));
  end;

  function IntToVec(cN : natural; cV : std_ulogic_vector) return std_ulogic_vector is
  begin
    return IntToVec(cN, cV'length);
  end;

--function IntToVec(cN : integer; cV : std_ulogic_vector) return std_ulogic_vector is
--begin
--  return IntToVec(cN, cV'length);
--end;

  function IntToVec(cN : natural; cLen : natural) return std_ulogic_vector is
  begin
    return std_ulogic_vector(to_unsigned(cN, cLen));
  end;

--function IntToVec(cN : integer; cLen : natural) return std_ulogic_vector is
--begin
--  return std_ulogic_vector(to_signed(cN, cLen));
--end;

  function ToSulv(constant cPort : in aDataPort) return std_ulogic_vector is
    constant cVec : std_ulogic_vector(17 downto 0) := cPort.Eof & cPort.error &
                                                      cPort.Id & cPort.Data;
  begin
    return cVec;
  end;

  function ToDataPort(constant cVec : in std_ulogic_vector) return aDataPort is
  begin
    return (Data  => cVec(7 downto 0), Id => cVec(15 downto 8),
            error => cVec(16), Eof => cVec(17), Valid => '-');
  end;

  function ToDataPort(constant cVec   : in std_ulogic_vector;
                      constant cValid : in std_ulogic) return aDataPort is
    constant cTmpVec : std_ulogic_vector(cVec'length-1 downto 0) := cVec;
  begin
    return (Data  => cTmpVec(7 downto 0), Id => cTmpVec(15 downto 8),
            error => cTmpVec(16), Eof => cTmpVec(17), Valid => cValid);
  end;

  function SetValid (
    constant cPort  : aDataPort;
    constant cValid : std_ulogic)
    return aDataPort is
    variable vPort : aDataPort := cPort;
  begin
    vPort.Valid := cValid;
    return vPort;
  end;

  function SetErrorFlag (
    constant cPort  : aDataPort;
    constant cError : std_ulogic) return aDataPort is
    variable vPort : aDataPort := cPort;
  begin
    vPort.error := cError;
    return vPort;
  end;

  function SetEof (
    constant cPort : aDataPort;
    constant cEof  : std_ulogic) return aDataPort is
    variable vPort : aDataPort := cPort;
  begin
    vPort.eof := cEof;
    return vPort;
  end;

  function SetId (
    constant cPort : aDataPort;
    constant cId   : std_ulogic_vector) return aDataPort is
    variable vPort : aDataPort := cPort;
  begin
    vPort.Id := cId;
    return vPort;
  end;

  function ComposePort (constant cId    : std_ulogic_vector;
                        constant cData  : std_ulogic_vector;
                        constant cValid : std_ulogic;
                        constant cEof   : std_ulogic;
                        constant cError : std_ulogic) return aDataPort is
    constant cDataPort : aDataPort := (Id  => cId, Data => cData, Valid => cValid,
                                       Eof => cEof, error => cError);
  begin
    return cDataPort;
  end;



  procedure InitPort (signal sPort : out aDataPort) is
  begin
    sPort.Id    <= (others => '-');
    sPort.Valid <= '0';
    sPort.Eof   <= '0';
    sPort.error <= '0';
    sPort.Data  <= (others => '-');
  end procedure;


  procedure Send(signal sPort   : out aDataPort;
                 constant cData : in  std_ulogic_vector(cDataPortWidth-1 downto 0)) is
  begin
    sPort.Valid <= '1';
    sPort.error <= '0';
    sPort.Data  <= cData;
  end procedure;

  procedure Send(signal sPort   : out aDataPort;
                 signal sAck    : in  std_ulogic;
                 signal sClk    : in  std_ulogic;
                 constant cData : in  std_ulogic_vector(cDataPortWidth-1 downto 0);
                 constant cEof  : in  boolean) is
  begin
--    PrintSulv(cData);
    sPort.Eof <= '0';
    if cEof then
      sPort.Eof <= '1';
    end if;
    sPort.Valid <= '1';
    sPort.Data  <= cData;

    wait until rising_edge(sClk) and sAck = '1';
    sPort.Valid <= '0';
    sPort.Data  <= (others => '-');
    sPort.Eof   <= '0';
  end procedure;

  procedure Send(signal sPort   : out aDataPort;
                 signal sAck    : in  std_ulogic;
                 signal sClk    : in  std_ulogic;
                 constant cData : in  std_ulogic_vector(cDataPortWidth-1 downto 0)) is
  begin
    Send(sPort, sAck, sClk, cData, false);
  end procedure;


  procedure SendPacket(signal sPort   : out aDataPort;
                       signal sAck    : in  std_ulogic;
                       signal sClk    : in  std_ulogic;
                       constant cData : in  std_ulogic_vector) is
    constant cLen    : natural                                    := cData'length/sPort.Data'length;
    constant cPacket : std_ulogic_vector(cData'length-1 downto 0) := cData;  --
-- to assure right byte order
  begin
    for i in 0 to cLen-1 loop
      Send(sPort, sAck, sClk, cPacket(8*(i+1)-1 downto 8*i), i = cLen-1);
    end loop;  -- i
  end;

  procedure SendPacket(signal sPort   : out aDataPort;
                       signal sAck    : in  std_ulogic;
                       signal sClk    : in  std_ulogic;
                       constant cData : in  std_ulogic_vector;
                       constant cId   : in  std_ulogic_vector(cIdWidth-1 downto 0)) is
  begin
    sPort.Id <= cId;
    SendPacket(sPort, sAck, sClk, cData);
  end;

  procedure SendPacket(signal sPort   : inout aDataPortConnection;
                       signal sClk    : in    std_ulogic;
                       constant cData : in    std_ulogic_vector;
                       constant cId   : in    std_ulogic_vector(cIdWidth-1 downto 0)) is
  begin
    sPort.DPort.Id <= cId;
    SendPacket(sPort.DPort, sPort.Ack, sClk, cData);
  end;


  function DataValid (
    constant cPort : aDataPort)
    return boolean is
  begin
    return cPort.Valid = '1';
  end function DataValid;


  procedure SendDebugMsg (signal sPort  : out aDataPort;
                          constant cId  : in  aUnitId;
                          constant cMsg :     natural range 0 to 2**8-1) is
  begin
    sPort.Data  <= std_ulogic_vector(to_unsigned(cMsg, 8));
    sPort.Valid <= '1';
    sPort.Eof   <= '1';
--    sPort.ShortFrame <= '1';
  end;


  function FlipBytes (
    constant cVec : std_ulogic_vector)
    return std_ulogic_vector is
    constant cLen     : natural                                   := cVec'length/8;
    constant cVec2    : std_ulogic_vector(cVec'length-1 downto 0) := cVec;
    variable vFlipped : std_ulogic_vector(cVec'length-1 downto 0);
  begin
    assert 8*cLen = cVec'length report "Invalid vector size" severity failure;

    for i in 0 to cLen-1 loop
      vFlipped(8*(i+1)-1 downto 8*i) := cVec2(8*(cLen-i)-1 downto 8*(cLen-i-1));
    end loop;  -- i

    return vFlipped;
    
  end function;
  
  procedure ExpectPacket (signal sPort     : in aDataPort;
                          signal sClk      : in std_ulogic;
                          constant cPacket : in std_ulogic_vector) is
    constant cData : std_ulogic_vector(cPacket'length-1 downto 0) := cPacket;
    variable vNext : std_ulogic_vector(7 downto 0);
    constant cLen  : natural                                      := cPacket'length/sPort.Data'length;
    variable vId   : std_ulogic_vector(sPort.Id'range);
  begin
    --report ToHex(cData);
    for i in 0 to cLen-1 loop
      
      
      vNext := cData(8*(i+1)-1 downto 8*i);
      --report "expecting: " & ToHex(vNext);
      wait until rising_edge(sClk) and sPort.Valid = '1';
      if i = 0 then
        vId := sPort.Id;
      end if;
      assert vNext = sPort.Data
        report "Data mismatch: ID = " & ToHex(vId) & ", rx = " & ToHex(sPort.Data) & ", expected = " & ToHex(vNext)
        severity failure;

      assert i < cLen-1 or sPort.Eof = '1'
        report "Packet longer than expected"
        severity failure;

      assert i = cLen-1 or sPort.Eof = '0'
        report "Packet shorter than expected"
        severity failure;
      
    end loop;
    report "Packet received from " & ToHex(vId) & ": " & ToHex(FlipBytes(cData));
    
  end;
  
  function SetIdFlags(constant cId    : in std_ulogic_vector;
                      constant cFlags : in std_ulogic_vector) return std_ulogic_vector is
    variable vId : std_ulogic_vector(cId'range) := cId;
  begin
    vId(cId'left downto cId'left-cFlags'length+1) := cFlags;
    return vId;
  end;
  

end Global;
