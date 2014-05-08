vcom ../src/*.vhd

vsim -novopt DualClockedFifo_tb

do wave.do

run 1 ms