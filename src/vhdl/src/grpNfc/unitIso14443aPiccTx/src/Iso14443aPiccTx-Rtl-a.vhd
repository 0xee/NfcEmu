
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library global;
use global.Global.all;

library nfc;
use nfc.Nfc.all;

library misc;

architecture Rtl of Iso14443aPiccTx is

  constant cSubcarrierFreq : natural := 13560e3/16;

  constant cSubcarrierPeriod : natural := gClkFrequency/cSubcarrierFreq;
  constant cPeriodsPerBit    : natural := 8;

  type aState is (Idle, Sof, Data, Eof);

  type aRegSet is record
    State         : aState;
    TxData        : std_ulogic_vector(8 downto 0);
    NextData      : std_ulogic_vector(7 downto 0);
    ShortFrame    : std_ulogic;
    NextDataValid : std_ulogic;
    BitCounter    : natural range 0 to 8;
    PeriodCounter : natural range 0 to cPeriodsPerBit-1;
    Subcarrier    : std_ulogic;
  end record;

  constant cRegInitVal : aRegSet := (
    State         => Idle,
    TxData        => (others => '0'),
    NextData      => (others => '0'),
    ShortFrame    => '0',
    NextDataValid => '0',
    BitCounter    => 0,
    PeriodCounter => 0,
    Subcarrier    => '0'
    );

  signal R, NextR : aRegSet;

  signal sSubCarrierStrobe, sSubCarrierToggle : std_ulogic;
  signal sTx, sFirstHalfOfBit, sOutputEnable  : std_ulogic;

  function OddParity(constant byte : std_ulogic_vector(7 downto 0)) return std_ulogic is
    variable vOdd : std_ulogic := '1';
  begin
    for i in 0 to 7 loop
      vOdd := vOdd xor byte(i);
    end loop;
    return vOdd;
  end;

  signal sScReset : std_ulogic;
  
begin  -- Rtl

  sSubCarrierStrobe <= sSubCarrierToggle and R.Subcarrier;

  sFirstHalfOfBit <= '1' when R.PeriodCounter < cPeriodsPerBit/2 else
                     '0';
  
  sTx <= R.Subcarrier when sFirstHalfOfBit = R.TxData(0) else
         '0';

  oLoadSwitch <= sOutputEnable and sTx;

  sOutputEnable <= '1' when R.State = Sof or R.State = Data else
                   '0';
  
  Comb : process (R, iTxData, sSubCarrierToggle, sSubCarrierStrobe, iTxBits, iShortFrame)
  begin  -- process
    NextR    <= R;
    oAck     <= '0';
    oIdle    <= '0';
    sScReset <= '0';
    if sSubCarrierToggle = '1' then
      NextR.Subcarrier <= not R.Subcarrier;
      if R.Subcarrier = '1' and R.PeriodCounter /= cPeriodsPerBit-1 then
        NextR.PeriodCounter <= R.PeriodCounter + 1;
      end if;
    end if;

    if R.NextDataValid = '0' and iTxData.Valid = '1' then
      NextR.NextDataValid <= '1';
      NextR.NextData      <= iTxData.Data;
      NextR.ShortFrame    <= iShortFrame;
      oAck                <= '1';
    end if;


    case R.State is
      when Idle =>
        if R.NextDataValid or iTxData.Valid then
          NextR.Subcarrier    <= '0';
          sScReset            <= '1';
          NextR.PeriodCounter <= 0;
          NextR.State         <= Sof;
          NextR.TxData        <= (others => '1');  -- sof is a '1' bit
        end if;

      when Sof =>
        if sSubCarrierStrobe then
          if R.PeriodCounter = cPeriodsPerBit-1 then
            NextR.TxData        <= OddParity(R.NextData) & R.NextData;
            NextR.NextDataValid <= '0';
            NextR.State         <= Data;
            NextR.PeriodCounter <= 0;
            NextR.BitCounter    <= 0;
          end if;
        end if;
        
      when Data =>

        if sSubCarrierStrobe = '1' and R.PeriodCounter = cPeriodsPerBit-1 then
          NextR.PeriodCounter <= 0;

          if R.BitCounter = 8 or
            (R.ShortFrame = '1' and R.BitCounter = 3) then
            if R.NextDataValid = '1' then
              NextR.NextDataValid <= '0';
              NextR.BitCounter    <= 0;
              NextR.TxData        <= OddParity(R.NextData) & R.NextData;
            else
              NextR.State <= Eof;
            end if;
          else
            NextR.TxData     <= '0' & R.TxData(8 downto 1);
            NextR.BitCounter <= R.BitCounter + 1;
          end if;
        end if;
        

        
      when Eof =>
        if sSubCarrierStrobe = '1' and R.PeriodCounter = cPeriodsPerBit-1 then
          NextR.NextDataValid <= '0';
          NextR.State         <= Idle;
          NextR.PeriodCounter <= 0;
          NextR.BitCounter    <= 0;
        end if;
        

      when others => null;
    end case;

end process;


Reg : process (iClk, inResetAsync)
begin  -- process
  if inResetAsync = '0' then            -- asynchronous reset (active low)
    R <= cRegInitVal;
  elsif iClk'event and iClk = '1' then  -- rising clock edge
    R <= NextR;
  end if;
end process;


SubcarrierStrobeGen : entity misc.StrobeGen
  generic map (
    gClkFreq    => gClkFrequency,
    gStrobeFreq => 2*cSubcarrierFreq)
  port map (
    iClk         => iClk,
    inResetAsync => inResetAsync,
    iEnable      => '1',
    iSyncReset   => sScReset,
    oStrobe      => sSubCarrierToggle);


end Rtl;
