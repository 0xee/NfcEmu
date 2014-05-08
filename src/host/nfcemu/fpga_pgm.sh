#!/bin/bash


SOF=$1

quartus_pgm --cable="USB-Blaster" -m JTAG -o "p;$SOF"
