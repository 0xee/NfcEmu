/**
 * @file   NfcEmuUsbDevice.h
 * @author Lukas Schuller
 * @date   Fri Aug 23 13:07:19 2013
 * 
 * @brief  Implements a NfcEmuDevice working on the usb hardware
 * 
 */

#ifndef NFCEMUUSBDEVICE_H
#define NFCEMUUSBDEVICE_H

#include "NfcEmuDevice.h"
#include "cycfx2dev.h"
#include "CypressFx2.h"

class NfcEmuUsbDevice : public NfcEmuDevice {

public:
    NfcEmuUsbDevice(std::string const & fx2FwFile);

    ~NfcEmuUsbDevice() { Close(); }

    bool Open(std::string const & fx2FwFile);

    bool Close();
    int Read(unsigned char * buf, size_t const maxLen);
    int Write(unsigned char const * buf, size_t const len);
    bool IsOpen() const;
    void UpdateT51(std::string const & fwFile);

protected:    

    bool ResetFpga();
    bool CheckFx2Fw();

private:
    NfcEmuUsbDevice();
    NfcEmuUsbDevice(NfcEmuUsbDevice &);
    NfcEmuUsbDevice & operator=(NfcEmuUsbDevice &);

    CypressFx2 fx2;

};

#endif /* NFCEMUUSBDEVICE_H */
