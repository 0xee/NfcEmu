onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbfir/iClk
add wave -noupdate /tbfir/inResetAsync
add wave -noupdate -format Analog-Step -height 84 -max 1024.0 -min -1.0 -radix decimal /tbfir/iDin
add wave -noupdate -format Analog-Step -height 84 -max 1024.0 -min -1025.0 -radix decimal /tbfir/oDout
add wave -noupdate /tbfir/cClkFreq
add wave -noupdate /tbfir/cClkPeriod
add wave -noupdate -radix decimal -childformat {{/tbfir/DUT/R.Z -radix decimal} {/tbfir/DUT/R.RegTree -radix decimal -childformat {{/tbfir/DUT/R.RegTree(0) -radix decimal -childformat {{/tbfir/DUT/R.RegTree(0)(0) -radix decimal} {/tbfir/DUT/R.RegTree(0)(1) -radix decimal} {/tbfir/DUT/R.RegTree(0)(2) -radix decimal} {/tbfir/DUT/R.RegTree(0)(3) -radix decimal} {/tbfir/DUT/R.RegTree(0)(4) -radix decimal} {/tbfir/DUT/R.RegTree(0)(5) -radix decimal} {/tbfir/DUT/R.RegTree(0)(6) -radix decimal} {/tbfir/DUT/R.RegTree(0)(7) -radix decimal} {/tbfir/DUT/R.RegTree(0)(8) -radix decimal} {/tbfir/DUT/R.RegTree(0)(9) -radix decimal} {/tbfir/DUT/R.RegTree(0)(10) -radix decimal} {/tbfir/DUT/R.RegTree(0)(11) -radix decimal} {/tbfir/DUT/R.RegTree(0)(12) -radix decimal} {/tbfir/DUT/R.RegTree(0)(13) -radix decimal} {/tbfir/DUT/R.RegTree(0)(14) -radix decimal} {/tbfir/DUT/R.RegTree(0)(15) -radix decimal}}} {/tbfir/DUT/R.RegTree(1) -radix decimal} {/tbfir/DUT/R.RegTree(2) -radix decimal} {/tbfir/DUT/R.RegTree(3) -radix decimal} {/tbfir/DUT/R.RegTree(4) -radix decimal}}}} -expand -subitemconfig {/tbfir/DUT/R.Z {-radix decimal} /tbfir/DUT/R.RegTree {-radix decimal -childformat {{/tbfir/DUT/R.RegTree(0) -radix decimal -childformat {{/tbfir/DUT/R.RegTree(0)(0) -radix decimal} {/tbfir/DUT/R.RegTree(0)(1) -radix decimal} {/tbfir/DUT/R.RegTree(0)(2) -radix decimal} {/tbfir/DUT/R.RegTree(0)(3) -radix decimal} {/tbfir/DUT/R.RegTree(0)(4) -radix decimal} {/tbfir/DUT/R.RegTree(0)(5) -radix decimal} {/tbfir/DUT/R.RegTree(0)(6) -radix decimal} {/tbfir/DUT/R.RegTree(0)(7) -radix decimal} {/tbfir/DUT/R.RegTree(0)(8) -radix decimal} {/tbfir/DUT/R.RegTree(0)(9) -radix decimal} {/tbfir/DUT/R.RegTree(0)(10) -radix decimal} {/tbfir/DUT/R.RegTree(0)(11) -radix decimal} {/tbfir/DUT/R.RegTree(0)(12) -radix decimal} {/tbfir/DUT/R.RegTree(0)(13) -radix decimal} {/tbfir/DUT/R.RegTree(0)(14) -radix decimal} {/tbfir/DUT/R.RegTree(0)(15) -radix decimal}}} {/tbfir/DUT/R.RegTree(1) -radix decimal} {/tbfir/DUT/R.RegTree(2) -radix decimal} {/tbfir/DUT/R.RegTree(3) -radix decimal} {/tbfir/DUT/R.RegTree(4) -radix decimal}} -expand} /tbfir/DUT/R.RegTree(0) {-radix decimal -childformat {{/tbfir/DUT/R.RegTree(0)(0) -radix decimal} {/tbfir/DUT/R.RegTree(0)(1) -radix decimal} {/tbfir/DUT/R.RegTree(0)(2) -radix decimal} {/tbfir/DUT/R.RegTree(0)(3) -radix decimal} {/tbfir/DUT/R.RegTree(0)(4) -radix decimal} {/tbfir/DUT/R.RegTree(0)(5) -radix decimal} {/tbfir/DUT/R.RegTree(0)(6) -radix decimal} {/tbfir/DUT/R.RegTree(0)(7) -radix decimal} {/tbfir/DUT/R.RegTree(0)(8) -radix decimal} {/tbfir/DUT/R.RegTree(0)(9) -radix decimal} {/tbfir/DUT/R.RegTree(0)(10) -radix decimal} {/tbfir/DUT/R.RegTree(0)(11) -radix decimal} {/tbfir/DUT/R.RegTree(0)(12) -radix decimal} {/tbfir/DUT/R.RegTree(0)(13) -radix decimal} {/tbfir/DUT/R.RegTree(0)(14) -radix decimal} {/tbfir/DUT/R.RegTree(0)(15) -radix decimal}} -expand} /tbfir/DUT/R.RegTree(0)(0) {-radix decimal} /tbfir/DUT/R.RegTree(0)(1) {-radix decimal} /tbfir/DUT/R.RegTree(0)(2) {-radix decimal} /tbfir/DUT/R.RegTree(0)(3) {-radix decimal} /tbfir/DUT/R.RegTree(0)(4) {-radix decimal} /tbfir/DUT/R.RegTree(0)(5) {-radix decimal} /tbfir/DUT/R.RegTree(0)(6) {-radix decimal} /tbfir/DUT/R.RegTree(0)(7) {-radix decimal} /tbfir/DUT/R.RegTree(0)(8) {-radix decimal} /tbfir/DUT/R.RegTree(0)(9) {-radix decimal} /tbfir/DUT/R.RegTree(0)(10) {-radix decimal} /tbfir/DUT/R.RegTree(0)(11) {-radix decimal} /tbfir/DUT/R.RegTree(0)(12) {-radix decimal} /tbfir/DUT/R.RegTree(0)(13) {-radix decimal} /tbfir/DUT/R.RegTree(0)(14) {-radix decimal} /tbfir/DUT/R.RegTree(0)(15) {-radix decimal} /tbfir/DUT/R.RegTree(1) {-radix decimal} /tbfir/DUT/R.RegTree(2) {-radix decimal} /tbfir/DUT/R.RegTree(3) {-radix decimal} /tbfir/DUT/R.RegTree(4) {-radix decimal}} /tbfir/DUT/R
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {46329668 ps} 0}
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
WaveRestoreZoom {45509355 ps} {47149981 ps}
