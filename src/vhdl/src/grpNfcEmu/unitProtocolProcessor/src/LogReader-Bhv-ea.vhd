library ieee;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;

entity LogReader is
  generic (
    gFileName      : string;
    gMaxPacketSize : natural := 256;
    gTsUnit        : time    := 1 us);
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    oPacket      : out std_ulogic_vector(8*gMaxPacketSize-1 downto 0);
    oLen         : out natural;
    oValid       : out std_ulogic;
    iAck         : in  std_ulogic
    );

end entity LogReader;

architecture Bhv of LogReader is

  file log : text open read_mode is gFileName;

  
  
begin  -- architecture Bhv


  Reader : process is
    variable l         : line;
    variable c         : character;
    variable str       : string(1 to 1234);
    variable nibbleIdx : natural;
    variable i         : natural;
    variable ts        : integer;
    function GetNibble (
      c : character)
      return std_ulogic_vector is
    begin
      case c is
        when '0'    => return "0000";
        when '1'    => return "0001";
        when '2'    => return "0010";
        when '3'    => return "0011";
        when '4'    => return "0100";
        when '5'    => return "0101";
        when '6'    => return "0110";
        when '7'    => return "0111";
        when '8'    => return "1000";
        when '9'    => return "1001";
        when 'a'    => return "1010";
        when 'b'    => return "1011";
        when 'c'    => return "1100";
        when 'd'    => return "1101";
        when 'e'    => return "1110";
        when 'f'    => return "1111";
        when 'A'    => return "1010";
        when 'B'    => return "1011";
        when 'C'    => return "1100";
        when 'D'    => return "1101";
        when 'E'    => return "1110";
        when 'F'    => return "1111";
        when others => return "XXXX";
      end case;
    end;

    function ToTime(ts : integer)
      return time is
    begin
      return ts*gTsUnit;
    end;
    
  begin  -- process Reader
    oValid  <= '0';
    oPacket <= (others => '0');

    read_file: loop
      str := (others => 'x');

      find_nonempty: loop
        readline(log, l);
        exit find_nonempty when l'length > 0;
        exit read_file when endfile(log);
      end loop;
      i   := 1;

      read(l, c);

      if c = '[' then
        read(l, ts);
        --report "Next packet @" & time'image(ToTime(ts));
        wait until rising_edge(iClk) and now >= ToTime(ts);
      end if;

      c := 'x';

      while c /= ':' and l'length > 0 loop
        read(l, c);
      --report character'image(c);
      end loop;

      nibbleIdx := 0;
      
      while l'length > 0 loop
        
        read(l, c);
        --report character'image(c) & ", " & integer'image(l'length) & " left";
        if (c >= '0' and c <= '9') or
          (c >= 'a' and c                           <= 'f') or
          (c >= 'A' and c                           <= 'F') then
          oPacket(4*nibbleIdx+3 downto 4*nibbleIdx) <= GetNibble(c);
          nibbleIdx                                 := nibbleIdx + 1;
        end if;

      end loop;  -- j

      --report "presenting " & integer'image(nibbleIdx/2) & " bytes";
      
      oLen   <= 4*nibbleIdx;
      oValid <= '1';
      wait until rising_edge(iClk) and iAck = '1';
      oValid <= '0';

      
    end loop;


    wait;
  end process Reader;
  

end architecture Bhv;
