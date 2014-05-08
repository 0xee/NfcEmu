onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbnfcemu/NfcEmu_1/iClk
add wave -noupdate /tbnfcemu/NfcEmu_1/inResetAsync
add wave -noupdate /tbnfcemu/sWdtReset
add wave -noupdate /tbnfcemu/sDin
add wave -noupdate /tbnfcemu/NfcEmu_1/oAckIn
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/oDout.Id -radix hexadecimal} {/tbnfcemu/NfcEmu_1/oDout.Data -radix hexadecimal}} -expand -subitemconfig {/tbnfcemu/NfcEmu_1/oDout.Id {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/oDout.Data {-height 16 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/oDout
add wave -noupdate /tbnfcemu/NfcEmu_1/iAckOut
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/rFwValid
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/PacketMux_1/R.ActivePort -radix unsigned}} -expand -subitemconfig {/tbnfcemu/NfcEmu_1/PacketMux_1/R.ActivePort {-height 16 -radix unsigned}} /tbnfcemu/NfcEmu_1/PacketMux_1/R
add wave -noupdate -expand /tbnfcemu/NfcEmu_1/PacketMux_1/sAckIn
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
add wave -noupdate /tbnfcemu/NfcEmu_1/sPiccATxToHost
add wave -noupdate /tbnfcemu/NfcEmu_1/sPiccARxToHost
add wave -noupdate /tbnfcemu/NfcEmu_1/sPiccALogicToHost
add wave -noupdate /tbnfcemu/NfcEmu_1/sPcdARxToHost
add wave -noupdate /tbnfcemu/NfcEmu_1/sControlToHost
add wave -noupdate -expand -subitemconfig {/tbnfcemu/NfcEmu_1/sCpuToHost.DPort -expand} /tbnfcemu/NfcEmu_1/sCpuToHost
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
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/sHostToControl
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/sHostToCpu
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/sHostToCpuFw
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/sHostToLayer4
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/sHostToPcdA
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/sHostToPiccA
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/iOutputAck
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/oInputAck
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/oOutputPorts
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/iDin
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/iEnable
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/iRdAdr
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/iRdStb
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/iSyncReset
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/iValid
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/inResetAsync
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/oAck
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/oBytesAvailable
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/oDout
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/oRdAck
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/rAck
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/rFull
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/rWriteAdr
add wave -noupdate -expand -group hostbuffer -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/T51Interface_1/RxBuffers(0)/RxBuffer/sRam
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sRomAdr
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sRomData
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/snCpuReset
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbAck
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbAdr
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbDin
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbDout
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbRdStb
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sWbWrStb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {403367467 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 222
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
WaveRestoreZoom {401977476 ps} {413800776 ps}
