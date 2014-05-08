/**
 * @file   CypressFx2.cpp
 * @author Lukas Schuller
 * @date   Sat Aug 31 19:55:19 2013
 * 
 * @brief  
 * 
 */

#include "CypressFx2.h"

#include <iostream>
#include <iomanip>
#include <cstdlib>
#include "IntelHexFile.h"

using namespace std;

libusb_context * CypressFx2::pContext = 0;
size_t CypressFx2::contextRefCount = 0;

CypressFx2::CypressFx2(int const vId, int const pId) :
    UsbDevice(vId, pId, defaultInterface, defaultAltSetting) { }

CypressFx2::~CypressFx2() { }

void CypressFx2::DownloadFirmware(string const & fwFile) { 
    cout << fwFile << endl;
    SetReset(false);
    IntelHexFile ihex(fwFile);
    for(auto line = ihex.Begin(); line != ihex.End(); ++line) {
        WriteRam(line->address, line->data.data(), line->data.size());        
    }
    SetReset(true);
}

void CypressFx2::SetReset(bool const run) {
    size_t const resetAddr = 0xe600;
    unsigned char value = run ? 0 : 1;
    WriteRam(resetAddr, &value, 1);
}

void CypressFx2::WriteRam(size_t const addr, unsigned char const * pData, size_t const len) {
    if(!IsConnected()) {
        throw UsbException("not connected");
    }
    size_t written = 0;
    while(written < len) {
        int ret = ControlMessage(0x40, 0xA0, addr+written, 0, 
                       const_cast<unsigned char*>(pData)+written, 
                       len-written);
        written += ret;
    }    
}
