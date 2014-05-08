/*
 * cycfx2dev.h - Cypress FX2 device class: low-level routines. 
 * 
 * Copyright (c) 2006--2009 by Wolfgang Wieser ] wwieser (a) gmx <*> de [ 
 * 
 * This file may be distributed and/or modified under the terms of the 
 * GNU General Public License version 2 as published by the Free Software 
 * Foundation. (See COPYING.GPL for details.)
 * 
 * This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
 * WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 * 
 */

#ifndef _CYCFX2PROG_CYCFX2DEVICE_
#define _CYCFX2PROG_CYCFX2DEVICE_ 1

#include <usb.h>


extern struct usb_device *USBFindDevice(const char *bus,const char *dev);
extern struct usb_device *USBFindDevice(int vendor,int product,int nth=0);


class CypressFX2Device
{
private:
    struct usb_device *usbdev;
    struct usb_dev_handle *usbhdl;
		
    // Force a certail "alt" interface; -1 for none.
    int force_alt_interface;
		
    // Internally used: Program one line of an Intel HEX file. 
    // The arguments path and line are just needed for error reporting. 
    int _ProgramIHexLine(const char *buf,const char *path,int line);
    int OpenDevice(struct usb_device *_usbdev);
private:
    CypressFX2Device(const CypressFX2Device &);
    void operator=(const CypressFX2Device &);
public:
    CypressFX2Device() {
        usb_init();
        usbdev=NULL;  
        usbhdl=NULL;
        force_alt_interface=-1;
        usb_find_busses();
        usb_find_devices();
    }
    ~CypressFX2Device()
        {  Close(); }
		
    // Is opened?
    inline bool IsOpen() const
        {  return(usbhdl);  }
		
    // Open usb device; will close previous one. 
    // Returns 0 on success; 1 on error. Errors written to stderr. 

    int Open(int const devNum = 0);
		
    // Close device. Returns 0 on success. Errors written to stderr. 
    int Close();
    
    bool CheckFw();

    void FlushInputBuffer(unsigned int const epIn);		
    // Read an intel hex file and download it. 
    // Returns 0 on success; 1 on error. Errors written to stderr. 
    int ProgramIHexFile(const char *path);
    // Like ProgramIHexFile() but Intel HEX is supplied as NULL-terminated 
    // array of strings; each line of the hex file as string element. 
    int ProgramStaticIHex(const char **ihex);
    // Read a flat binary file and download it. 
    int ProgramBinFile(const char *path,size_t start_addr=0);
    // Download/write a chunk of ram into the device. 
    int WriteRAM(size_t addr,const unsigned char *data,size_t nbytes);
    // Read a portion of ram from the device. 
    int ReadRAM(size_t addr,unsigned char *data,size_t nbytes);
		
    // Put the Cypress FX2 into reset or release reset. 
    // running=1 -> running; running=0 -> reset. 
    int FX2Reset(bool running);

    // Reset fpag and synchronize FIFOs
    void ResetFpga();

		
    // Read from endpoint. 
    // type: 'b','B' -> bulk; 'i','I' -> interrupt
    //       Capital letters mean that data may be shorter than expected. 
    // endpoint must be address (like 0x86 for EP 6 in). 
    // Returns number of read bytes. See source comment!!
    int BlockRead(int endpoint,unsigned char *buf,size_t nbytes,
                  char type='b');
    // Counterpart for BlockRead; type is 'b' or 'i' but not 'B'/'I'. 
    int BlockWrite(int endpoint,const unsigned char *buf,size_t nbytes,
                   char type='b');
    // Returns number of written bytes. See source comment!!
		
    // Benchmark block (bulk/interrupt) reading. 
    // type: 'b' -> bulk; 'i' -> interrupt
    // endpoint must be address (like 0x86 for EP 6 in). 
    int BenchBlockRead(int endpoint,size_t nbytes,size_t chunk_size,
                       char type='b');
		
    // Set the alt interface to use at next block read/write. 
    // Use -1 for automatic FX2-default values. 
    int ForceAltInterface(int alt_if=-1)
        {  force_alt_interface=alt_if;  return(0);  }
		
    // Send a USB control message. 
    int CtrlMsg(unsigned char requesttype,
                unsigned char request,int value,int index,
                const unsigned char *ctl_buf=NULL,size_t ctl_buf_size=0);
};

#endif  /* _CYCFX2PROG_CYCFX2DEVICE_ */
