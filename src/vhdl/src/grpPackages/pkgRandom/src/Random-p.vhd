library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


package Random is

  type aRng is record
    Seed1       : positive;
    Seed2       : positive;
    Result      : natural;
    LogicResult : std_ulogic;
  end record aRng;


  function InitRng (constant seed : in natural) return aRng;

  procedure Rand (r             : inout aRng;
                  constant cMin : in    natural;
                  constant cMax : in    natural;
                  rnd           : out   natural);

  procedure Rand (r   : inout aRng;
                  rnd : inout std_ulogic_vector);

  procedure WaitRand (r             : inout aRng;
                      signal iClk   : in    std_ulogic;
                      constant cMax : in    natural);



end package Random;

package body Random is

  function InitRng (constant seed : in natural) return aRng is
    variable r : aRng;
  begin
    r.Seed1 := seed+1;
    r.Seed2 := 1;
    return r;
  end;

  procedure Rand (r             : inout aRng;
                  constant cMin : in    natural;
                  constant cMax : in    natural;
                  rnd           : out   natural) is
    variable vR             : real;
    variable vSeed1, vSeed2 : positive;
    variable vIntR : natural;
  begin
    vSeed1 := r.Seed1;
    vSeed2 := r.Seed2;
    vIntR    := cMax;
    while vIntR = cMax loop
      uniform(vSeed1, vSeed2, vR);
      vIntR := cMin + natural(real(cMax-cMin)*vR);
    end loop;
    rnd := vIntR;
  end;

  procedure Rand (r   : inout aRng;
                  rnd : inout std_ulogic_vector) is
    variable vR : natural range 0 to 2**rnd'length-1;
  begin
    Rand(r, 0, 2**rnd'length, vR);
    rnd := std_ulogic_vector(to_unsigned(vR, rnd'length));
  end;

  
  procedure RandLogic(r   : inout aRng;
                      rnd : out   std_ulogic) is
    variable vR : natural;
  begin
    rnd := '0';
    Rand(r, 0, 2, vR);
    if vR = 1 then
      rnd := '1';
    end if;
  end procedure;

  procedure WaitRand (r             : inout aRng;
                      signal iClk   : in    std_ulogic;
                      constant cMax : in    natural) is
    variable vDel : natural;
  begin
    Rand(r, 0, cMax, vDel);
--    report "waiting " & integer'image(vDel) & " cycles" severity note;
    for i in 0 to vDel loop
      wait until rising_edge(iClk);
    end loop;  -- i
    
  end;

  
end package body Random;
