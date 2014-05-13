/**
 * @file   UsbService.h
 * @author Lukas Schuller
 * @date   Tue Nov  5 23:08:01 2013
 * 
 * @brief  
 * 
 */


#ifndef USBSERVICE_H
#define USBSERVICE_H


#include <map>
#include <thread>
#include <list>
#include <boost/asio.hpp>
#include <mutex>
#include <condition_variable>
#include "UsbTypes.h"
#include "UsbDevice.h"

namespace Usb {

    class Service {
        

    public:
        ~Service();


        static void AsyncBulkRead(Device & dev, int const ep,
                                  boost::asio::mutable_buffer buffer) throw(Error);
        static void AsyncIsoRead(Device & dev, int const ep,
                                  boost::asio::mutable_buffer buffer) throw(Error);
        // static void AsyncIntRead(Device & dev, int const ep,
        //                           boost::asio::mutable_buffer buffer) throw(Error);
        
        static size_t BulkRead(DeviceHandle dev, int const ep,
                               boost::asio::mutable_buffer buffer,
                               size_t const timeout) throw(Error);
        static size_t IntRead(DeviceHandle dev, int const ep,
                               boost::asio::mutable_buffer buffer,
                               size_t const timeout) throw(Error);
        static void BulkWrite(DeviceHandle dev, int const  ep, boost::asio::const_buffer buffer, 
                              size_t const timeout) throw(Error);
        static void IntWrite(DeviceHandle dev, int const  ep, boost::asio::const_buffer buffer, 
                              size_t const timeout) throw(Error);
        static void IsoWrite(DeviceHandle dev, int const  ep, boost::asio::const_buffer buffer, 
                              size_t const timeout) throw(Error);

        static DeviceHandle OpenDevice(int const vid, int const pid, int const index);
        static void CloseDevice(DeviceHandle dev);

        static void ClaimInterface(DeviceHandle dev, int const interface, int const altSetting);
        static void ReleaseInterface(DeviceHandle dev, int const interface);

        static void CancelTransfer(Transfer xfer);
        static void CancelByDevice(Device & dev);
        static void ControlMessage(DeviceHandle dev,
                                   unsigned char const requestType,
                                   unsigned char const request,
                                   unsigned short const value,
                                   unsigned short const index,
                                   unsigned char * pData,
                                   unsigned short length);

    private:
        Service();

        static Service & Instance();

        static libusb_context * Context() { return Service::Instance().pContext; }

        static void PollThreadFn();
        static void LibusbAsyncCallback(libusb_transfer * pT) noexcept;
        static void LibusbAsyncTxCallback(libusb_transfer * pT) noexcept;
        void Submit(Transfer const & p, Device & dev, bool const resubmit = false);

        std::unique_ptr<std::thread> pPollThread;


        typedef std::unique_ptr<boost::asio::io_service::work> WorkPtr;
        std::map<Transfer, Device *> mActiveTransfers;
        std::map<Transfer, WorkPtr> mActiveServices;

        std::condition_variable mCancelCv;
        bool mCancelSuccess;

        libusb_context * pContext;
        std::list<DeviceHandle> mOpenDevices;

        std::mutex mMtx;
        bool mPollingRun;
        

    };
    

}

#endif /* USBSERVICE_H */
