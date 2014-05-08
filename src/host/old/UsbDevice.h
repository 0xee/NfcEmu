/**
 * @file   UsbDevice.h
 * @author Lukas Schuller
 * @date   Sat Aug 31 19:14:47 2013
 * 
 * @brief  generic base class for userspace drivers for usb devices
 * 
 */

#ifndef USBDEVICE_H
#define USBDEVICE_H

#include <libusb.h>
#include <list>
#include <exception>

class UsbException : public std::exception {
public:
    UsbException(const char * msg) : message(msg) { }
    virtual ~UsbException() throw() {}
    virtual char const * what() const throw() {
        return message;
    }
private:
    char const * message;
};

class UsbDevice {

public:
    UsbDevice(int const vId, int const pId, 
              int const iface, int const alt);
    virtual ~UsbDevice();

    void Connect(int const vId, int const pId);
    void Disconnect();

    bool IsConnected() const;
    
    int BulkRead(int const ep, unsigned char * pBuf, size_t const maxLen);
    int BulkWrite(int const ep, unsigned char const * pBuf, size_t const len);
    int ControlMessage(unsigned char const requestType,
                       unsigned char const request,
                       unsigned short const value,
                       unsigned short const index,
                       unsigned char * pData,
                       unsigned short length);
                       
                       
protected:

private:
    libusb_context * GetUsbContext();
    libusb_device_handle * pDevHandle;

    int interface, altSetting;

    static libusb_context * pContext;
    static std::list<libusb_device_handle *> openHandles;
    static size_t contextRefCount;
};

#endif
