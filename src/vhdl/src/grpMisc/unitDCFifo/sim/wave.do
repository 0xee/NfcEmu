onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dualclockedfifo_tb/iWrClk
add wave -noupdate /dualclockedfifo_tb/iRdClk
add wave -noupdate /dualclockedfifo_tb/inResetAsync
add wave -noupdate /dualclockedfifo_tb/iValid
add wave -noupdate /dualclockedfifo_tb/iDin
add wave -noupdate /dualclockedfifo_tb/oAck
add wave -noupdate /dualclockedfifo_tb/oValid
add wave -noupdate /dualclockedfifo_tb/oDout
add wave -noupdate /dualclockedfifo_tb/iAck
add wave -noupdate -divider {New Divider}
add wave -noupdate /dualclockedfifo_tb/DualClockedFifo_1/SelectFifoWidth8/alt_fifo_8x32_1/aclr
add wave -noupdate /dualclockedfifo_tb/DualClockedFifo_1/SelectFifoWidth8/alt_fifo_8x32_1/data
add wave -noupdate /dualclockedfifo_tb/DualClockedFifo_1/SelectFifoWidth8/alt_fifo_8x32_1/rdclk
add wave -noupdate /dualclockedfifo_tb/DualClockedFifo_1/SelectFifoWidth8/alt_fifo_8x32_1/rdreq
add wave -noupdate /dualclockedfifo_tb/DualClockedFifo_1/SelectFifoWidth8/alt_fifo_8x32_1/wrclk
add wave -noupdate /dualclockedfifo_tb/DualClockedFifo_1/SelectFifoWidth8/alt_fifo_8x32_1/wrreq
add wave -noupdate /dualclockedfifo_tb/DualClockedFifo_1/SelectFifoWidth8/alt_fifo_8x32_1/q
add wave -noupdate /dualclockedfifo_tb/DualClockedFifo_1/SelectFifoWidth8/alt_fifo_8x32_1/rdempty
add wave -noupdate /dualclockedfifo_tb/DualClockedFifo_1/SelectFifoWidth8/alt_fifo_8x32_1/wrfull
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30609541 ps} 0}
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
