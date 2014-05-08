-- comment


library ieee;

use ieee.std_logic_1164.all;
--use work.abc.all;
entity enti is

  generic (
    bla  : std_ulogic                    := '1';
    bla1 : std_ulogic_vector(1 downto 0) := "-0";
    bla2 : natural                       := 1;
    bla3 : std_ulogic_vector             := "00");

  port (
    bla4 : in std_ulogic;
    bla5 : in std_ulogic);

end;

architecture rtl of enti is

begin  -- architecture rtl

  

end architecture rtl;

architecture bhv of enti is

begin  -- architecture bhv

  

end architecture bhv;

package pd is

  constant c : natural;

end package pd;

package body pd is

  constant c : natural := 1;

end package body pd;

entity enti2 is

end entity enti2;


entity enti3 is
begin
end entity;

architecture rtl of enti3 is

begin  -- architecture rtl



end architecture rtl;

entity enti4 is

end enti4;

library ieee;
use ieee.std_logic_1164.all;
use work.pd.all;
architecture Rtl of enti4 is

  constant c : natural    := 1;
  signal s   : std_ulogic := '1';

  type t1 is array (0 to 1) of std_ulogic_vector(7 downto 0);
  type t2 is array (natural range <>) of std_ulogic_vector(1 downto 0);

  function f1 (
    signal sig : std_ulogic_vector(1 to 9); constant c : in natural) return boolean is
    variable v : natural := c;
  begin
    return false;
  end;

  signal d : std_ulogic_vector(8 downto 0);


  component compi is

    generic (
      foo : std_ulogic);
    port (
      bar : in std_ulogic);

  end component compi;
  
begin  -- architecture rtl

  enti_1 : entity work.enti
    port map (
      bla4 => '0',
      bla5 => '0');

  a : s <= '0';

  d(1 downto 0) <= '1' & s;



  g : for i in 1 to 3 generate
    enti_2 : entity work.enti(rtl)
      port map (
        bla4 => '0',
        bla5 => '1');


    foo : if c = 1 generate

      enti_3 : entity work.enti(bhv)
        port map (
          bla4 => '0',
          bla5 => not '1');

      enti_4 : compi
        generic map (
          foo => '0')
        port map (
          bar => s);

    end generate foo;

    d(2) <= not s;
  end generate;

  p : process (s) is
    constant s1 : integer := 2;
  begin  -- process bla
    if s = '0' then                     -- asynchronous reset (active low)

    elsif rising_edge(s) then           -- rising clock edge
      d(4) <= '1';
    else
      d(4) <=
        d
        (
          d'left
          )       
        nand
        d(1);
    end if;


    assert d = "000000000" report "blubb";
    assert d(s1) = '1' report "blubb";
    assert d(s1) = not d(1) report "blubb";

    for i in 0 to 1 loop
      if i = 0 then
        
        assert d(s1) = d(d'left) report "blubb" & integer'image(s1);
      end if;
    end loop;  -- i

    while true loop
      case d is
        when "111100000" => d <= "000000000";
        when "111100001" => d <= (others => '0');
        when others      => null;
      end case;
    end loop;
    
  end process p;
  
end architecture rtl;

