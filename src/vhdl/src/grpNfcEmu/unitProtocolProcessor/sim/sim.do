
exec ./compile.sh

vsim -novopt tbProtocolProcessor

do wave.do

run 1 ms