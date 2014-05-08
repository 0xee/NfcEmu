onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbdcblock/DUT/iClk
add wave -noupdate /tbdcblock/DUT/inResetAsync
add wave -noupdate /tbdcblock/DUT/iDin
add wave -noupdate /tbdcblock/DUT/oDout
add wave -noupdate /tbdcblock/DUT/iValid
add wave -noupdate /tbdcblock/DUT/oValid
add wave -noupdate /tbdcblock/DUT/sX
add wave -noupdate -radix decimal -childformat {{/tbdcblock/DUT/R.W -radix decimal} {/tbdcblock/DUT/R.lastX -radix decimal} {/tbdcblock/DUT/R.Y -radix decimal}} -expand -subitemconfig {/tbdcblock/DUT/R.W {-format Analog-Step -height 84 -max 1766.0000000000002 -min -1760.0 -radix decimal} /tbdcblock/DUT/R.lastX {-format Analog-Step -height 84 -max 1024.0 -min -1025.0 -radix decimal} /tbdcblock/DUT/R.Y {-format Analog-Step -height 84 -max 2047.0 -min -2048.0 -radix decimal}} /tbdcblock/DUT/R
add wave -noupdate -format Analog-Step -height 84 -max 458528.0 -min -458752.0 -radix decimal /tbdcblock/DUT/sS1
add wave -noupdate -format Analog-Step -height 84 -max 2047.0 -radix decimal /tbdcblock/DUT/sS2
add wave -noupdate /tbdcblock/DUT/NextR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {188411 ps} 0}
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
WaveRestoreZoom {0 ps} {1640626 ps}
