 /**
 * @file   UsbStreamDevice.c
 * @author Lukas Schuller
 * @date   Fri Aug 23 13:10:52 2013
 * 
 * @brief  
 * 
 */

#include "NfcEmuUsbDevice.h"
#include <iostream>
#include "NfcConstants.h"
#include "Exception.h"
#include "IntelHexFile.h"
#include "NfcEmuPacket.h"
#include <unistd.h>
#include "Debug.h"
#include <thread>
#include <chrono>
using namespace boost::asio;
using namespace std;

namespace NfcEmu {

    UsbDevice::UsbDevice(boost::asio::io_service & io,
                   std::string const & fx2FwFile)  : Device(io), 
                                                     fx2(io), 
                                                     mCanContinue(true) {
        Open(fx2FwFile);   
        mReadBuf.resize(512);
    }

    bool UsbDevice::CheckFx2Fw() {
        if(!fx2.IsConnected()) return false;
        try {
            unsigned char c = FX2_POLL_FW;
            fx2.BulkWrite(1, const_buffer(&c, sizeof(c)), 100);
            return (fx2.BulkRead(0x81, buffer(&c, sizeof(c)), 10) == 1) && (c == FX2_FW_OK);
        } catch(Usb::Error e) {
            Error(string(e.code().message()) + " " + e.what());
            return false;
        }
    }

    bool UsbDevice::Open(std::string const & fx2FwFile) {
        int ret;
    
        if(!fx2.IsConnected()) {
            return false;
        }
    
        if(CheckFx2Fw()) {
            Info("Found FX2 with valid bridge firmware");
        }
        else {
            Warning("FX2 not responding, updating firmware");
            try {
                fx2.DownloadFirmware(fx2FwFile);
                if(!CheckFx2Fw()) {
                    Fatal("FX2 still not responding");
                }
            } catch (runtime_error & e) {
                Fatal("Error downloading firmware to FX2");
                throw(runtime_error("communication error"));
            }
        }    

        return ResetFpga();
    }

    bool UsbDevice::ResetFpga() {
        unsigned char buf[1<<12];
        buf[0] = FX2_RESET_FPGA;
        fx2.BulkWrite(0x01, const_buffer(buf, 1));
        size_t leftOver = 0;
        size_t ret;
        do {        
            ret = Read(buffer(buf));     
            leftOver += ret;
            usleep(10000);
        } while(ret);
        if(leftOver) cout << ":: Read " << leftOver << " leftover bytes from fpga" << endl;
        ret = fx2.BulkRead(0x81, buffer(buf, 1), 10);
        //cout << "reset: read: " << ret << endl;
        return (ret == 1) && (buf[0] == FX2_FPGA_RESET_ACK);

    }


    bool UsbDevice::IsOpen() const {
        return fx2.IsConnected();
    }

    bool UsbDevice::Close() {
        return ResetFpga();
    }

    size_t UsbDevice::Read(boost::asio::mutable_buffer buf) {

        size_t maxLen = boost::asio::buffer_size(buf);
        int const epIn = 0x86;        
        int ret = 0;
        int rec = 0;
        do {
            ret = fx2.BulkRead(epIn, buf+rec, 10);
//            cout << "read: ret = " << ret << endl;
            rec += ret;
        } while(ret > 0 && rec < maxLen);
//        cout << "read return" << endl;
        return rec;
    }


    void UsbDevice::Write(boost::asio::const_buffer buf) {
        int const epOut = 0x02;
        size_t const maxPacketSize = 32;
        auto p = boost::asio::buffer_cast<unsigned char const*>(buf);
        auto p2 = p + boost::asio::buffer_size(buf);

        while(p < p2) {
            //D("Sending: " + std::to_string(size_t(p2-p)));//+ Util::FormatHex(p, p2));
            size_t nTx = std::min(size_t(p2-p), maxPacketSize);
            fx2.BulkWrite(epOut, boost::asio::buffer(p, nTx));
            p += nTx;
        }

    }

}
