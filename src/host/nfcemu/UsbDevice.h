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

#include <list>
#include <boost/asio.hpp>
#include <boost/signals2.hpp>

#include "UsbTypes.h"

namespace Usb {

    class Device {

    public:
        typedef boost::signals2::signal<void (size_t const nRead)> ReadCallback;

        Device(boost::asio::io_service & io,
                  int const vId, int const pId, 
                  int const iface, int const alt);

        Device(Device const &) = delete;
        Device & operator=(Device const &) = delete;
        virtual ~Device();

        void Connect(int const vId, int const pId);
        void Disconnect();

        bool IsConnected() const;
    
        void AsyncBulkRead(int const ep, boost::asio::mutable_buffer buffer, 
                           ReadCallback::slot_type & callback) throw(Error);

        void AsyncIsoRead(int const ep, boost::asio::mutable_buffer buffer, 
                           ReadCallback::slot_type & callback) throw(Error);

        void CancelAsync();

        size_t BulkRead(int const ep,
                        boost::asio::mutable_buffer buffer,
                        size_t const timeout = 10) throw(Error);

        size_t IntRead(int const ep,
                        boost::asio::mutable_buffer buffer,
                        size_t const timeout = 10) throw(Error);


        void BulkWrite(int const ep, boost::asio::const_buffer buffer,
                       size_t const timeout = 0) throw(Error);
        void IntWrite(int const ep, boost::asio::const_buffer buffer,
                       size_t const timeout = 0) throw(Error);
        void IsoWrite(int const ep, boost::asio::const_buffer buffer,
                       size_t const timeout = 0) throw(Error);

        int ControlMessage(unsigned char const requestType,
                           unsigned char const request,
                           unsigned short const value,
                           unsigned short const index,
                           unsigned char * pData,
                           unsigned short length) throw(Error);
                       

        DeviceHandle & GetDeviceHandle() noexcept { return mDev; }
        boost::asio::io_service & IoService() { return mIoService; }

        void AsyncCallback(size_t const len) {
            mIoService.post(std::bind(&Device::CbDispatcher, this, len));
        }
        
    protected:
        void CbDispatcher(size_t const len) {            
            mReadCallback(len);
        }



        boost::asio::io_service & mIoService;
        /// @todo: enable multiple concurrent transfers (eg on different endpoints)
        ReadCallback mReadCallback;

    private:
        DeviceHandle mDev;
        int interface, altSetting;
        libusb_transfer mAsyncTransfer;
        static std::list<libusb_device_handle *> openHandles;

    };

} // namespace Usb

#endif

