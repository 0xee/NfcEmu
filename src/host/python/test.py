#!/bin/python

import time
import sys
import socket
from nfcemu import *

def TestCpu(emu):
    "Functional test of the NfcEmu CPU"
    print "CPU running: " + str(emu.GetFlag(3))
    emu.SendIHexFile(Id.CpuFw, "../../t51/smartcard/smartcard.ihx")
    print "blubb"
    print "CPU running: " + str(emu.GetFlag(3))
    time.sleep(0.2); # wait until the cpu is ready

    a = [0xA, 0xB, 0xC, 0xD, 0xE, 0xF]
    b = a+a
    print "Testing echo mode..."
    emu.SendCmd(Id.Cpu, [0], 100)
    #time.sleep(0.1)
    print "Sending: " + str(a)
    print "Echo   : " + str(emu.SendCmd(Id.Cpu, a, 10))
    print "Sending: " + str(b)
    print "Echo   : " + str(emu.SendCmd(Id.Cpu, b, 10))

    print "Resetting CPU..."
    emu.SendIHexFile(Id.CpuFw, "../../t51/smartcard/smartcard.ihx")
    
    time.sleep(0.2) # wait until the cpu is ready
    print "Testing echo counter mode..."
    emu.SendCmd(Id.Cpu, [1], 10)
    print "Sending: " + str(a)
    print "Echo   : " + str(emu.SendCmd(Id.Cpu, a, 10))
    print "Sending: " + str(b)
    print "Echo   : " + str(emu.SendCmd(Id.Cpu, b, 10))
    
    x = [0]
    for i in range(0, 300):
        x.append(i % 256)

    print "Sending: " + str(x)
    print "Echo   : " + str(emu.SendCmd(Id.Cpu, x, 10))

    
try:
    n = NfcEmu()
    
    n.OpenUsbDevice("../../vhdl/src/grpNfcEmu/unitTbdNfcEmu/synlay/TbdNfcEmu.sof")

    n.AddDisplayLog(Id.Any)

    TestCpu(n)
    time.sleep(1)
        


except KeyboardInterrupt:
    print "ctrl-c caught"

print ":::: end of script"
