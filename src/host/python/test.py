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
    time.sleep(0.1)
    
    for i in range(0, 1000):
        cmd = [i/256, i%256] + a
        resp = emu.SendCmd(Id.Cpu, cmd, 100);
        if resp != cmd:
            raise NameError("Echo error")

    print "Resetting CPU..."
    emu.SendIHexFile(Id.CpuFw, "../../t51/smartcard/smartcard.ihx")
    
    time.sleep(0.2) # wait until the cpu is ready
    print "Testing echo counter mode..."
    emu.SendCmd(Id.Cpu, [1], 10)
    
    cmd = [0]
    for i in range(0, 100):
        cmd.append(i % 256)
        resp = emu.SendCmd(Id.Cpu, cmd, 100);
    
        if (len(resp) != 2) or (resp[0]*256+resp[1] != len(cmd)):
            print "Resp: " + str(resp)

    
try:
    n = NfcEmu()
    
    n.OpenUsbDevice("../../vhdl/src/grpNfcEmu/unitTbdNfcEmu/synlay/TbdNfcEmu.sof")

    n.AddDisplayLog(Id.Any)

    TestCpu(n)
    time.sleep(1)
        


except KeyboardInterrupt:
    print "ctrl-c caught"
except NameError:
    print "error testing cpu"

print ":::: end of script"
