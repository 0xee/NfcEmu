onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbpacketdecoder/iAckOut
add wave -noupdate /tbpacketdecoder/iClk
add wave -noupdate -radix hexadecimal /tbpacketdecoder/iDin
add wave -noupdate /tbpacketdecoder/iValid
add wave -noupdate /tbpacketdecoder/inResetAsync
add wave -noupdate /tbpacketdecoder/oAckIn
add wave -noupdate -childformat {{/tbpacketdecoder/oDout.Id -radix hexadecimal} {/tbpacketdecoder/oDout.Data -radix hexadecimal}} -expand -subitemconfig {/tbpacketdecoder/oDout.Id {-height 16 -radix hexadecimal} /tbpacketdecoder/oDout.Data {-height 16 -radix hexadecimal}} /tbpacketdecoder/oDout
add wave -noupdate -radix hexadecimal /tbpacketdecoder/DUT/PortBuffer_1/rBuffer
add wave -noupdate /tbpacketdecoder/DUT/PortBuffer_1/rEofSet
add wave -noupdate /tbpacketdecoder/DUT/PortBuffer_1/rValid
add wave -noupdate /tbpacketdecoder/DUT/PortBuffer_1/sStore
add wave -noupdate -expand /tbpacketdecoder/DUT/R
add wave -noupdate /tbpacketdecoder/sEncoderBusy
add wave -noupdate /tbpacketdecoder/sEndOfSim
add wave -noupdate /tbpacketdecoder/sPacketCount
add wave -noupdate -radix hexadecimal -childformat {{/tbpacketdecoder/sPacketIn.Id -radix hexadecimal} {/tbpacketdecoder/sPacketIn.Data -radix hexadecimal} {/tbpacketdecoder/sPacketIn.Valid -radix hexadecimal} {/tbpacketdecoder/sPacketIn.Eof -radix hexadecimal} {/tbpacketdecoder/sPacketIn.Error -radix hexadecimal}} -subitemconfig {/tbpacketdecoder/sPacketIn.Id {-height 16 -radix hexadecimal} /tbpacketdecoder/sPacketIn.Data {-height 16 -radix hexadecimal} /tbpacketdecoder/sPacketIn.Valid {-height 16 -radix hexadecimal} /tbpacketdecoder/sPacketIn.Eof {-height 16 -radix hexadecimal} /tbpacketdecoder/sPacketIn.Error {-height 16 -radix hexadecimal}} /tbpacketdecoder/sPacketIn
add wave -noupdate /tbpacketdecoder/sPacketInAck
add wave -noupdate /tbpacketdecoder/sRxPacketCount
add wave -noupdate /tbpacketdecoder/sSinkAckIn
add wave -noupdate -radix hexadecimal /tbpacketdecoder/sSinkIn
add wave -noupdate /tbpacketdecoder/sSinkValid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8356562 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 181
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
WaveRestoreZoom {8153168 ps} {8579952 ps}
