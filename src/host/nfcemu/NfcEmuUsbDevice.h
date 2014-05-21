/**
 * @file   UsbStreamDevice.h
 * @author Lukas Schuller
 * @date   Fri Aug 23 13:07:19 2013
 * 
 * @brief  Implements a NfcEmuDevice working on the usb hardware
 * 
 */

#ifndef NFCEMUUSBDEVICE_H
#define NFCEMUUSBDEVICE_H

#include "NfcEmuDevice.h"
#include "CypressFx2.h"
#include <boost/asio.hpp>
#include "Util.h"
#include "Debug.h"
#include <atomic>

#define LOCK_SCOPE Util::ScopedLock critical(mMtx)


namespace NfcEmu {

    class UsbDevice : public Device {

    public:
        UsbDevice(boost::asio::io_service & io,
                        std::string const & fx2FwFile);

        ~UsbDevice() { 
            mCanContinue.store(false);
            //std::cout << "usb device dtor" << std::endl;
            Close();
        }

        bool Open(std::string const & fx2FwFile);

        bool Close();
        size_t Read(boost::asio::mutable_buffer buf);
        void Write(boost::asio::const_buffer buf);

        void StopReceive() {
            fx2.CancelAsync();
            mpWork.reset(nullptr);
        }

        void Accept(DeviceVisitor & visitor) {
            visitor.Visit(*this);
        }

    protected:    

        bool ResetFpga();
        bool CheckFx2Fw();
        bool IsOpen() const;

        void StartAsyncRead() {
            Usb::Device::ReadCallback::slot_type slot =
                boost::bind(&UsbDevice::ReadCallback, this, _1);
            fx2.AsyncBulkRead(0x86, boost::asio::buffer(mReadBuf, mReadBuf.size()), slot);
            //std::cout << "start async read" << std::endl;
        }

    private:
        UsbDevice();
        UsbDevice(UsbDevice &);
        UsbDevice & operator=(UsbDevice &);


    void ReadCallback(size_t nRead) {
        if(mCanContinue.load()) {
            LOCK_SCOPE;
            //D("read callback: " + std::to_string(nRead));
            if(nRead) {
                //D(std::string("rx: ") + Util::FormatHex(mReadBuf1.begin(), mReadBuf1.begin()+nRead));
                copy(mReadBuf.begin(), mReadBuf.begin()+nRead, back_inserter(mPacketBuf));
                OnRx();
            }
            StartAsyncRead();
        }
    }

    std::vector<unsigned char> mReadBuf;
    std::atomic<bool> mCanContinue;
    std::mutex mMtx;
    CypressFx2 fx2;
    
};
}
#endif /* NFCEMUUSBDEVICE_H */
