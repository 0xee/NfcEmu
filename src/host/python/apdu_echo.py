#!/bin/python

import socket
from contextlib import closing
import sys
import string

uid = "DEADBEEF\n"
print "UID: " + uid

cs = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
cs.connect(('localhost', 1337))
cs.send(uid)

with closing(cs.makefile()) as cmds:
    for cmd in cmds:
        if len(cmd) == 0:
            continue
        cmd = cmd.strip().upper()
        print ":: Backend CMD:  " + cmd
        resp = cmd
        print ":: Backend RESP: " + resp        
        cs.send(resp + '\n')
        
