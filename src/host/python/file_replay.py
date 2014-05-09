#!/bin/python

import socket
from contextlib import closing
import sys
import string

def StrToList(s):
    return [b for b in bytearray.fromhex(s.strip())]

def ListToStr(l):
    return ' '.join('%02x' % b for b in l) 

idx = 0
if len(sys.argv) > 1:
    fileName = sys.argv[1]
else:
    raise "No replay file specified"

replayFile = open(fileName)

uid = replayFile.readline().upper()
print "UID: "

cmdMap = dict()

with closing(replayFile) as f:
    for line in f:
        cleaned = line.split('#')[0].split(':')
        cleaned = map(string.strip, cleaned)
        if len(cleaned) == 2:
            cmd = cleaned[0].upper()
            resp = string.join(cleaned[1].upper().split(), '')
            cmdMap[cmd] = resp
            print cmd.ljust(40) + ' --> ' + resp
            
cs = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
cs.connect(('localhost', 1337))
cs.send(uid)

with closing(cs.makefile()) as cmds:
    for cmd in cmds:
        if len(cmd) == 0:
            continue
        cmd = cmd.strip().upper()
        print "CMD:  " + cmd
        if cmd in cmdMap:
            resp = cmdMap[cmd]
        else:
            resp = [0x6A, 0x82]
        print "RESP: " + resp
        
        cs.send(resp + '\n')
        
