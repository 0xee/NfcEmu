library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library global;
use global.Global.all;

library nfc;
use nfc.Nfc.all;

library nfcemu;
use nfcemu.NfcEmuPkg.all;

library fw;

library misc;

entity tbNfcEmu is

end tbNfcEmu;

architecture Bhv of tbNfcEmu is

  constant cClkPeriod : time := 1 sec / cNfcClkFreq;

  signal iClk         : std_ulogic := '1';
  signal inResetAsync : std_ulogic;

  signal sDin                     : aDataPortConnection;
  signal sSerialIn                : std_ulogic_vector(7 downto 0);
  signal sSerialValid, sSerialAck : std_ulogic;
  signal sRealDin                 : aDataPortConnection;
  signal sDout                     : aDataPortConnection;

  signal iEnvelope      : std_ulogic_vector(8 downto 0);
  signal iEnvelopeValid : std_ulogic;
  signal oDacOut        : std_ulogic_vector(9 downto 0);

  signal oSDacAVal      : std_ulogic_vector(7 downto 0);
  signal oSDacBVal      : std_ulogic_vector(7 downto 0);
  signal oSDacUpdate    : std_ulogic;
  signal oSDacEnableCD  : std_ulogic;
  signal iSDacAck       : std_ulogic;
  signal oNfcLoadSwitch : std_ulogic;

  signal sRomAdr  : std_logic_vector(11 downto 0);
  signal sRomData : std_logic_vector(7 downto 0);
  signal sRomClk  : std_ulogic;

  signal sEndOfSim : std_ulogic := '0';
  signal sWdtReset : std_ulogic := '0';

  constant cSnifferMode : boolean := false;
  
begin  -- Bhv

  SimCtrl_1 : entity misc.SimCtrl(Bhv)
    generic map (
      gClkFreq    => cNfcClkFreq,
      gWdtTimeout => 4 ms)
    port map (
      oClk      => iClk,
      onReset   => inResetAsync,
      iEndOfSim => sEndOfSim,
      iWdtReset => sWdtReset);

  

  NfcEmu_1 : entity nfcemu.NfcEmu(Rtl)
    port map (
      iClk           => iClk,
      inResetAsync   => inResetAsync,
      iDin           => sRealDin.DPort,
      oAckIn         => sRealDin.Ack,
      oDout          => sDout.DPort,
      iAckOut        => sDout.Ack,
      oDacOut        => oDacOut,
      iEnvelope      => iEnvelope,
      iEnvelopeValid => iEnvelopeValid,
      oSDacAVal      => oSDacAVal,
      oSDacBVal      => oSDacBVal,
      oSDacUpdate    => oSDacUpdate,
      oSDacEnableCD  => oSDacEnableCD,
      iSDacAck       => iSDacAck,
      oNfcLoadSwitch => oNfcLoadSwitch);

  PacketEncoder_1 : entity misc.PacketEncoder(Rtl)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sDin.DPort,
      oAckIn       => sDin.Ack,
      oDout        => sSerialIn,
      oEof         => open,
      oBusy        => open,
      iAckOut      => sSerialAck,
      oValid       => sSerialValid);


  PacketDecoder_1 : entity misc.PacketDecoder(Rtl)
    port map (
      iClk         => iClk,
      inResetAsync => inResetAsync,
      iDin         => sSerialIn,
      iValid       => sSerialValid,
      oAckIn       => sSerialAck,
      oDout        => sRealDin.DPort,
      iAckOut      => sRealDin.Ack);

  
  ROM52_1 : entity fw.ROM52(Rtl)
    port map (
      Clk => sRomClk,
      A   => sRomAdr,
      D   => sRomData);


  Stimuli : process
    procedure SendP(cPacket : std_ulogic_vector; cId : std_ulogic_vector) is
    begin
      SendPacket(sDin.DPort, sDin.Ack, iClk, cPacket, cId);
    end;
    procedure UpdateT51 is
      constant cRomSize   : natural := 2**12;
      constant cBlockSize : natural := 32;
      variable vBlock     : std_ulogic_vector(8*cBlockSize-1 downto 0);
      variable vRomAdr    : natural := 0;
    begin
      sRomClk <= '1';
      sRomAdr <= (others => '0');
      for b in 0 to cRomSize/cBlockSize-1 loop

        for i in 0 to cBlockSize-1 loop
          sRomClk                  <= '0';
          sRomAdr                  <= std_ulogic_vector(to_unsigned(vRomAdr, 12));
          vRomAdr                  := vRomAdr + 1;
          wait for 1 ps;
          sRomClk                  <= '1';
          wait for 1 ps;
          vBlock(8*i+7 downto 8*i) := sRomData;
        end loop;  -- i

        SendP(vBlock, cIdCpuFw);
        wait for 20*cClkPeriod;
      end loop;

      wait for 100 ns;
      SendP(cCmdRead, cIdCtrl);

      wait for 10 us;
      
    end;

    procedure InitNfcEmu is
      variable vCfg : aNfcEmuCfg := cInitCfg;
    begin
      InitPort(sDin.DPort);
      iSDacAck <= '0';

      iEnvelope <= (others => '0');
      wait for 200 ns;
      iSDacAck  <= '1';
      wait until rising_edge(iClk);
      iSDacAck  <= '0';

      wait for 200 ns;

      vCfg.Enable(cIso14443aPicc) := '1';
      if cSnifferMode then
        vCfg.Flags(cFlagRxOnly)    := '1';
        vCfg.Enable(cIso14443aPcd) := '1';
      end if;

      SendP(CfgToVector(vCfg) & cCmdWrite, cIdCtrl);

      wait for 100 ns;
      SendP(cCmdRead, cIdCtrl);

      wait until rising_edge(iClk);
      iSDacAck <= '1';
      wait until rising_edge(iClk);
      iSDacAck <= '0';
    end;


    procedure FeedAdcInput is

      file inputFile   : text;
      variable vInput  : integer;
      variable vLine   : line;
      constant cOffset : natural := 1;
      constant cLength : natural := 1e5;
    begin
      --Open the file in read mode.
      file_open(inputFile, "../data/stimuli.txt", read_mode);

      for i in 0 to cOffset loop
        readline(inputFile, vLine);     --read the current line.
      end loop;  -- i

      for i in 0 to cLength-1 loop
        
        readline(inputFile, vLine);     --read the current line.
        --extract the real value from the read line and store it in the variable.
        read(vLine, vInput);
        iEnvelopeValid <= '1';
        iEnvelope      <= std_ulogic_vector(to_unsigned(vInput, iEnvelope'length));
        wait until rising_edge(iClk);
        iEnvelopeValid <= '0';

        for i in 1 to cNfcClkFreq/cNfcFc - 1 loop
          wait until rising_edge(iClk);
        end loop;  -- i
        
      end loop;


      wait until rising_edge(iClk);
      report "end of input";
      file_close(inputFile);            --close the file after reading.

    end;


    variable vMsg : std_ulogic_vector(23 downto 0) := x"030201";
    constant cD   : natural                        := 400/8;

  begin  -- process Stimuli
    InitNfcEmu;

    report "updating t51";
    UpdateT51;
    report "success";

    
    wait for 200 us;
    SendP(x"00", cIdCpu);
    for i in 0 to 100 loop    
      SendP(FlipBytes(IntToVec(i, 16)), cIdCpu);
    end loop;  -- i


    report "Feeding adc input from file";
    FeedAdcInput;

    report "End of simulation";

    wait for 1 us;
    sEndOfSim <= '1';
    wait;
  end process Stimuli;


  CheckOutput : process
    variable vCfg                  :    aNfcEmuCfg                    := cInitCfg;
    constant cV                    :    std_ulogic_vector(7 downto 0) := x"a1";
    procedure Exp (constant Packet : in std_ulogic_vector) is
    begin
      ExpectPacket(sDout.DPort, iClk, Packet);
    end;
  begin  -- process Output
    sWdtReset                   <= not sWdtReset;
    vCfg.Enable(cIso14443aPicc) := '1';
    if cSnifferMode then
      vCfg.Flags(cFlagRxOnly)    := '1';
      vCfg.Enable(cIso14443aPcd) := '1';
    end if;
    --vCfg.Flags(cFlagCpuRunning) := '1';

    -- expect cfg readout packet  
    Exp(CfgToVector(vCfg));
    sWdtReset <= not sWdtReset;

    -- when cpu is configured
    vCfg.Flags(cFlagCpuRunning) := '1';
    Exp(CfgToVector(vCfg));
    sWdtReset                   <= not sWdtReset;

    Exp(x"08");                         -- t51 ready

    
    Exp(FlipBytes(x"0000"));             -- mode ack
        for i in 0 to 100 loop
          Exp(FlipBytes(IntToVec(i, 8)));
          Exp(FlipBytes(IntToVec(i, 16)));
    end loop;  -- i

--    Exp(FlipBytes(x"0A0B0C0D0E0F"));    -- echo test
--    Exp(FlipBytes(x"0001"));             -- mode ack
--    Exp(FlipBytes(x"0A0B0C0D0E0F"));    -- echo test

    report "end of init phase";
      
    if cSnifferMode then

      Exp(x"26");                       -- REQA
      Exp(FlipBytes(x"4400"));          -- ATQA

      sWdtReset <= not sWdtReset;

      Exp(FlipBytes(x"9320"));          --select 1
      Exp(FlipBytes(x"88058A2225"));    -- uid 1

      sWdtReset <= not sWdtReset;

      Exp(FlipBytes(x"937088058A2225047E"));  -- select 2
      Exp(FlipBytes(x"24D836"));        -- SAK

      Exp(FlipBytes(x"9520"));          -- select 3
      Exp(FlipBytes(x"2700000027"));    -- ???

      sWdtReset <= not sWdtReset;


    else
      -- expect picc power on
      Exp(IntToVec(cPiccPowerOn, 8));
      sWdtReset <= not sWdtReset;

      -- expect REQA
      Exp(x"26");

      -- expect ATQA
      Exp(FlipBytes(x"0400"));

      -- expect picc ready
      Exp(x"03");
      sWdtReset <= not sWdtReset;
      -- expect select 1
      Exp(FlipBytes(x"9320"));

      -- expect ac uid 1
      Exp(FlipBytes(x"0102030404"));
      sWdtReset <= not sWdtReset;
      -- expect select 2    
      Exp(FlipBytes(x"937088058A2225047E"));

      -- expect SAK
      Exp(FlipBytes(x"20FC7063"));
      -- expect picc selected
      Exp(FlipBytes(x"04"));

      -- expect select cl 2
      Exp(FlipBytes(x"9520"));
      sWdtReset <= not sWdtReset;
    end if;


    while true loop
      wait until rising_edge(iClk) and sDout.DPort.Valid = '1';
      report "ID: " & ToHex(sDout.DPort.Id) &" Data: " & ToHex(sDout.DPort.Data);
    end loop;
  end process CheckOutput;

  sDout.Ack <= sDout.DPort.Valid after 1 ns;

end Bhv;


