onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbserialdac/iClk
add wave -noupdate /tbserialdac/inResetAsync
add wave -noupdate /tbserialdac/iValid
add wave -noupdate /tbserialdac/oAck
add wave -noupdate /tbserialdac/iDacA
add wave -noupdate /tbserialdac/iDacB
add wave -noupdate /tbserialdac/iDacC
add wave -noupdate /tbserialdac/iDacD
add wave -noupdate /tbserialdac/oDacCtrl
add wave -noupdate -expand /tbserialdac/SerialDac_1/R
add wave -noupdate /tbserialdac/SerialDac_1/sDacData
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {140325000 ps} 0}
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
WaveRestoreZoom {0 ps} {1050 us}
