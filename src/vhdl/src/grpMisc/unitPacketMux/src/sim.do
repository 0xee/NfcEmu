vmap misc /tmp/libs/misc
vmap global /tmp/libs/global
vmap osvvm /tmp/libs/osvvm

vsim -novopt misc.tbPacketMux

do wave.do


run -all


echo "end of sim"