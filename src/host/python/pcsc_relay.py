#!/bin/python

import socket
from smartcard.System import readers
from contextlib import closing
import sys

def StrToList(s):
    return [b for b in bytearray.fromhex(s.strip())]

def ListToStr(l):
    return ' '.join('%02x' % b for b in l) 

idx = 0
if len(sys.argv) > 1:
    idx = int(sys.argv[1])
rr=readers()

print "Available readers: "
for r in rr:
    print "    " + str(r)


print "Connected to reader " + str(rr[idx])
connection = rr[idx].createConnection()
connection.connect()

cs = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
cs.connect(('localhost', 1337))

cs.send("deadbeef\n")

with closing(cs.makefile()) as f: #NOTE: closed independently
    for line in f:
        cmd = StrToList(line)
        if len(cmd) == 0:
            continue

        print "CMD:  " + ListToStr(cmd)

        resp, sw1, sw2 = connection.transmit(cmd)
        resp = ([sw1, sw2] + resp)

        print "RESP: " + ListToStr(resp)

        cs.send(ListToStr(resp) + '\n')
