#!/bin/bash

SOF=../../vhdl/grpNfc/unitTbdNfcEmu/synlay/TbdNfcEmu.sof

quartus_pgm --cable="USB-Blaster" -m JTAG -o "p;$SOF"
