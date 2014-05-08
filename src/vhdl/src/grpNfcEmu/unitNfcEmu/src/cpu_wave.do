onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbnfcemu/NfcEmu_1/iClk
add wave -noupdate /tbnfcemu/NfcEmu_1/inResetAsync
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/snCpuReset
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/iDin.Id -radix hexadecimal} {/tbnfcemu/NfcEmu_1/iDin.Data -radix hexadecimal -childformat {{/tbnfcemu/NfcEmu_1/iDin.Data(7) -radix unsigned} {/tbnfcemu/NfcEmu_1/iDin.Data(6) -radix unsigned} {/tbnfcemu/NfcEmu_1/iDin.Data(5) -radix unsigned} {/tbnfcemu/NfcEmu_1/iDin.Data(4) -radix unsigned} {/tbnfcemu/NfcEmu_1/iDin.Data(3) -radix unsigned} {/tbnfcemu/NfcEmu_1/iDin.Data(2) -radix unsigned} {/tbnfcemu/NfcEmu_1/iDin.Data(1) -radix unsigned} {/tbnfcemu/NfcEmu_1/iDin.Data(0) -radix unsigned}}}} -subitemconfig {/tbnfcemu/NfcEmu_1/iDin.Id {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/iDin.Data {-height 16 -radix hexadecimal -childformat {{/tbnfcemu/NfcEmu_1/iDin.Data(7) -radix unsigned} {/tbnfcemu/NfcEmu_1/iDin.Data(6) -radix unsigned} {/tbnfcemu/NfcEmu_1/iDin.Data(5) -radix unsigned} {/tbnfcemu/NfcEmu_1/iDin.Data(4) -radix unsigned} {/tbnfcemu/NfcEmu_1/iDin.Data(3) -radix unsigned} {/tbnfcemu/NfcEmu_1/iDin.Data(2) -radix unsigned} {/tbnfcemu/NfcEmu_1/iDin.Data(1) -radix unsigned} {/tbnfcemu/NfcEmu_1/iDin.Data(0) -radix unsigned}}} /tbnfcemu/NfcEmu_1/iDin.Data(7) {-height 16 -radix unsigned} /tbnfcemu/NfcEmu_1/iDin.Data(6) {-height 16 -radix unsigned} /tbnfcemu/NfcEmu_1/iDin.Data(5) {-height 16 -radix unsigned} /tbnfcemu/NfcEmu_1/iDin.Data(4) {-height 16 -radix unsigned} /tbnfcemu/NfcEmu_1/iDin.Data(3) {-height 16 -radix unsigned} /tbnfcemu/NfcEmu_1/iDin.Data(2) {-height 16 -radix unsigned} /tbnfcemu/NfcEmu_1/iDin.Data(1) {-height 16 -radix unsigned} /tbnfcemu/NfcEmu_1/iDin.Data(0) {-height 16 -radix unsigned}} /tbnfcemu/NfcEmu_1/iDin
add wave -noupdate /tbnfcemu/NfcEmu_1/oAckIn
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/oDout.Id -radix hexadecimal} {/tbnfcemu/NfcEmu_1/oDout.Data -radix hexadecimal}} -subitemconfig {/tbnfcemu/NfcEmu_1/oDout.Id {-height 16 -radix hexadecimal} /tbnfcemu/NfcEmu_1/oDout.Data {-height 16 -radix hexadecimal}} /tbnfcemu/NfcEmu_1/oDout
add wave -noupdate /tbnfcemu/NfcEmu_1/iAckOut
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/rFwValid
add wave -noupdate -childformat {{/tbnfcemu/NfcEmu_1/PacketMux_1/R.ActivePort -radix unsigned}} -expand -subitemconfig {/tbnfcemu/NfcEmu_1/PacketMux_1/R.ActivePort {-height 16 -radix unsigned}} /tbnfcemu/NfcEmu_1/PacketMux_1/R
add wave -noupdate /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/rFwInAdr
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/iInputPorts
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/oInputAck
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/iOutputAck
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/oOutputPorts
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sRomAdr
add wave -noupdate -radix hexadecimal /tbnfcemu/NfcEmu_1/Iso14443_4_1/ProtocolProcessor_1/sRomData
add wave -noupdate /tbnfcemu/NfcEmu_1/PacketMux_1/sAckIn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {474207245 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 153
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
WaveRestoreZoom {0 ps} {209190231 ps}
