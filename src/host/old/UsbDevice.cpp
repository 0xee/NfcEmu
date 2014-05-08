/**
 * @file   UsbDevice.cpp
 * @author Lukas Schuller
 * @date   Sat Aug 31 19:55:19 2013
 * 
 * @brief  
 * 
 */

#include "UsbDevice.h"

#include <iostream>
using namespace std;

libusb_context * UsbDevice::pContext = 0;
size_t UsbDevice::contextRefCount = 0;
list<libusb_device_handle*> UsbDevice::openHandles;

UsbDevice::UsbDevice(int const vId, int const pId,
                     int const iface, int const alt) : interface(iface), 
                                                       altSetting(alt) {
    ++contextRefCount;
    Connect(vId, pId);
}

void UsbDevice::Connect(int const vId,
                        int const pId) {
   
    pDevHandle = libusb_open_device_with_vid_pid(GetUsbContext(), vId, pId);
    if(!pDevHandle) throw UsbException("Unable to open the device");
    openHandles.push_back(pDevHandle);
    int ret =  libusb_detach_kernel_driver(pDevHandle, interface);
    switch(ret) {
    case 0: // detached successfully;        
    case LIBUSB_ERROR_NOT_FOUND: // no kernel driver attached 
        break;
    default:
        throw UsbException("Error detaching kernel driver");
        break;
    }

    ret =  libusb_claim_interface(pDevHandle, interface);
    if(ret) {
        throw UsbException("Could not claim interface");
    }
    ret =  libusb_set_interface_alt_setting(pDevHandle, interface, altSetting);
    if(ret) {
        throw UsbException("Could not set alt interface");
    }   
}

UsbDevice::~UsbDevice() {
    Disconnect();
    --contextRefCount;
    if(!contextRefCount) {
        // clean up orphaned devices
        int c = 0;
        for(auto ii = openHandles.begin(); ii != openHandles.end(); ++ii) {
            cout << "closing orphaned handle: " << *ii << endl;
            libusb_close(*ii);
        }
        openHandles.clear();
        cout << ":: Destroying last Fx2 instance, closed " << c << " devices, exiting libusb context" << endl; 
        libusb_exit(pContext);
        pContext = 0;
    }
}

void UsbDevice::Disconnect() {
    if(!pDevHandle) {
        throw(UsbException("trying to disconnect unconnected device"));
    }
    libusb_release_interface(pDevHandle, interface);
    libusb_close(pDevHandle);      
    openHandles.remove(pDevHandle);
    pDevHandle = 0;
}

libusb_context * UsbDevice::GetUsbContext() {
        if(!pContext) {
            libusb_init(&pContext);
        }
        return pContext;
    }   


bool UsbDevice::IsConnected() const {
    return pDevHandle != 0;
}

int UsbDevice::BulkRead(int const ep, unsigned char * pBuf, size_t const maxLen) {
    if(!IsConnected()) {
        throw UsbException("not connected");
    }
    int transferred = 0;
    int ret = libusb_bulk_transfer(pDevHandle, ep | 0x80, pBuf, maxLen, &transferred, 1);
    if(transferred > 0 || ret == LIBUSB_ERROR_TIMEOUT) return transferred;
    throw UsbException(libusb_error_name(ret));
}

int UsbDevice::BulkWrite(int const  ep, unsigned char const * pBuf, size_t const len) {
    if(!IsConnected()) {
        throw UsbException("not connected");
    }

    size_t sent = 0;
    while(sent < len) {
        int transferred = 0;
        int ret = libusb_bulk_transfer(pDevHandle, ep, 
                                       const_cast<unsigned char*>(pBuf)+sent,
                                       len-sent, &transferred, 10);
        if(transferred) {
            sent += transferred;
        } else {
            throw UsbException(libusb_error_name(ret));
        }
        
    }
    return sent;
}

int UsbDevice::ControlMessage(unsigned char const requestType,
                              unsigned char const request,
                              unsigned short const value,
                              unsigned short const index,
                              unsigned char * pData,
                              unsigned short length) {
    if(!IsConnected()) {
        throw UsbException("not connected");
    }

    int ret = libusb_control_transfer(pDevHandle, requestType, request,
                            value, index, pData, length, 100);
    if(ret < 0) {
        throw UsbException(libusb_error_name(ret));
    }
    return ret;

}
