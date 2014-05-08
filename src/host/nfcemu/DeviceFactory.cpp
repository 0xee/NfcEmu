/**
 * @file   DeviceFactory.cpp
 * @author Lukas Schuller
 * @date   Fri Oct  4 12:59:14 2013
 * 
 * @brief  
 * 
 */

#include "DeviceFactory.h"

#include "NfcEmuUsbDevice.h"
#include "NfcEmuFileDevice.h"
#include <boost/asio.hpp>
using namespace std;

namespace NfcEmu {

    unique_ptr<Device> DeviceFactory::BuildFileDevice(boost::asio::io_service & io, 
                                                      boost::filesystem::path const & inFile, 
                                                      boost::filesystem::path const & outFile) {
        return unique_ptr<Device>(new FileDevice(io, inFile, outFile));
    }


    unique_ptr<Device> DeviceFactory::BuildUsbDevice(boost::asio::io_service & io, 
                                                     string const & id) {
        Configuration::RegisterOption("fx2fw", "fx2", "../../fx2/fx2bridge/fx2bridge.ihx");
    
        auto pUsbDev = Device::Ptr(new UsbDevice(io, Configuration::GetOption("fx2fw").Str()));
    
        return pUsbDev;
    
    }
}
