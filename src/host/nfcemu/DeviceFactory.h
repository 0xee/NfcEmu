/**
 * @file   DeviceFactory.h
 * @author Lukas Schuller
 * @date   Tue Sep 24 20:50:17 2013
 * 
 * @brief  Constructs NfcEmuDevices
 * 
 */

#ifndef DEVICEFACTORY_H
#define DEVICEFACTORY_H

#include "Configuration.h"
#include "NfcEmuDevice.h"
#include <boost/filesystem.hpp>
#include <memory>

namespace NfcEmu {

    class DeviceFactory{
    
    public:
        static Device::Ptr BuildFileDevice(boost::asio::io_service & io, 
                                                   boost::filesystem::path const & inFile, 
                                                   boost::filesystem::path const & outFile);
                
        static Device::Ptr BuildUsbDevice(boost::asio::io_service & io, 
                                   std::string const & id = "");

    private:

    };

}

#endif /* DEVICEFACTORY_H */
