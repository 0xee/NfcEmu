vcom ../src/*-e.vhd
vcom ../src/*-a.vhd

vsim -novopt work.tbSerialDac

do wave.do

run 1000 us