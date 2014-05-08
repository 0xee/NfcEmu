
exec ./compile.sh

vsim -novopt tbNfcEmu

do wave.do

run 22 ms