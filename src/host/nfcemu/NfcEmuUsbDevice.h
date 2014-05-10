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

#define LOCK_SCOPE Util::ScopedLock critical(mMtx)


namespace NfcEmu {

    class UsbDevice : public Device {

    public:
        UsbDevice(boost::asio::io_service & io,
                        std::string const & fx2FwFile);

        ~UsbDevice() { 
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
            StartAsyncRead2(0);
        }
        void StartAsyncRead2(size_t const buffer = 0) {
            /// @todo: protect usb device on reentrance
            if(buffer == 1 || buffer == 0) {
                Usb::Device::ReadCallback::slot_type slot =
                    boost::bind(&UsbDevice::ReadCallback1, this, _1);
                fx2.AsyncBulkRead(0x86, boost::asio::buffer(mReadBuf1, mReadBuf1.size()), slot);
            }
            if(buffer == 2 || buffer == 0) {
                Usb::Device::ReadCallback::slot_type slot =
                    boost::bind(&UsbDevice::ReadCallback2, this, _1);
                fx2.AsyncBulkRead(0x86, boost::asio::buffer(mReadBuf2, mReadBuf1.size()), slot);
            }

            //std::cout << "start async read" << std::endl;

        }

    private:
        UsbDevice();
        UsbDevice(UsbDevice &);
        UsbDevice & operator=(UsbDevice &);


        void ReadCallback1(size_t nRead) {
            LOCK_SCOPE;
            //D("read callback: " + std::to_string(nRead));
            if(nRead) {
                copy(mReadBuf1.begin(), mReadBuf1.begin()+nRead, back_inserter(mPacketBuf));
                //std::cout << "Read cb: " << Util::FormatHex(mReadBuf.begin(), mReadBuf.begin()+nRead) << std::endl;
                OnRx();
            }
            StartAsyncRead2(1);
        }

        void ReadCallback2(size_t nRead) {
            LOCK_SCOPE;
            //D("read callback: " + std::to_string(nRead));
            if(nRead) {
                copy(mReadBuf2.begin(), mReadBuf2.begin()+nRead, back_inserter(mPacketBuf));
                //std::cout << "Read cb: " << Util::FormatHex(mReadBuf.begin(), mReadBuf.begin()+nRead) << std::endl;
                OnRx();
            }
            StartAsyncRead2(2);
        }

        std::vector<unsigned char> mReadBuf1, mReadBuf2;
        std::mutex mMtx;
        CypressFx2 fx2;
    
    };
}
#endif /* NFCEMUUSBDEVICE_H */
