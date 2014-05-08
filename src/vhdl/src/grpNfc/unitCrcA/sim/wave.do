onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tbcrca/DUT/cInitVal
add wave -noupdate -radix hexadecimal /tbcrca/DUT/cPoly
add wave -noupdate /tbcrca/DUT/iClk
add wave -noupdate -radix hexadecimal /tbcrca/DUT/iDin
add wave -noupdate /tbcrca/DUT/iSyncReset
add wave -noupdate /tbcrca/DUT/iValid
add wave -noupdate /tbcrca/DUT/inResetAsync
add wave -noupdate -radix hexadecimal /tbcrca/DUT/oCrcSum
add wave -noupdate -radix hexadecimal /tbcrca/DUT/rCrcReg
add wave -noupdate -radix hexadecimal /tbcrca/reversed
add wave -noupdate /tbcrca/Count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {174038 ps} 0}
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
WaveRestoreZoom {0 ps} {189 ns}
