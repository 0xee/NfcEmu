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
f = 0
rr=readers()

if len(sys.argv) > 2:
    idx = int(sys.argv[1])
    f = open(sys.argv[2])
else:
    print "-------------------------------------------"
    print "usage: cmd_query <reader id> <command file>"
    print "-------------------------------------------"
    print "Available readers: "
    for r in rr:
        print "    " + str(r)
    sys.exit(0)

print "Connected to reader " + str(rr[idx])
connection = rr[idx].createConnection()
connection.connect()
try:
    for line in f:
        cmd = StrToList(line.split('#')[0])
        if len(cmd) == 0:
            continue
        print ":: Query: CMD:  " + ListToStr(cmd)
        resp, sw1, sw2 = connection.transmit(cmd)
        resp = (resp + [sw1, sw2])
        print ":: Query: RESP: " + ListToStr(resp)    

except:
    print "exception caught"
print ":::: end of script"
