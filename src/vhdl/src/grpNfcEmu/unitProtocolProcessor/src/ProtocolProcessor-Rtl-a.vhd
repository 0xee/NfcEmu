-------------------------------------------------------------------------------
-- Title      : ProtocolProcessor
-- Project    : 
-------------------------------------------------------------------------------
-- File       : ProtocolProcessor-Rtl-a.vhd
-- Author     : Lukas Schuller  <l.schuller@gmail.com>
-- Company    : 
-- Created    : 2013-09-22
-- Last update: 2014-05-09
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-09-22  1.0      lukas   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;

library misc;
library nfcemu;
library fw;

architecture Rtl of ProtocolProcessor is

  constant cRomWidth   : natural := 12;
  constant cXRamWidth  : natural := 11;
  constant cIfBase     : natural := 2**cXRamWidth;
  constant cBufferSize : natural := 256;

  --wishbone signals
  signal sWbDout, sWbDin            : std_ulogic_vector(7 downto 0);
  signal sWbAdr                     : std_ulogic_vector(15 downto 0);
  signal sWbWrStb, sWbRdStb, sWbAck : std_ulogic;

  signal sP0Out, sP0In     : std_ulogic_vector(7 downto 0);
  attribute keep           : boolean;
  attribute keep of sP0Out : signal is true;
  signal sRomAdr           : std_ulogic_vector(cRomWidth-1 downto 0);
  signal sRomData          : std_ulogic_vector(7 downto 0);

  signal rFwInAdr    : unsigned(cRomWidth-1 downto 0);
  signal rFwValid    : std_ulogic;
  signal snCpuReset  : std_ulogic;
  signal rResetCount : natural range 0 to 7;
  signal rWaitForAck : std_ulogic;

  signal sFwAck : std_ulogic;

  component ROM52 is
    port (
      Clk : in  std_ulogic;
      A   : in  std_ulogic_vector(11 downto 0);
      D   : out std_ulogic_vector(7 downto 0));
  end component ROM52;

  signal sOutputPorts : aDataPortArray(oOutputPorts'range);

  constant cEnableFwUpdate : boolean := true;
  
begin  -- architecture Rtl

  oP0   <= sP0Out;
  sP0In <= sP0Out;

  oOutputPorts <= sOutputPorts;

  T51Wrapper_1 : entity nfcemu.T51Wrapper(Struct)
    generic map (
      gRomWidth  => cRomWidth,
      gXRamWidth => cXRamWidth)
    port map (
      iClk         => iClk,
      inResetAsync => snCpuReset,
      iP0          => sP0In,
      oP0          => sP0Out,
      oWbRdStb     => sWbRdStb,
      oWbWrStb     => sWbWrStb,
      iWbAck       => sWbAck,
      oWbDout      => sWbDout,
      oWbAdr       => sWbAdr,
      iWbDin       => sWbDin,
      oRomAdr      => sRomAdr,
      iRomData     => sRomData);

  T51Interface_1 : entity nfcemu.T51Interface(Rtl)
    generic map (
      gNrPorts     => gNrPorts,
      gBufferSize  => cBufferSize,
      gBaseAdr     => cIfBase,
      gWbAdrWidth  => 16,
      gWbDataWidth => 8)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iInputPorts  => iInputPorts,
      oInputAck    => oInputAck,
      oOutputPorts => sOutputPorts,
      iOutputAck   => iOutputAck,
      iWbAdr       => sWbAdr,
      iWbData      => sWbDout,
      oWbData      => sWbDin,
      iWbWrStb     => sWbWrStb,
      iWbRdStb     => sWbRdStb,
      oWbAck       => sWbAck);

  --FwRom : if cEnableFwUpdate = false generate
  --  ROM52_1 : entity fw.rom52(Rtl)
  --    port map (
  --      Clk => iClk,
  --      A   => sRomAdr,
  --      D   => sRomData);

  --  snCpuReset <= inResetAsync;
  --end generate FwRom;

  oCpuRunning <= snCpuReset;

  FwRam : if cEnableFwUpdate generate
    
    FwRam_1 : entity misc.FwRam
      generic map (
        gWidth => cRomWidth)
      port map (
        iClk   => iClk,
        iWrStb => iFwIn.Valid,
        iWrAdr => std_ulogic_vector(rFwInAdr),
        iData  => iFwIn.Data,
        iRdAdr => sRomAdr,
        oData  => sRomData);

    snCpuReset <= rFwValid when rResetCount = 7 else
                  '0';

    FwUpdate : process (iClk, inResetAsync) is
    begin  -- process FwUpdate
      if inResetAsync = '0' then        -- asynchronous reset (active low)
        rFwValid    <= '0';
        rFwInAdr    <= (others => '0');
        rResetCount <= 0;
        rWaitForAck <= '0';
      elsif rising_edge(iClk) then      -- rising clock edge
        
        if iFwIn.Valid = '1' then
          --  if rWaitForAck = '1' then
          --    if iOutputAck(0) = '1' then
          --      rWaitForAck     <= '0';
          --      oOutputPorts(0) <= cEmptyPort;
          --    end if;
          --  else
          --    if rFwInAdr(6 downto 0) = "1111111" then
          --      oOutputPorts(0).Data  <= std_ulogic_vector(rFwInAdr(rFwInAdr'left downto rFwInAdr'left-7));
          --      oOutputPorts(0).Id    <= x"02";
          --      oOutputPorts(0).Valid <= '1';
          --      oOutputPorts(0).Eof   <= '1';
          --      rWaitForAck           <= '1';
          --    end if;

          rFwValid    <= '0';
          rResetCount <= 0;
          if rFwInAdr = to_unsigned(2**cRomWidth-1, rFwInAdr'length) then
            rFwValid <= '1';
          end if;
        --end if;
      --else
      --  oOutputPorts(0) <= cEmptyPort;
      end if;

      if sFwAck = '1' then
        rFwInAdr <= rFwInAdr + 1;
      end if;

      -- take the cpu out of reset 8 cycles after fw update TODO: why?
      if rFwValid = '1' and rResetCount < 7 then
        rResetCount <= rResetCount + 1;
      end if;
      
    end if;
  end process FwUpdate;

end generate FwRam;

sFwAck <= iFwIn.Valid;  -- and (iOutputAck(0) or not rWaitForAck);

oFwAck <= sFwAck;

end architecture Rtl;
