/**
 * @file   CypressFx2.h
 * @author Lukas Schuller
 * @date   Sat Aug 31 19:14:47 2013
 * 
 * @brief  Cypress FX2 userspace driver
 * 
 */

#ifndef CYPRESSFX2_H
#define CYPRESSFX2_H

#include <string>

#include "UsbDevice.h"

class CypressFx2 : public UsbDevice {

public:
    CypressFx2(int const vId = defaultVendorId,
               int const pId = defaultProductId);
    virtual ~CypressFx2();
    
    
    void DownloadFirmware(std::string const & fwFile);
    

private:
    libusb_context * GetUsbContext();

    void WriteRam(size_t const addr, unsigned char const * pData, size_t const len);
    void SetReset(bool const run);
    
    static int const defaultVendorId = 0x04b4;
    static int const defaultProductId = 0x8613;
    static int const defaultInterface = 0;
    static int const defaultAltSetting = 1;
    static libusb_context * pContext;
    static size_t contextRefCount;
    libusb_device_handle * pDevHandle;
};

#endif /* CYPRESSFX2_H */
