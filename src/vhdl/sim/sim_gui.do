# generated Thu May  8 17:53:02 2014 by vhdmake



proc com {} { exec make com }
proc rerun {} { restart; run -all }

vmap dsp /tmp/libs/dsp
vmap fw /tmp/libs/fw
vmap global /tmp/libs/global
vmap misc /tmp/libs/misc
vmap nfc /tmp/libs/nfc
vmap nfcemu /tmp/libs/nfcemu
vmap osvvm /tmp/libs/osvvm
vmap periph /tmp/libs/periph
vmap t51 /tmp/libs/t51
if { [file exists wave.do] == 1} {
    do wave.do
}

do sim.do
