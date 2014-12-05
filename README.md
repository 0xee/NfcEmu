NfcEmu
======

SDR/FPGA-based NFC/RFID Emulator

This project resembles the codebase created in the context of my
master's thesis at the University of Applied Sciences Upper Austria.

Though it is in principle working, the project might need some cleanup
to be useful for others.

The FPGA design was developed for the Saxo Q board from knjn.com.
To make it work with any other Board the peripheral
controllers (ADC, DAC, USB-FIFO), have to be adapted.


Features:
---------
 - Emulation of ISO-14443A PICCs in 106kbit/s mode, including UID emulation
 - Sniffing of data from ISO-14443A PICCs and PCDs
 - Emulation of APDU based smartcards using a card model (running on
   either the built in softcore CPU or on the host system) 
 - Integrated softcore CPU (8051) to enable quick prototyping
 - Python/C++ APIs to control the device over USB
 - Example scripts for Sniffing, Relaying and others
 - Reading ADC data at 27.12 Msps
 - Emulation backends using PC/SC readers, file replay or [Android Phones](https://github.com/NFCsecurity/NFCrelaying)
 
 
Acknowledgements:
-----------------
 
This project uses a modified and reduced version of the T51 core from Opencores.org, 
as well as the OSVVM verification libraries
