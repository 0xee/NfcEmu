vlog ../src/*.sv

vsim -novopt work.dacctrl_tb

do wave.do

run 1000 us