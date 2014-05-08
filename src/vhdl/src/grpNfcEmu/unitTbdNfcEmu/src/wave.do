onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbtbdnfcemu/oDac1Ctrl
add wave -noupdate /tbtbdnfcemu/Clk
add wave -noupdate /tbtbdnfcemu/DUT/snSyncReset
add wave -noupdate /tbtbdnfcemu/DUT/sDacUpdate
add wave -noupdate /tbtbdnfcemu/DUT/sDacAVal
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {55653710 ps} 0}
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
WaveRestoreZoom {0 ps} {4200 us}
