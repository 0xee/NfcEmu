library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library dsp;

entity DcBlock is
  
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iDin         : in  std_ulogic_vector;
    oDout        : out std_ulogic_vector;
    iValid       : in  std_ulogic;
    oValid       : out std_ulogic);

end DcBlock;

architecture Rtl of DcBlock is

  constant cInWidth  : natural := iDin'length;
  constant cOutWidth : natural := oDout'length;
  constant cP        : signed  := '0' & x"A";

  type aRegSet is record
    D     : signed(cInWidth-1 downto 0);
    lastX : signed(iDin'range);
    Y     : signed(cOutWidth-1 downto 0);
  end record;

  signal R, NextR : aRegSet;

  constant cInitRegVal : aRegSet := (D     => (others => '0'),
                                     lastX => (others => '0'),
                                     Y     => (others => '0'));

  signal sX  : signed(iDin'range);
  signal sS1 : signed(R.Y'length + cP'length - 1 downto 0);
  signal sS2 : signed(R.D'range);
begin

  sX <= signed(iDin);


  sS1 <= shift_right(R.Y * cP, cP'length-1);
  sS2 <= resize(sS1, sS2'length);


  Comb : process (R, iDin, iValid, sS2, sX)
  begin  -- process Comb
    NextR       <= R;
    
    if iValid = '1' then      
      NextR.lastX <= sX;
      NextR.D     <= sX - R.lastX;

      NextR.Y <= R.D + sS2;
    end if;
    
  end process Comb;

  oDout  <= std_ulogic_vector(R.Y);
  oValid <= iValid;

  Reg : process (iClk, inResetAsync)
  begin  -- process Reg
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      R <= cInitRegVal;
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      R <= NextR;
    end if;
  end process Reg;

end Rtl;
