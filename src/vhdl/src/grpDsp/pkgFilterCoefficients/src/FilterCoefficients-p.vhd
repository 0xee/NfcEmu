library ieee;
use ieee.math_real.all;
use ieee.numeric_std.all;

package FilterCoefficients is

  type aCoeffArray is array (natural range <>) of real;

  function CalcBandpassCoeffs (
    constant fpass : real;
    constant bw    : real;
    constant order : natural)
    return aCoeffArray;

  function WindowedSincCoeff (
    constant cN         : integer;
    constant cI         : integer;
    constant cFpass     : real;
    constant cBandwidth : real)
    return real;

  function Quantize (
    constant coeff : real;
    constant bits  : natural)
    return signed;
  
  constant cInputDecimatorOrder     : natural := 30;  -- choose 2^n - 2 for best fmax
  constant cInputDecimatorFpass     : real    := 0.0;
  constant cInputDecimatorBandwidth : real    := 1.0/6.0;
  constant cInputDecimatorCoeffs    : aCoeffArray;

end FilterCoefficients;


package body FilterCoefficients is


  function CalcBandpassCoeffs (
    constant fpass : real;
    constant bw    : real;
    constant order : natural)
    return aCoeffArray is
    variable coeffs : aCoeffArray(0 to order);
  begin
    
    for i in 0 to order loop
      coeffs(i) := WindowedSincCoeff(order+1, i-order/2, fpass, bw);
    end loop;  -- i
    -- 
    return coeffs;
  end;

  function WindowedSincCoeff (
    constant cN         : integer;
    constant cI         : integer;
    constant cFpass     : real;
    constant cBandwidth : real)
    return real is
    variable vSinc   : real;
    variable vWindow : real;
  begin
    if cI = 0 then
      return 1.0;
    end if;
    -- calculate sinc lowpass coefficients
    vSinc   := sin(MATH_2_PI*cBandwidth*real(cI)) / (real(cI) * MATH_2_PI * cBandwidth);
    -- shift spectrum to fpass
    vSinc   := vSinc * cos(MATH_2_PI*cFpass*real(cI)); 
    vWindow := 1.0;
    -- hamming window
     vWindow := 0.54 + 0.46 * cos(2.0*MATH_PI*real(cI) / real(cN));

    -- blackman window
    --vWindow := 0.42 -
    --           0.5 * cos(2.0*MATH_PI*real(cI+cN/2) / real(cN)) +
    --           0.08 * cos(4.0*MATH_PI*real(cI+cN/2)/real(cN));

    return vSinc * vWindow;
    
  end;
  
  function Quantize (
    constant coeff : real;
    constant bits  : natural)
    return signed is
    constant cLSB     : real := 2.0**(-integer(bits)-1);
    variable vClipped : real := 1.0-cLSB;
    variable vQuant   : signed(bits-1 downto 0);
  begin
    
    if coeff > vClipped then
      vQuant := to_signed(integer(2**(bits-1)-1), bits);
    else
      vClipped := coeff;
      if vClipped < -1.0 then
        vClipped := -1.0;
      end if;
      vQuant := to_signed(integer((vClipped) * real(2**(bits-1))), bits);
    end if;
--    report "Quantized " & real'image(coeff) & " to " & integer'image(to_integer(vQuant));
    return vQuant;
  end;
  
  
  constant cInputDecimatorCoeffs : aCoeffArray := CalcBandpassCoeffs(cInputDecimatorFpass,
                                                                     cInputDecimatorBandwidth,
                                                                     cInputDecimatorOrder);

end FilterCoefficients;
