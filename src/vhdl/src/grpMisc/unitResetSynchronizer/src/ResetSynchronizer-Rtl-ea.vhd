library ieee;
use ieee.std_logic_1164.all;

entity ResetSynchronizer is
  
  port (
    iClk            : in  std_ulogic;
    inResetAsync    : in  std_ulogic;
    oSyncReset      : out std_ulogic);

end entity ResetSynchronizer;

architecture Rtl of ResetSynchronizer is
  signal reg0  : std_ulogic := '0';
  signal snRes : std_ulogic := '0';
begin  -- architecture Rtl

  Sync : process (iClk, inResetAsync) is
  begin  -- process Sync
    if inResetAsync = '0' then          -- asynchronous reset (active low)
      snRes <= '0';
      reg0  <= '0';
--      sResetWasActive <= '0';
    elsif iClk'event and iClk = '1' then  -- rising clock edge
      reg0  <= '1';
      snRes <= reg0;
        
    end if;
  end process Sync;

  oSyncReset <= snRes;
end architecture Rtl;
