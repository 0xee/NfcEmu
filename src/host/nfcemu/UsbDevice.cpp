/**
 * @file   UsbDevice.cpp
 * @author Lukas Schuller
 * @date   Sat Aug 31 19:55:19 2013
 * 
 * @brief  
 * 
 */

#include "UsbService.h"
#include <iostream>
#include <cassert>
#include "Debug.h"

using namespace std;
using namespace boost::asio;

namespace Usb {

    Device::Device(boost::asio::io_service & io,
                   int const vId, int const pId,
                   int const iface, int const alt) : mIoService(io), 
                                                     interface(iface), 
                                                     altSetting(alt) {
        mDev = Service::OpenDevice(vId, pId, 0);
        Service::ClaimInterface(mDev, interface,altSetting);
    }

    Device::~Device() {        
        CancelAsync();
        Service::ReleaseInterface(mDev, interface);
        Service::CloseDevice(mDev);

    }

    bool Device::IsConnected() const {
        return mDev;
    }

    void Device::AsyncBulkRead(int const ep, boost::asio::mutable_buffer buffer, 
                               ReadCallback::slot_type & callback) throw(Error) {
        //D("bulkread");
        mBulkReadCallback.disconnect_all_slots();
        mBulkReadCallback.connect(callback);
        Service::AsyncBulkRead(*this, ep, buffer);
    }

    void Device::AsyncIsoRead(int const ep, boost::asio::mutable_buffer buffer, 
                               ReadCallback::slot_type & callback) throw(Error) {
        mIsoReadCallback.disconnect_all_slots();
        mIsoReadCallback.connect(callback);
        Service::AsyncIsoRead(*this, ep, buffer);
    }

    void Device::CancelAsync() {
        mBulkReadCallback.disconnect_all_slots();
        Service::CancelByDevice(*this);
    }

    size_t Device::BulkRead(int const ep,
                         boost::asio::mutable_buffer buffer,
                         size_t const timeout) throw(Error) {
        return Service::BulkRead(mDev, ep, buffer, timeout);
    }
    size_t Device::IntRead(int const ep,
                         boost::asio::mutable_buffer buffer,
                         size_t const timeout) throw(Error) {
        return Service::IntRead(mDev, ep, buffer, timeout);
    }

    void Device::BulkWrite(int const  ep, boost::asio::const_buffer buffer, 
                             size_t const timeout) throw(Error) {
        if(!IsConnected()) {
            throw runtime_error("not connected");
        }
        Service::BulkWrite(mDev, ep, buffer, timeout);
    }

    void Device::IsoWrite(int const  ep, boost::asio::const_buffer buffer, 
                             size_t const timeout) throw(Error) {
        if(!IsConnected()) {
            throw runtime_error("not connected");
        }
        Service::IsoWrite(mDev, ep, buffer, timeout);
    }
    void Device::IntWrite(int const  ep, boost::asio::const_buffer buffer, 
                             size_t const timeout) throw(Error) {
        if(!IsConnected()) {
            throw runtime_error("not connected");
        }
        Service::IntWrite(mDev, ep, buffer, timeout);
    }

    int Device::ControlMessage(unsigned char const requestType,
                                  unsigned char const request,
                                  unsigned short const value,
                                  unsigned short const index,
                                  unsigned char * pData,
                                  unsigned short length) throw(Error) {


        Service::ControlMessage(mDev, requestType, request,
                                value, index, pData, length);


        int ret = libusb_control_transfer(mDev, requestType, request,
                                          value, index, pData, length, 100);
        if(ret < 0) {
            throw Error(ret, "error in ControlMessage");
        }
        return ret;

    }

} // namespace Usb
