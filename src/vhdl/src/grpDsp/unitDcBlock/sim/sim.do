vcom ../src/*.vhd

vsim -novopt tbDcBlock

do wave.do

run 200 us

#quit -sim

#quit -f