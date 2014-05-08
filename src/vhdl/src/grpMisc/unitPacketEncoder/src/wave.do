onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbpacketencoder/sEndOfSim
add wave -noupdate /tbpacketencoder/iClk
add wave -noupdate /tbpacketencoder/inResetAsync
add wave -noupdate -childformat {{/tbpacketencoder/iDin.Id -radix hexadecimal} {/tbpacketencoder/iDin.Data -radix hexadecimal}} -expand -subitemconfig {/tbpacketencoder/iDin.Id {-height 16 -radix hexadecimal} /tbpacketencoder/iDin.Data {-height 16 -radix hexadecimal}} /tbpacketencoder/iDin
add wave -noupdate /tbpacketencoder/oAckIn
add wave -noupdate -radix hexadecimal /tbpacketencoder/oDout
add wave -noupdate /tbpacketencoder/iAckOut
add wave -noupdate /tbpacketencoder/oValid
add wave -noupdate /tbpacketencoder/oBusy
add wave -noupdate /tbpacketencoder/sReceived
add wave -noupdate /tbpacketencoder/sPacketLen
add wave -noupdate /tbpacketencoder/sTxBytes
add wave -noupdate /tbpacketencoder/sRxBytes
add wave -noupdate /tbpacketencoder/sDleInData
add wave -noupdate /tbpacketencoder/sOne
add wave -noupdate /tbpacketencoder/sPacketCount
add wave -noupdate -expand /tbpacketencoder/PacketEncoder_1/R
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {699695000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {8267167363 ps} {15714759613 ps}
