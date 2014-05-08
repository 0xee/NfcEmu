vmap misc /tmp/libs/misc
vmap global /tmp/libs/global
vmap osvvm /tmp/libs/osvvm

vsim -novopt misc.tbPacketEncoder

do wave.do

run -all

#quit -sim
quit
echo "end of sim"