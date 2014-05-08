vcom ../../../grpPackages/pkgFilterCoefficients/src/FilterCoefficients-p.vhd
vcom ../src/*.vhd

vsim -novopt tbFir

#do wave.do

run 200 us

quit -sim

quit -f
