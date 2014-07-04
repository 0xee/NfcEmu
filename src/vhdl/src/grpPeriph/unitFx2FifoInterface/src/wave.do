onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbfx2fifointerface/iAck
add wave -noupdate -radix hexadecimal /tbfx2fifointerface/iData
add wave -noupdate /tbfx2fifointerface/iEndOfPacket
add wave -noupdate /tbfx2fifointerface/iFx2Clk
add wave -noupdate -expand -subitemconfig {/tbfx2fifointerface/DUT/R.EofTimeout {-format Analog-Step -height 84}} /tbfx2fifointerface/DUT/R
add wave -noupdate /tbfx2fifointerface/iFx2Data
add wave -noupdate /tbfx2fifointerface/iFx2Flags
add wave -noupdate /tbfx2fifointerface/iValid
add wave -noupdate /tbfx2fifointerface/inResetAsync
add wave -noupdate -radix hexadecimal /tbfx2fifointerface/ioFx2Data
add wave -noupdate /tbfx2fifointerface/oAck
add wave -noupdate -radix hexadecimal /tbfx2fifointerface/oData
add wave -noupdate -radix hexadecimal /tbfx2fifointerface/oFx2Data
add wave -noupdate /tbfx2fifointerface/oFx2FifoAdr
add wave -noupdate /tbfx2fifointerface/oFx2Wakeup
add wave -noupdate /tbfx2fifointerface/oValid
add wave -noupdate /tbfx2fifointerface/onFx2DataOe
add wave -noupdate /tbfx2fifointerface/onFx2RdStrobe
add wave -noupdate /tbfx2fifointerface/onFx2WrStrobe
add wave -noupdate /tbfx2fifointerface/sEndOfSim
add wave -noupdate /tbfx2fifointerface/onFx2PktEnd
add wave -noupdate -expand -subitemconfig {/tbfx2fifointerface/sFromHost.DPort -expand} /tbfx2fifointerface/sFromHost
add wave -noupdate -expand /tbfx2fifointerface/sToHost
add wave -noupdate /tbfx2fifointerface/sWdtReset
add wave -noupdate /tbfx2fifointerface/PacketDecoder_1/iDin
add wave -noupdate /tbfx2fifointerface/PacketDecoder_1/iValid
add wave -noupdate /tbfx2fifointerface/PacketDecoder_1/oAckIn
add wave -noupdate -expand /tbfx2fifointerface/PacketDecoder_1/R
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9997103867 ps} 0}
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
WaveRestoreZoom {0 ps} {105 ms}
