/**
 * @file   NfcEmuFileDevice.h
 * @author Lukas Schuller
 * @date   Fri Aug 23 13:07:19 2013
 * 
 * @brief  Implements a NfcEmuDevice working on a file instead of a actual device
 * 
 */

#ifndef NFCEMUFILEDEVICE_H
#define NFCEMUFILEDEVICE_H

#include "NfcEmuDevice.h"
#include <fstream>
#include <vector>
#include <algorithm>
#include <sstream>
#include <cstring>
#include <iterator>

#include <boost/filesystem.hpp>

namespace NfcEmu {

    class FileDevice : public Device {

    public:
        FileDevice(boost::asio::io_service & io, 
                   boost::filesystem::path const & inFilename, 
                   boost::filesystem::path const & outFilename);

        ~FileDevice();

        bool Open(boost::filesystem::path const & inFilename, 
                  boost::filesystem::path const & outFilename);
        bool Close();

        void StopReceive() {}
        size_t Read(boost::asio::mutable_buffer buf);
        void Write(boost::asio::const_buffer buf);

        void Accept(DeviceVisitor & visitor);
    protected:
        void StartAsyncRead();
    private:
        std::deque<unsigned char> mFileBuf;
        std::ofstream outFile;
        std::ifstream inFile;
    };

}

#endif /* NFCEMUFILEDEVICE_H */
