library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library nfc;
use nfc.Iso14443.all;

library misc;

-- reference results
--50 00 57 CD
--52 (short)
--- 04 00
--93 70 EC DC 03 89 BA 67 44

entity MillerDec is
  
  generic (
    gClkFrequency : natural := 50e6
    );
  port (
    iClk         : in  std_ulogic;
    inResetAsync : in  std_ulogic;
    iEnable      : in  std_ulogic;
    iMiller      : in  std_ulogic;
    iValid       : in  std_ulogic;
    oRxBit       : out std_ulogic;
    oValid       : out std_ulogic;
    oEof         : out std_ulogic
    );



end MillerDec;


architecture Rtl of MillerDec is

  -- all numbers are nfc cycles (13.56MHz periods), not Fclk cycles!
  -- positions of rising edge in bit period
  constant cEdgePosZero      : natural := 39;  -- iso14443-2 says 38-40.5
  constant cEdgePosOne       : natural := cEdgePosZero+cCyclesPerBit/2;
  constant cEdgePosThreshold : natural := (cEdgePosZero + cEdgePosOne) / 2;


  type aMillerState is (Idle, FirstBit, Frame);

  type aRegSet is record
    State               : aMillerState;
    CyclesSinceBitStart : natural range 0 to cCyclesPerBit-1;
    EdgeDetected        : std_ulogic;
    RxBit               : std_ulogic;
    RxValid             : std_ulogic;
    RxEof               : std_ulogic;
    CyclesSinceLastEdge : natural;
  end record;

  constant cRegInitVal : aRegSet := (State               => Idle,
                                     CyclesSinceBitStart => 0,
                                     EdgeDetected        => '0',
                                     RxBit               => '0',
                                     RxValid             => '0',
                                     RxEof               => '0',
                                     CyclesSinceLastEdge => 0
                                     );



  signal R, NextR    : aRegSet;
  signal sRisingEdge : std_ulogic;

begin  -- Rtl
  
  EdgeDetector_1 : entity misc.EdgeDetector(Rtl)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => iMiller,
      iValid       => iValid,
      oRising      => sRisingEdge,
      oFalling     => open);



  Comb : process (R, sRisingEdge, iValid)
  begin  -- process Comb
    NextR         <= R;
    NextR.RxValid <= '0';
    NextR.RxEof   <= '0';

    if iValid = '1' then
      NextR.CyclesSinceLastEdge <= R.CyclesSinceLastEdge + 1;
    end if;
    
    case R.State is
      when Idle =>
        if sRisingEdge = '1' then
          NextR.CyclesSinceBitStart <= cEdgePosZero;
          NextR.EdgeDetected        <= '1';
        end if;
        if iValid = '1' then
          if R.CyclesSinceBitStart = cCyclesPerBit-1 then
            NextR.CyclesSinceBitStart <= 0;
            NextR.EdgeDetected        <= '0';
            NextR.RxBit <= '0';
            NextR.State               <= FirstBit;
          elsif R.EdgeDetected = '1' then
            NextR.CyclesSinceBitStart <= R.CyclesSinceBitStart + 1;
          end if;
        end if;
        if R.CyclesSinceBitStart = cCyclesPerBit-1 then
        end if;

        when FirstBit => 
        if sRisingEdge = '1' then
          NextR.CyclesSinceLastEdge <= 0;
          NextR.EdgeDetected <= '1';
          if R.CyclesSinceBitStart < cEdgePosThreshold then
            NextR.RxBit   <= '0';
            NextR.RxValid <= '1';
          else
            NextR.RxBit   <= '1';
            NextR.RxValid <= '1';
          end if;
        end if;
        if iValid = '1' then
          if R.CyclesSinceBitStart = cCyclesPerBit-1 then
            NextR.CyclesSinceBitStart <= 0;
            NextR.EdgeDetected <= '0';
            if R.EdgeDetected = '0' then  -- no real frame, go back to idle
              NextR.State <= Idle;
            else
              NextR.State <= Frame;
            end if;
          else
            NextR.CyclesSinceBitStart <= R.CyclesSinceBitStart + 1;
          end if;
        end if;
        
      when Frame =>
        if sRisingEdge = '1' then
          NextR.CyclesSinceLastEdge <= 0;
          NextR.EdgeDetected <= '1';
          if R.CyclesSinceBitStart < cEdgePosThreshold then
            NextR.RxBit   <= '0';
            NextR.RxValid <= '1';
          else
            NextR.RxBit   <= '1';
            NextR.RxValid <= '1';
          end if;
        end if;
        if iValid = '1' then
          if R.CyclesSinceBitStart = cCyclesPerBit-1 then
            NextR.CyclesSinceBitStart <= 0;
            NextR.EdgeDetected <= '0';
            if R.EdgeDetected = '0' then
              if R.RxBit = '0' then
                NextR.RxEof <= '1';
                NextR.State <= Idle;
              else
                NextR.RxBit   <= '0';
                NextR.RxValid <= '1';
              end if;
            end if;
          else
            NextR.CyclesSinceBitStart <= R.CyclesSinceBitStart + 1;
          end if;
        end if;
      when others => null;
    end case;

  end process Comb;

  oEof   <= R.RxEof;
  oValid <= R.RxValid;
  oRxBit <= R.RxBit;


  Reg : process (iClk, inResetAsync)
  begin  -- process reg
    if inResetAsync = '0' then            -- asynchronous reset (active low)
      R <= cRegInitVal;
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      if iEnable = '1' then
        R <= NextR;
      end if;
    end if;
  end process Reg;

end Rtl;
