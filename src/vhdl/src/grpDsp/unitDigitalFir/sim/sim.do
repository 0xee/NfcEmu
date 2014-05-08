
exec ./compile.sh

vsim -novopt tbDigitalFir

#do wave.do

run 200 us

quit -sim

quit -f
