#!/bin/python

import time
import sys
import socket
from nfcemu import *

def EchoTest(emu):
    print "Testing echo mode..."
    emu.SendIHexFile(Id.CpuFw, "../../t51/smartcard/smartcard.ihx")
    time.sleep(0.2); # wait until the cpu is ready
    emu.SendCmd(Id.Cpu, [0], 100)

    a = [0xA, 0xB, 0xC, 0xD, 0xE, 0xF]
    time.sleep(0.1)
    
    for i in range(0, 1000):
        cmd = [i/256, i%256] + a
        resp = emu.SendCmd(Id.Cpu, cmd, 100);
        if resp != cmd:
            raise NameError("Echo error")

def EchoCounterTest(emu):
    print "Testing echo counter mode..."
    emu.SendIHexFile(Id.CpuFw, "../../t51/smartcard/smartcard.ihx")
    time.sleep(0.2) # wait until the cpu is ready
    emu.SendCmd(Id.Cpu, [1], 100)
    
    cmd = [0]
    for i in range(0, 100):
        cmd.append(i % 256)
        resp = emu.SendCmd(Id.Cpu, cmd, 100);
    
        if (len(resp) != 2) or (resp[0]*256+resp[1] != len(cmd)):
            print "Resp: " + str(resp)

    
def ReactionTest(emu):
    print "Testing reaction mode..."
    emu.SendIHexFile(Id.CpuFw, "../../t51/smartcard/smartcard.ihx")
    time.sleep(0.2) # wait until the cpu is ready
    emu.SendCmd(Id.Cpu, [3], 100)
    
    time.sleep(1)
    print "Sending command"
    cmd = [1, 2, 3, 4, 5]
    resp = emu.Send(Id.Cpu, [9,9,9,9]);
    resp = emu.SendCmd(Id.Cpu, cmd, 3000);
    if resp != cmd: raise NameError("Reaction test")
    print "Received response"
    emu.SendIHexFile(Id.CpuFw, "../../t51/smartcard/smartcard.ihx")
    time.sleep(0.2) # wait until the cpu is ready
    
n = NfcEmu()
    
n.OpenUsbDevice("../../vhdl/src/grpNfcEmu/unitTbdNfcEmu/synlay/TbdNfcEmu.sof")

n.AddDisplayLog(Id.Any)

try:
    ReactionTest(n)
    EchoTest(n)
    EchoCounterTest(n)
    time.sleep(1)
        
except KeyboardInterrupt:
    print "ctrl-c caught"
except NameError, e:
    print "Error in " + str(e)

n.CloseDevice()
print ":::: end of script"
