"make -C ../../../../sim"

vsim -novopt misc.tbPacketEncoder

do wave.do

run -all

quit -sim