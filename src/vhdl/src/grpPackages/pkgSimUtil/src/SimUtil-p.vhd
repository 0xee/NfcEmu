-------------------------------------------------------------------------------
-- Title      : SimUtil
-- Project    : 
-------------------------------------------------------------------------------
-- File       : SimUtil-p.vhd
-- Author     : Lukas Schuller  <lukas@0xee.eu>
-- Company    : 
-- Created    : 2014-04-10
-- Last update: 2014-04-10
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Functions and constants for simulation 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-04-10  1.0      lukas	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library osvvm;
use osvvm.RandomPkg.all;

library global;
use global.Global.all;


package SimUtil is

  
  function Sum (constant iv : in integer_vector) return integer;

  procedure WaitRandom (
    signal iClk         :       std_ulogic;
    variable rv         : inout RandomPType;
    constant cMaxCycles : in    natural);

end package SimUtil;


package body SimUtil is
  
    procedure WaitRandom (
    signal iClk         :       std_ulogic;
    variable rv         : inout RandomPType;
    constant cMaxCycles : in    natural) is
    variable vDel : natural;
  begin
    vDel := rv.RandInt(0, cMaxCycles);
    wait for vDel*10 ns;
--    for i in 0 to vDel-1 loop
    wait until rising_edge(iClk);
--    end loop;  -- i
  end procedure WaitRandom;

      function Sum (constant iv : in integer_vector) return integer is
    variable vSum : integer := 0;
  begin
    for i in iv'range loop
      vSum := vSum + iv(i);
    end loop;  -- i
    return vSum;
  end function Sum;


end package body SimUtil;
