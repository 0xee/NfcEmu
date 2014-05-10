/**
 * @file   UsbService.cpp
 * @author Lukas Schuller
 * @date   Tue Nov  5 23:44:17 2013
 * 
 * @brief  
 * 
 */


#include "UsbService.h"
#include <iostream>
#include <libusb.h>
#include <boost/asio.hpp>
#include "Debug.h"
#include <exception>
#include "Util.h"
using namespace boost::asio;
using namespace std;
using namespace Util;


namespace Usb {
    static bool constexpr xferDbg = false;

    Service::Service() : mPollingRun(true) {        
        int ret = libusb_init(&pContext);
        libusb_set_debug(pContext, 3);
        if(ret) throw Error(ret, "initializing libusb context");
        pPollThread = std::unique_ptr<std::thread>(new std::thread(PollThreadFn));
    }


    Service & Service::Instance() {
        static std::unique_ptr<Service> pInstance = nullptr;
        if(!pInstance) {
            pInstance = std::unique_ptr<Service>(new Service);
        }
        return *pInstance;
    }


    DeviceHandle Service::OpenDevice(int const vId,
                                     int const pId, 
                                     int const index) {
        ScopedLock critical(Instance().mMtx);
        DeviceHandle dev = libusb_open_device_with_vid_pid(Context(), vId, pId);
        if(!dev) throw Error("opening the usb device");
        Instance().mOpenDevices.push_back(dev);
        return dev;
    }


    void Service::CloseDevice(DeviceHandle dev) {
        ScopedLock critical(Instance().mMtx);
        if(!dev) {
            throw(Error("trying to disconnect unconnected device"));
        }
        libusb_close(dev);
        Instance().mOpenDevices.remove(dev);
    }

    void Service::ReleaseInterface(DeviceHandle dev, int const interface) {
        ScopedLock critical(Instance().mMtx);
        int ret = libusb_release_interface(dev, interface);       
        if(ret) throw Error(ret, "releasing usb interface");
    }

    void Service::ClaimInterface(DeviceHandle dev, int const interface, int const altSetting) {
        ScopedLock critical(Instance().mMtx);
        int ret = libusb_detach_kernel_driver(dev, interface);
        switch(ret) {
        case 0: // detached successfully
        case LIBUSB_ERROR_NOT_FOUND: // no kernel driver attached, no error
            break;
        default:
            throw Error(ret, "Error detaching kernel driver");
            break;
        }
        
        ret =  libusb_claim_interface(dev, interface);
        if(ret) {
            throw Error(ret, "Could not claim interface");
        }
        ret =  libusb_set_interface_alt_setting(dev, interface, altSetting);
        if(ret) {
            throw Error(ret, "Could not set alt interface");
        }   
    }

    void Service::CancelTransfer(Transfer xfer) {
        libusb_cancel_transfer(xfer);
        Instance().mCancelSuccess = false;
        Instance().mActiveTransfers.erase(xfer); 
        //cout << "destroying work object (cancelled)" << endl;
        Instance().mActiveServices.erase(xfer); 

        
        //cout << "canceled transfer" << endl;
    }

    void Service::CancelByDevice(Device & dev) {
        ScopedLock critical(Instance().mMtx);
        //cout << "Device cancels xfer" << endl;
        auto ii = Instance().mActiveTransfers.begin(); 
        while(ii != Instance().mActiveTransfers.end()) {
            
            if(ii->second == &dev) {
                auto toDelete = ii++;
                CancelTransfer(toDelete->first);
                Instance().mCancelCv.wait(critical, []{return Service::Instance().mCancelSuccess;});
            } else {
                ++ii;
            }
            
        }

    }

    Service::~Service() {
        Info("Shutting down USB service");
        // cancel active transfers
        int cancelled = 0;
        {
            ScopedLock critical(Instance().mMtx);
            while(mActiveTransfers.size()) {
                CancelTransfer(mActiveTransfers.begin()->first);
                Instance().mCancelCv.wait(critical, []{return Service::Instance().mCancelSuccess;});
                ++cancelled;
            }

        }
        Warning("cancelled " + lexical_cast<string>(cancelled) + " pending libusb transfers");

        {
            ScopedLock critical(mMtx);
            mPollingRun = false;
        }
        pPollThread->join();

        Info("Joined libusb polling thread");

        // clean up orphaned devices
        if(mOpenDevices.size()) {
            int c = 0;
            for(auto ii = mOpenDevices.begin(); ii != mOpenDevices.end(); ++ii) {
                cout << "closing orphaned handle: " << *ii << endl;
                libusb_close(*ii);
            }
            mOpenDevices.clear();
        }

        

        //cout << ":: Exiting libusb context" << endl;         
        libusb_exit(pContext);
        pContext = 0;

    }

    void Service::AsyncBulkRead(Device & dev, int const ep,
                                boost::asio::mutable_buffer buffer) throw(Error) {

        Transfer pT1(libusb_alloc_transfer(0));
        Transfer pT2(libusb_alloc_transfer(0));
        auto pBuf = buffer_cast<unsigned char *>(buffer);

        libusb_fill_bulk_transfer(pT1, dev.GetDeviceHandle(), ep, pBuf, 
                                  buffer_size(buffer), &Service::LibusbAsyncCallback, 
                                  0, 10000000);
        Instance().Submit(pT1, dev);
    }


    void Service::Submit(Transfer const & p, Device & dev, bool const resubmit) {
        ScopedLock critical(mMtx);

//        cout << "Submitting transfer" << endl;
        if(!resubmit) {
            mActiveTransfers[p] = &dev;
            //cout << "creating work object" << endl;
            mActiveServices[p] = WorkPtr(new io_service::work(dev.IoService()));
        }
        int ret;
        try {
            if((ret = libusb_submit_transfer(p))) {
                throw Error(ret, "submitting bulk transfer");
            }
        }
        catch(Error e) {
            throw e;
        } catch(std::exception e) {
            Error(string("Error submitting bulk transfer: ") + e.what());
            throw e;
        }
        if(xferDbg) cout << ":: Submitted transfer " << p << endl;
    }
        

    void Service::PollThreadFn() {
        Info("Usb event polling thread started"); 
        try {
            struct timeval pollTimeout = { .tv_sec = 0, .tv_usec = 10000};
            bool run = true;
            do {
                {
                    ScopedLock critical(Instance().mMtx);
//                    cout << "polling" << endl;
                    int ret = libusb_handle_events_timeout_completed(Context(), &pollTimeout, 0);
                    run = Instance().mPollingRun;
                }
                usleep(1);
            } while(run);
            Info("Polling thread exit");
        } catch(Error & e) {
            Fatal("USB error caught in polling thread: " + e.code().message() +
                  + " " + e.what());
        } catch(exception & e) {
            Fatal(string("Exception caught in polling thread: ") + e.what());
        } 

    }

    void Service::LibusbAsyncCallback(Transfer t) noexcept {
        //D("libusb callback");
        // this function is called by the polling thread in a context locked with mMtx 
        switch(t->status) {

        case LIBUSB_TRANSFER_CANCELLED:            
            Instance().mCancelSuccess = true;
            Instance().mCancelCv.notify_one();
            //cout << "transfer cancelled successfully" << endl;
            break;
            
        case LIBUSB_TRANSFER_COMPLETED:
            // expected cases
            if(xferDbg) cout << "transfer completed: " << t << endl;
            { 
                auto devIter = Instance().mActiveTransfers.find(t);
                if(devIter != Instance().mActiveTransfers.end()) {
                    //D("transfer complete");
                    devIter->second->AsyncCallback(t->actual_length);
                    Instance().mActiveTransfers.erase(t); 
                    //cout << "destroying work object" << endl;
                    Instance().mActiveServices.erase(t); 
                    //cout << "active: " << Instance().mActiveServices.size() << endl;
                }           
                break;
            }

        case LIBUSB_TRANSFER_TIMED_OUT:
            cout << ":: Async transfer timed out, resubmitting" << endl;
            Instance().Submit(t, *Instance().mActiveTransfers[t], true);
            break;

        default:
            Error("Error in async libusb transfer");
            throw Usb::Error("in async libusb transfer");
            
        }

        
        libusb_free_transfer(t);
    }


    size_t Service::BulkRead(DeviceHandle dev, int const ep,
                             boost::asio::mutable_buffer buffer,
                             size_t const timeout) throw(Error) {
        ScopedLock critical(Instance().mMtx);
        int transferred = 0;
        auto pBuf = buffer_cast<unsigned char *>(buffer);
        size_t maxLen = buffer_size(buffer);
        int ret = libusb_bulk_transfer(dev, ep | 0x80, pBuf, maxLen, &transferred, timeout);
        if(transferred > 0 || ret == LIBUSB_ERROR_TIMEOUT) return transferred;
        throw Error(ret, "in BulkRead");
    }

    void Service::BulkWrite(DeviceHandle dev, int const  ep,
                            boost::asio::const_buffer buffer, 
                            size_t const timeout) throw(Error) {
        size_t sent = 0;
        auto pBuf = const_cast<unsigned char *>(buffer_cast<unsigned char const *>(buffer));
        while(sent < buffer_size(buffer)) {
            int transferred = 0;
            int ret = libusb_bulk_transfer(dev, ep, 
                                           pBuf+sent,
                                           buffer_size(buffer)-sent, &transferred, timeout);
            if(transferred) {
                sent += transferred;
            } else {
                throw Error(ret, "error in bulkwrite");
            }
        
        }
    }

    void Service::ControlMessage(DeviceHandle dev, 
                                 unsigned char const requestType,
                                 unsigned char const request,
                                 unsigned short const value,
                                 unsigned short const index,
                                 unsigned char * pData,
                                 unsigned short length) {
        ScopedLock critical(Instance().mMtx);
        int ret = libusb_control_transfer(dev, requestType, request,
                                          value, index, pData, length, 100);
        if(ret < 0) {
            throw Error(ret, "error in ControlMessage");
        }
    }



}
