onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {dbg uart} /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/UartTx_1/oTx
add wave -noupdate -expand -group {dbg uart} -childformat {{/tbnfcemu/NfcEmu_1/Iso14443aPicc_1/UartTx_1/R.BaudCounter -radix hexadecimal} {/tbnfcemu/NfcEmu_1/Iso14443aPicc_1/UartTx_1/R.TxData -radix hexadecimal} {/tbnfcemu/NfcEmu_1/Iso14443aPicc_1/UartTx_1/R.BitCounter -radix hexadecimal}} -subitemconfig {/tbnfcemu/NfcEmu_1/Iso14443aPicc_1/UartTx_1/R.BaudCounter {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/UartTx_1/R.TxData {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/UartTx_1/R.BitCounter {-height 16 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/UartTx_1/R
add wave -noupdate -expand -group {dbg uart} -childformat {{/tbnfcemu/NfcEmu_1/Iso14443aPicc_1/UartTx_1/iDin.Id -radix hexadecimal} {/tbnfcemu/NfcEmu_1/Iso14443aPicc_1/UartTx_1/iDin.Data -radix hexadecimal}} -subitemconfig {/tbnfcemu/NfcEmu_1/Iso14443aPicc_1/UartTx_1/iDin.Id {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/UartTx_1/iDin.Data {-height 16 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/UartTx_1/iDin
add wave -noupdate -expand -group {dbg uart} /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/UartTx_1/oAckIn
add wave -noupdate /tbnfcemu/NfcEmu_1/iClk
add wave -noupdate /tbnfcemu/NfcEmu_1/inResetAsync
add wave -noupdate /tbnfcemu/sWdtReset
add wave -noupdate -radix hexadecimal -childformat {{/tbnfcemu/sDin.DPort -radix hexadecimal -childformat {{/tbnfcemu/sDin.DPort.Id -radix hexadecimal} {/tbnfcemu/sDin.DPort.Data -radix hexadecimal} {/tbnfcemu/sDin.DPort.Valid -radix hexadecimal} {/tbnfcemu/sDin.DPort.Eof -radix hexadecimal} {/tbnfcemu/sDin.DPort.error -radix hexadecimal}}} {/tbnfcemu/sDin.Ack -radix hexadecimal}} -subitemconfig {/tbnfcemu/sDin.DPort {-height 16 -radix hexadecimal -childformat {{/tbnfcemu/sDin.DPort.Id -radix hexadecimal} {/tbnfcemu/sDin.DPort.Data -radix hexadecimal} {/tbnfcemu/sDin.DPort.Valid -radix hexadecimal} {/tbnfcemu/sDin.DPort.Eof -radix hexadecimal} {/tbnfcemu/sDin.DPort.error -radix hexadecimal}} -expand} /tbnfcemu/sDin.DPort.Id {-height 16 -radix hexadecimal} /tbnfcemu/sDin.DPort.Data {-height 16 -radix hexadecimal} /tbnfcemu/sDin.DPort.Valid {-height 16 -radix hexadecimal} /tbnfcemu/sDin.DPort.Eof {-height 16 -radix hexadecimal} /tbnfcemu/sDin.DPort.error {-height 16 -radix hexadecimal} /tbnfcemu/sDin.Ack {-height 16 -radix hexadecimal}} /tbnfcemu/sDin
add wave -noupdate /tbnfcemu/NfcEmu_1/oAckIn
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/oDout.Id -radix hexadecimal} {/tbnfcemu/NfcEmu_1/oDout.Data -radix hexadecimal}} -subitemconfig {/tbnfcemu/NfcEmu_1/oDout.Id {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/oDout.Data {-height 16 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/oDout
add wave -noupdate /tbnfcemu/NfcEmu_1/iAckOut
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/rFwValid
add wave -noupdate /tbnfcemu/NfcEmu_1/PacketMux_1/R
add wave -noupdate /tbnfcemu/NfcEmu_1/PacketMux_1/sAckIn
add wave -noupdate -format Analog-Step -height 84 -max 231.0 -radix unsigned /tbnfcemu/NfcEmu_1/iEnvelope
add wave -noupdate /tbnfcemu/NfcEmu_1/iEnvelopeValid
add wave -noupdate -radix unsigned /tbnfcemu/NfcEmu_1/oSDacAVal
add wave -noupdate -radix unsigned /tbnfcemu/NfcEmu_1/oSDacBVal
add wave -noupdate /tbnfcemu/NfcEmu_1/oSDacUpdate
add wave -noupdate /tbnfcemu/NfcEmu_1/oSDacEnableCD
add wave -noupdate /tbnfcemu/NfcEmu_1/iSDacAck
add wave -noupdate /tbnfcemu/NfcEmu_1/oNfcLoadSwitch
add wave -noupdate /tbnfcemu/NfcEmu_1/sTestData
add wave -noupdate /tbnfcemu/NfcEmu_1/sNfcFieldDig
add wave -noupdate /tbnfcemu/NfcEmu_1/sNfcFieldSteady
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/sCfgVec
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/sStatusVec
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/sCfg.Enable -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.Flags -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.SDacA -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.SDacB -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.SDacC -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.SDacD -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.FieldTh -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.ScThreshold -radix hexadecimal} {/tbnfcemu/NfcEmu_1/sCfg.Uid -radix hexadecimal}} -expand -subitemconfig {/tbnfcemu/NfcEmu_1/sCfg.Enable {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.Flags {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.SDacA {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.SDacB {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.SDacC {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.SDacD {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.FieldTh {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.ScThreshold {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/sCfg.Uid {-height 16 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/sCfg
add wave -noupdate /tbnfcemu/NfcEmu_1/sCfgValid
add wave -noupdate /tbnfcemu/NfcEmu_1/sUpdateCfg
add wave -noupdate /tbnfcemu/NfcEmu_1/sEnableAcq
add wave -noupdate /tbnfcemu/NfcEmu_1/sToHost
add wave -noupdate /tbnfcemu/NfcEmu_1/sHostAck
add wave -noupdate /tbnfcemu/NfcEmu_1/sStreamData
add wave -noupdate /tbnfcemu/NfcEmu_1/sLayer4Rx
add wave -noupdate /tbnfcemu/NfcEmu_1/sLayer4Tx
add wave -noupdate /tbnfcemu/NfcEmu_1/sFromHost
add wave -noupdate /tbnfcemu/NfcEmu_1/sPiccALayer4Selected
add wave -noupdate /tbnfcemu/NfcEmu_1/sPiccARxShortFrame
add wave -noupdate /tbnfcemu/NfcEmu_1/sIsoLayer4TxShortFrame
add wave -noupdate /tbnfcemu/NfcEmu_1/sPiccATxShortframe
add wave -noupdate /tbnfcemu/NfcEmu_1/sPiccATxLoadSwitch
add wave -noupdate /tbnfcemu/NfcEmu_1/sStreamIn
add wave -noupdate /tbnfcemu/NfcEmu_1/sStreamValid
add wave -noupdate -group ToHost /tbnfcemu/NfcEmu_1/sPiccATxToHost
add wave -noupdate -group ToHost /tbnfcemu/NfcEmu_1/sPiccARxToHost
add wave -noupdate -group ToHost /tbnfcemu/NfcEmu_1/sPiccALogicToHost
add wave -noupdate -group ToHost /tbnfcemu/NfcEmu_1/sPcdARxToHost
add wave -noupdate -group ToHost /tbnfcemu/NfcEmu_1/sControlToHost
add wave -noupdate -group ToHost -subitemconfig {/tbnfcemu/NfcEmu_1/sCpuToHost.DPort -expand} /tbnfcemu/NfcEmu_1/sCpuToHost
add wave -noupdate -group HostTo* -radix hexadecimal /tbnfcemu/NfcEmu_1/sHostToControl
add wave -noupdate -group HostTo* -radix hexadecimal /tbnfcemu/NfcEmu_1/sHostToCpu
add wave -noupdate -group HostTo* -radix hexadecimal /tbnfcemu/NfcEmu_1/sHostToCpuFw
add wave -noupdate -group HostTo* -radix hexadecimal /tbnfcemu/NfcEmu_1/sHostToLayer4
add wave -noupdate -group HostTo* -radix hexadecimal /tbnfcemu/NfcEmu_1/sHostToPcdA
add wave -noupdate -group HostTo* -radix hexadecimal /tbnfcemu/NfcEmu_1/sHostToPiccA
add wave -noupdate -group CPU -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/iOutputAck
add wave -noupdate -group CPU -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/oInputAck
add wave -noupdate -group CPU -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/oOutputPorts
add wave -noupdate -group CPU -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sRomAdr
add wave -noupdate -group CPU -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sRomData
add wave -noupdate -group CPU -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/snCpuReset
add wave -noupdate -group CPU -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbAck
add wave -noupdate -group CPU -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbAdr
add wave -noupdate -group CPU -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbDin
add wave -noupdate -group CPU -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbDout
add wave -noupdate -group CPU -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbRdStb
add wave -noupdate -group CPU -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbWrStb
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/iEnable
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/iNfcFieldActive
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/iNfcFieldValid
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/inResetAsync
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/oBitGridIndex
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/oCyclesToBitStart
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/oRxData
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/oRxShortFrame
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/rBitCount
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/rBitGridIndex
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/rByteOut
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/rCyclesToBitStart
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/rEofOut
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/rValidOut
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/sMiller
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/sMillerValid
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/sRxBit
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/sRxData
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/sRxEof
add wave -noupdate -expand -group PiccRx /tbnfcemu/NfcEmu_1/Iso14443aPicc_1/Iso14443aPiccRx_1/sRxValid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {227832088 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 458
configure wave -valuecolwidth 100
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
WaveRestoreZoom {4793471760 ps} {5417150733 ps}
