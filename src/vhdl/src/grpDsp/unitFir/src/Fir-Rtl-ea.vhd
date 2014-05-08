library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library dsp;
use dsp.FilterCoefficients.all;

library global;
use global.Global.all;

entity Fir is
  
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

end Fir;


architecture Rtl of Fir is

  constant cInWidth  : natural := iDin'length;
  constant cOutWidth : natural := oDout'length;
  constant cTaps     : natural := gCoeffs'length;
  constant cStages   : natural := LogDualis(cTaps)+1;

  constant cAccuWidth : natural := iDin'length + LogDualis(cTaps);

  type aQuantCoeffArray is array (0 to cTaps-1) of signed(cInWidth-1 downto 0);

  type aDelayPath is array (0 to cTaps-1) of signed(cInWidth-1 downto 0);

  type aPipelineStage is array (natural range 0 to 2*((cTaps+1)/2)-1) of signed(cAccuWidth-1 downto 0);
  type aPipelineReg is array (natural range 0 to cStages-1) of aPipelineStage;


  type aRegSet is record
    Z       : aDelayPath;
    RegTree : aPipelineReg;
  end record;

  signal R, NextR : aRegSet;

  constant cInitRegVal : aRegSet := (Z       => (others => (others => '0')),
                                     RegTree => (others => (others => (others => '0')))
                                     );

  function QuantizeCoeffs (
    constant cCoeffs : aCoeffArray;
    constant cBits   : natural)
    return aQuantCoeffArray is
    variable vQuantCoeffs : aQuantCoeffArray;
  begin
    for i in cCoeffs'range loop
      vQuantCoeffs(i) := Quantize(cCoeffs(i), cBits);
    end loop;  -- i
    return vQuantCoeffs;
  end;

  constant cQuantCoeffs : aQuantCoeffArray := QuantizeCoeffs(gCoeffs, iDin'length);
  
begin

  Comb : process (R, iDin, iValid)
    variable vProd : signed(2*cInWidth-1 downto 0);
  begin  -- process Comb

    NextR <= R;
    oValid <= '0';
    if iValid = '1' then
      oValid <= '1';

      NextR.z(1 to cTaps-1) <= R.z(0 to cTaps-2);
      NextR.z(0)            <= signed(iDin);

      -- multiplication
      for i in 0 to cTaps-1 loop
        vProd               := R.z(i) * cQuantCoeffs(i);
        NextR.RegTree(0)(i) <= resize(vProd(vProd'left downto vProd'left-cInWidth), cAccuWidth);
      end loop;  -- i

      -- 1st adder stage
      for stage in 1 to cStages-1 loop
        for i in 0 to (cTaps-1)/2 loop
          NextR.RegTree(stage)(i) <= R.RegTree(stage-1)(2*i) +
                                     R.RegTree(stage-1)(2*i+1);
        end loop;  -- i 

      end loop;
      
    end if;

  end process Comb;

  oDout <= std_ulogic_vector(R.RegTree(cStages-1)(0)(cAccuWidth-1 downto cAccuWidth-oDout'length));

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
