vcom  -2008 ../src/*.vhd

vsim -novopt work.tbCrcA

do wave.do

run 1 ms;