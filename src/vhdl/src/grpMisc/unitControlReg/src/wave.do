onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbcontrolreg/inResetAsync
add wave -noupdate /tbcontrolreg/iClk
add wave -noupdate -childformat {{/tbcontrolreg/iDin.Id -radix hexadecimal} {/tbcontrolreg/iDin.Data -radix hexadecimal}} -expand -subitemconfig {/tbcontrolreg/iDin.Id {-radix hexadecimal} /tbcontrolreg/iDin.Data {-radix hexadecimal}} /tbcontrolreg/iDin
add wave -noupdate /tbcontrolreg/oAckIn
add wave -noupdate -childformat {{/tbcontrolreg/oDout.Id -radix hexadecimal} {/tbcontrolreg/oDout.Data -radix hexadecimal}} -expand -subitemconfig {/tbcontrolreg/oDout.Id {-radix hexadecimal} /tbcontrolreg/oDout.Data {-radix hexadecimal}} /tbcontrolreg/oDout
add wave -noupdate /tbcontrolreg/iAckOut
add wave -noupdate -radix hexadecimal /tbcontrolreg/oCtrl
add wave -noupdate -radix hexadecimal /tbcontrolreg/iStatus
add wave -noupdate /tbcontrolreg/oCfgValid
add wave -noupdate /tbcontrolreg/oUpdateCfg
add wave -noupdate -childformat {{/tbcontrolreg/ControlReg_1/R.CfgBuffer -radix hexadecimal} {/tbcontrolreg/ControlReg_1/R.IoReg -radix hexadecimal}} -expand -subitemconfig {/tbcontrolreg/ControlReg_1/R.CfgBuffer {-radix hexadecimal} /tbcontrolreg/ControlReg_1/R.IoReg {-radix hexadecimal}} /tbcontrolreg/ControlReg_1/R
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7390 ps} 0}
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
WaveRestoreZoom {0 ps} {52500 ps}
