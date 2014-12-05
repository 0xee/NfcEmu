#!/bin/python

import time
import socket
import threading
from contextlib import closing
from nfcemu import *

def EchoTest(emu):
    print("Testing echo mode...")
    emu.SendIHexFile(Id.CpuFw, "../../t51/smartcard/smartcard.ihx")
    time.sleep(0.2); # wait until the cpu is ready

    emu.SendCmd(Id.Cpu, [0], 100)

    a = [0xA, 0xB, 0xC, 0xD, 0xE, 0xF]
    time.sleep(0.1)
    for i in range(0, 10):
        cmd = [i/256, i%256] + a
#        raw_input()
        resp = emu.SendCmd(Id.Cpu, cmd, 500);
        if resp != cmd:
            print resp
            raise Exception("Echo Test")

def EchoCounterTest(emu):
    print("Testing echo counter mode...")
    emu.SendIHexFile(Id.CpuFw, "../../t51/smartcard/smartcard.ihx")
    time.sleep(0.2) # wait until the cpu is ready
    emu.SendCmd(Id.Cpu, [1], 100)
    
    cmd = [0]
    for i in range(0, 100):
        cmd.append(i % 256)
        resp = emu.SendCmd(Id.Cpu, cmd, 100);
        if (len(resp) != 2) or (resp[0]*256+resp[1] != len(cmd)):
            raise Exception("Echo Counter Test")
    
def ReactionTest(emu):    
    class PiccChecker(threading.Thread):
        def __init__(self):
            super(PiccChecker, self).__init__()            
        def run(self):
            picc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            picc.connect(('localhost', 1337))
            ref = [];# i = 0
            with closing(picc.makefile()) as f:
                for line in f:
                    #print(str(i) + ": " + line); i+=1
                    if len(ref) == 0: ref = line
                    elif line == "00\n": break
                    elif ref != line: raise Exception("Error in message stream");
            picc.shutdown(socket.SHUT_RDWR)
            picc.close()

    print("Testing reaction mode...")
    emu.SendIHexFile(Id.CpuFw, "../../t51/smartcard/smartcard.ihx")

    serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    serversocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    serversocket.bind(("", 1337))
    serversocket.listen(1)

    pc = PiccChecker()
    pc.start()
    (clientsocket, address) = serversocket.accept()
    serversocket.close()

    s = emu.ConnectSocket(UnitId(Id.Iso14443aPicc, Flags.Down), clientsocket.fileno())
    
    cmd = [1, 2, 3, 4, 5]
    time.sleep(0.5) # wait until the cpu is ready
    emu.SendCmd(Id.Cpu, [3], 1000)
    time.sleep(0.5) # wait until sending is in progress

    resp = emu.SendCmd(Id.Cpu, cmd, 1000);
    if resp != cmd: raise Exception("Reaction test")
    pc.join();
    emu.WaitForDisconnect(s)



#n.AddDisplayLog(Id.Any)


try:
    n = NfcEmu()
    n.OpenUsbDevice("../../vhdl/src/grpNfcEmu/unitTbdNfcEmu/synlay/TbdNfcEmu.sof")
    #n.AddDisplayLog(Id.Any)

    EchoTest(n)
    EchoCounterTest(n)
    ReactionTest(n)    

    n.CloseDevice()
        
except KeyboardInterrupt:
    print("ctrl-c caught")
except Exception as e:
    print("Error in " + str(e))


print("All tests completed successfully")
