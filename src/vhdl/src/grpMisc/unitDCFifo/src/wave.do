onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbdcfifo/inResetAsync
add wave -noupdate /tbdcfifo/iSyncReset
add wave -noupdate /tbdcfifo/iWrClk
add wave -noupdate -radix hexadecimal /tbdcfifo/iDin
add wave -noupdate /tbdcfifo/iValid
add wave -noupdate /tbdcfifo/oAckIn
add wave -noupdate /tbdcfifo/iRdClk
add wave -noupdate -radix hexadecimal /tbdcfifo/oDout
add wave -noupdate /tbdcfifo/oValid
add wave -noupdate /tbdcfifo/iAckOut
add wave -noupdate /tbdcfifo/sEndOfSim
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {224775 ps} 0}
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
WaveRestoreZoom {0 ps} {1304574 ps}
