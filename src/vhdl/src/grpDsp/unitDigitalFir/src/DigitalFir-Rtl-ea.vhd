library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library dsp;
use dsp.FilterCoefficients.all;

library global;
use global.Global.all;

entity DigitalFir is
  
  generic (
    gCoeffs : aCoeffArray);

  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iEnable      : in  std_ulogic;
    iDin         : in  std_ulogic_vector;
    oDout        : out std_ulogic_vector;
    iValid       : in  std_ulogic;
    oValid       : out std_ulogic);

end DigitalFir;


architecture Rtl of DigitalFir is

  constant cInWidth  : natural := iDin'length;
  constant cOutWidth : natural := oDout'length;
  constant cTaps     : natural := gCoeffs'length;
  constant cStages   : natural := LogDualis(cTaps)+1;

  constant cAccuWidth : natural := cOutWidth;



  type aDelayPath is array (0 to cTaps-1) of signed(cInWidth-1 downto 0);

  type aPipelineStage is array (natural range 0 to 2*((cTaps+1)/2)-1) of signed(cAccuWidth-1 downto 0);
  type aPipelineReg is array (natural range 0 to cStages-1) of aPipelineStage;


  type aRegSet is record
    Z       : aDelayPath;
    Dout : std_ulogic_vector(oDout'range);
    ValidOut : std_ulogic;
  end record;

  signal R, NextR : aRegSet;

  constant cInitRegVal : aRegSet := (Z       => (others => (others => '0')),
                                     Dout => (others => '0'),
                                     ValidOut => '0'
                                     );

  function QuantizeCoeffs (
    constant cCoeffs : aCoeffArray)
    return std_ulogic_vector is
    variable vDigCoeffs : std_ulogic_vector(cCoeffs'range) := (others => '0');
  begin
    for i in cCoeffs'range loop
      if cCoeffs(i) > 0.0 then
        vDigCoeffs(i) := '1';
      end if;
    end loop;  -- i
    return vDigCoeffs;
  end;

  constant cDigCoeffs : std_ulogic_vector := QuantizeCoeffs(gCoeffs);
  
begin

  oValid <= R.ValidOut;
  oDout <= R.Dout;
  
  Comb : process (R, iDin, iValid)
    variable vProd : signed(cInWidth-1 downto 0);
    variable vSum  : signed(cAccuWidth-1 downto 0);
  begin  -- process Comb
    NextR  <= R;
    NextR.ValidOut <= '0';
    vSum   := (others => '0');
    if iValid = '1' then

      NextR.z(1 to cTaps-1) <= R.z(0 to cTaps-2);
      NextR.z(0)            <= signed(iDin);

      -- "multiplication"
      for i in 0 to cTaps-1 loop
        if cDigCoeffs(i) = '1' then
          vSum := vSum + R.z(i);
        else
          vSum := vSum + (not R.z(i));
        end if;
      end loop;  -- i
      NextR.Dout <= std_ulogic_vector(vSum);
      NextR.ValidOut <= '1';
      
    end if;
  end process Comb;


  Reg : process (iClk, inResetAsync)
  begin  -- process Reg
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      R <= cInitRegVal;
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      if iEnable = '1' then
        R <= NextR;
      end if;
    end if;
  end process Reg;

end Rtl;
