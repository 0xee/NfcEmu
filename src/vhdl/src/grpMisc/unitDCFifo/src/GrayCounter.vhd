----------------------------------------
-- Function    : Code Gray counter.
-- Coder       : Alex Claros F.
-- Date        : 15/May/2005.
-- Translator  : Alexander H Pham (VHDL)
----------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library global;
use global.Global.all;

entity GrayCounter is
  generic (
    COUNTER_WIDTH : integer := 4
    );
  port (                                --'Gray' code count output.
    GrayCount_out : out std_ulogic_vector (COUNTER_WIDTH-1 downto 0);
    Enable_in     : in  std_ulogic;     -- Count enable.
    Clear_in      : in  std_ulogic;     -- Count reset.
    clk           : in  std_ulogic      -- Input clock
    );
end entity;

architecture rtl of GrayCounter is
  signal BinaryCount : unsigned(COUNTER_WIDTH-1 downto 0);
begin
  process (clk)
  begin
    if (rising_edge(clk)) then
      if (Clear_in = '1') then
        --Gray count begins @ '1' with
        BinaryCount   <= to_unsigned(1, BinaryCount'length);
        GrayCount_out <= (others => '0');
      -- first 'Enable_in'.
      elsif (Enable_in = '1') then
        BinaryCount <= BinaryCount + 1;
        GrayCount_out <= std_ulogic_vector(BinaryCount(COUNTER_WIDTH-1) &
                                           (BinaryCount(COUNTER_WIDTH-2 downto 0) xor
                                            BinaryCount(COUNTER_WIDTH-1 downto 1)));
      end if;
    end if;
  end process;

end architecture;
