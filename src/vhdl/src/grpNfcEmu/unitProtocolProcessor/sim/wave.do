onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tbprotocolprocessor/iClk
add wave -noupdate -radix hexadecimal /tbprotocolprocessor/inResetAsync
add wave -noupdate -radix hexadecimal /tbprotocolprocessor/sIn
add wave -noupdate -radix hexadecimal /tbprotocolprocessor/sAckIn
add wave -noupdate -radix hexadecimal /tbprotocolprocessor/sOut
add wave -noupdate -radix hexadecimal /tbprotocolprocessor/sAckOut
add wave -noupdate -radix hexadecimal /tbprotocolprocessor/sFwAck
add wave -noupdate -radix hexadecimal -childformat {{/tbprotocolprocessor/sFwIn.Id -radix hexadecimal} {/tbprotocolprocessor/sFwIn.Data -radix hexadecimal} {/tbprotocolprocessor/sFwIn.Valid -radix hexadecimal} {/tbprotocolprocessor/sFwIn.Eof -radix hexadecimal} {/tbprotocolprocessor/sFwIn.ShortFrame -radix hexadecimal}} -expand -subitemconfig {/tbprotocolprocessor/sFwIn.Id {-radix hexadecimal} /tbprotocolprocessor/sFwIn.Data {-radix hexadecimal} /tbprotocolprocessor/sFwIn.Valid {-radix hexadecimal} /tbprotocolprocessor/sFwIn.Eof {-radix hexadecimal} /tbprotocolprocessor/sFwIn.ShortFrame {-radix hexadecimal}} /tbprotocolprocessor/sFwIn
add wave -noupdate -radix hexadecimal /tbprotocolprocessor/ProtocolProcessor_1/sRomAdr
add wave -noupdate -radix hexadecimal /tbprotocolprocessor/ProtocolProcessor_1/sRomData
add wave -noupdate -radix hexadecimal /tbprotocolprocessor/ProtocolProcessor_1/snCpuReset
add wave -noupdate -radix hexadecimal /tbprotocolprocessor/ProtocolProcessor_1/rFwInAdr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13240000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 247
configure wave -valuecolwidth 140
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
