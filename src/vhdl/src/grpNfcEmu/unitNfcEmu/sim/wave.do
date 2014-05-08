onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbnfcemu/ROM52_1/A
add wave -noupdate /tbnfcemu/ROM52_1/Clk
add wave -noupdate /tbnfcemu/ROM52_1/D
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/rFwInAdr
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/rFwValid
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/snCpuReset
add wave -noupdate /tbnfcemu/iClk
add wave -noupdate /tbnfcemu/inResetAsync
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbAck
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbAdr
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbDin
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbDout
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbRdStb
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbWrStb
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/sP0Out
add wave -noupdate -expand /tbnfcemu/NfcEmu_1/Iso14443aPiccLogic_1/iLayer4TxData
add wave -noupdate -expand /tbnfcemu/NfcEmu_1/Iso14443aPiccLogic_1/oTxData
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443aPiccLogic_1/iTxAck
add wave -noupdate -format Analog-Step -height 84 -max 231.0 -radix unsigned /tbnfcemu/NfcEmu_1/iEnvelope
add wave -noupdate -format Analog-Step -height 84 -max 670.0 -min -667.0 -radix decimal /tbnfcemu/NfcEmu_1/Iso14443aPcdRx_1/sMatched
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/sCfg.Mode -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.SDacA -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.SDacB -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.SDacC -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.SDacD -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.MillerTh -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.ScThreshold -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.Uid -radix hexadecimal}} -expand -subitemconfig {/tbnfcemu/NfcEmu_1/sCfg.Mode {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.SDacA {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.SDacB {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.SDacC {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.SDacD {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.MillerTh {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.ScThreshold {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.Uid {-height 15 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/sCfg
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/HostInterface_1/R.CfgBuffer -radix hexadecimal}} -expand -subitemconfig {/tbnfcemu/NfcEmu_1/HostInterface_1/R.CfgBuffer {-height 15 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/HostInterface_1/R
add wave -noupdate /tbnfcemu/NfcEmu_1/HostInterface_1/iUpdateAck
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sP0Out
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/Iso14443_4_1/iHostIn.Id -radix hexadecimal} {/tbnfcemu/NfcEmu_1/Iso14443_4_1/iHostIn.Data -radix hexadecimal}} -expand -subitemconfig {/tbnfcemu/NfcEmu_1/Iso14443_4_1/iHostIn.Id {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/Iso14443_4_1/iHostIn.Data {-height 15 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/Iso14443_4_1/iHostIn
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443_4_1/oHostAck
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/Iso14443_4_1/oHostOut.Id -radix hexadecimal} {/tbnfcemu/NfcEmu_1/Iso14443_4_1/oHostOut.Data -radix hexadecimal}} -expand -subitemconfig {/tbnfcemu/NfcEmu_1/Iso14443_4_1/oHostOut.Id {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/Iso14443_4_1/oHostOut.Data {-height 15 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/Iso14443_4_1/oHostOut
add wave -noupdate -radix unsigned /tbnfcemu/NfcEmu_1/Iso14443aPiccRx_1/oCyclesToBitStart
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443aPiccRx_1/iNfcFieldActive
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443aPiccRx_1/iNfcFieldValid
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443aPiccRx_1/MillerDec_1/R
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/Iso14443aPiccRx_1/FrameDecoder_1/R.RxData -radix hexadecimal} {/tbnfcemu/NfcEmu_1/Iso14443aPiccRx_1/FrameDecoder_1/R.RxByte -radix hexadecimal}} -subitemconfig {/tbnfcemu/NfcEmu_1/Iso14443aPiccRx_1/FrameDecoder_1/R.RxData {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/Iso14443aPiccRx_1/FrameDecoder_1/R.RxByte {-height 15 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/Iso14443aPiccRx_1/FrameDecoder_1/R
add wave -noupdate -format Analog-Step -height 84 -max 2971.0 -radix decimal /tbnfcemu/NfcEmu_1/Iso14443aPcdRx_1/sScDemod
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443aPcdRx_1/sManchester
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443aPcdRx_1/ManchesterDecoder_1/R
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/Iso14443aPcdRx_1/FrameDecoder_1/R.RxData -radix hexadecimal} {/tbnfcemu/NfcEmu_1/Iso14443aPcdRx_1/FrameDecoder_1/R.RxByte -radix hexadecimal}} -subitemconfig {/tbnfcemu/NfcEmu_1/Iso14443aPcdRx_1/FrameDecoder_1/R.RxData {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/Iso14443aPcdRx_1/FrameDecoder_1/R.RxByte {-height 15 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/Iso14443aPcdRx_1/FrameDecoder_1/R
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/sPcdARxData.Data -radix hexadecimal}} -subitemconfig {/tbnfcemu/NfcEmu_1/sPcdARxData.Data {-height 15 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/sPcdARxData
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/sPiccARxData.Id -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sPiccARxData.Data -radix hexadecimal}} -subitemconfig {/tbnfcemu/NfcEmu_1/sPiccARxData.Id {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sPiccARxData.Data {-height 15 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/sPiccARxData
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/sPiccALogicData.Id -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sPiccALogicData.Data -radix hexadecimal}} -subitemconfig {/tbnfcemu/NfcEmu_1/sPiccALogicData.Id {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sPiccALogicData.Data {-height 15 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/sPiccALogicData
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/sPiccATxData.Id -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sPiccATxData.Data -radix hexadecimal}} -subitemconfig {/tbnfcemu/NfcEmu_1/sPiccATxData.Id {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sPiccATxData.Data {-height 15 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/sPiccATxData
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443aPiccLogic_1/iTxAck
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443aPiccLogic_1/R
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/Iso14443aPiccTx_1/R.TxData -radix hexadecimal} {/tbnfcemu/NfcEmu_1/Iso14443aPiccTx_1/R.NextData -radix hexadecimal}} -subitemconfig {/tbnfcemu/NfcEmu_1/Iso14443aPiccTx_1/R.TxData {-height 15 -radix hexadecimal} /tbnfcemu/NfcEmu_1/Iso14443aPiccTx_1/R.NextData {-height 15 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/Iso14443aPiccTx_1/R
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443aPiccLogic_1/CrcA_1/iDin
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443aPiccLogic_1/CrcA_1/iSyncReset
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443aPiccLogic_1/CrcA_1/iValid
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443aPiccLogic_1/CrcA_1/rCrcReg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1500485292 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 149
configure wave -valuecolwidth 140
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {12494859300 ps}
