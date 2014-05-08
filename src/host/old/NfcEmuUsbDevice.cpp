 /**
 * @file   NfcEmuUsbDevice.c
 * @author Lukas Schuller
 * @date   Fri Aug 23 13:10:52 2013
 * 
 * @brief  
 * 
 */

#include "NfcEmuUsbDevice.h"
#include <iostream>
#include "NfcConstants.h"
#include "NfcEmuException.h"
#include "IntelHexFile.h"
#include "NfcEmuPacket.h"

using namespace std;

NfcEmuUsbDevice::NfcEmuUsbDevice(std::string const & fx2FwFile) {
    Open(fx2FwFile);   
}

bool NfcEmuUsbDevice::CheckFx2Fw() {
    if(!fx2.IsConnected()) return false;
    try {
        unsigned char c = FX2_POLL_FW;
        int ret = fx2.BulkWrite(1, (unsigned char *)&c, 1);
        //cout << "checkfw: write: " << ret << endl;
        if(ret != 1) {
            return false;
        }
        usleep(10000);
        ret = fx2.BulkRead(0x81, (unsigned char *)&c, 1);
        //cout << "checkfw: read: " << ret << endl;
        return (ret == 1) && (c == FX2_FW_OK);
    } catch(UsbException e) {
        return false;
    }
}



bool NfcEmuUsbDevice::Open(std::string const & fx2FwFile) {
    int ret;
    
    if(!fx2.IsConnected()) {
        return false;
    }
    
    if(CheckFx2Fw()) {
        cout << "Found FX2 with valid bridge firmware" << endl;
    }
    else {
        cout << ":: Updating FX2 firmware" << endl;
        try {
            fx2.DownloadFirmware(fx2FwFile);
        } catch (UsbException & e) {
            cerr << ":: Error downloading firmware to FX2: " << e.what() << endl;
            throw(NfcEmuException("communication error"));
        }
    }    

    return ResetFpga();
}

bool NfcEmuUsbDevice::ResetFpga() {
    unsigned char buf[1<<10];
    buf[0] = FX2_RESET_FPGA;
    int ret = fx2.BulkWrite(0x01, buf, 1);
    do {        
        ret = Read(buf, sizeof(buf));        
        usleep(10000);
    } while(ret > 0);

}


bool NfcEmuUsbDevice::IsOpen() const {
    return fx2.IsConnected();
}

bool NfcEmuUsbDevice::Close() {
    ResetFpga();
}

int NfcEmuUsbDevice::Read(unsigned char * buf, size_t const maxLen) {        
        int const epIn = 0x86;        
        int ret = 0;
        int rec = 0;
        do {
            ret = fx2.BulkRead(epIn, buf+rec, maxLen); 
//            cout << "read: ret = " << ret << endl;
            rec += ret;
        } while(ret > 0 && rec < maxLen);
//        cout << "read return" << endl;
        return rec;
}


int NfcEmuUsbDevice::Write(unsigned char const * buf, size_t const len) {
         int const epOut = 0x02;
         size_t sent = 0;
         while(sent < len) {
             int ret = fx2.BulkWrite(epOut, buf, len);
             if(ret < 0) {                 
                 return ret;
             }
             sent += ret;
         }
         return sent;
 }
