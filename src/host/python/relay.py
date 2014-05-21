#!/bin/python

import time
import socket
from nfcemu import *

def GetUid(fd):
    hex_string = fd.readline();
    arr =  bytearray.fromhex(hex_string.strip())
    return [b for b in arr]

emu = NfcEmu()

emu.OpenUsbDevice("../../vhdl/src/grpNfcEmu/unitTbdNfcEmu/synlay/TbdNfcEmu.sof")


emu.SendIHexFile(Id.CpuFw, "../../t51/smartcard/smartcard.ihx")

emu.AddDisplayLog(Id.Any)


emu.SetUnitEnable(Id.Iso14443aPicc, False)

emu.SendCmd(Id.Cpu, [2], 100)


print "Waiting for client..." 
serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
serversocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
serversocket.bind(("", 1337))
serversocket.listen(1)

(clientsocket, address) = serversocket.accept()

serversocket.close()

print "client connected"


uid = GetUid(clientsocket.makefile())
print uid

emu.SetPiccUid(uid)
emu.SetUnitEnable(Id.Iso14443aPicc, True)

emu.ConnectSocket(UnitId(Id.Cpu, Flags.Down), clientsocket.fileno())
print "socket connected to unit"

try:

    while 1:
        time.sleep(1)
        


except:
    print "exception caught"
    clientsocket.shutdown(socket.SHUT_RDWR)
    clientsocket.close()
print ":::: end of script"
