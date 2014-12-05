#!/bin/python

import time

from nfcemu import *

emu = NfcEmu()

emu.OpenUsbDevice("../../vhdl/src/grpNfcEmu/unitTbdNfcEmu/synlay/TbdNfcEmu.sof")

emu.AddDisplayLog(Id.Any)
emu.SetFlag(0, 1);
emu.SetUnitEnable(Id.Iso14443aPicc, 1)
emu.SetUnitEnable(Id.Iso14443aPcd, 1)

try:

    while 1:
        time.sleep(1)
        


except:
    print "exception caught"
print ":::: end of script"
