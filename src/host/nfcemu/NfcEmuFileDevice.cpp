/**
 * @file   NfcEmuFileDevice.cpp
 * @author Lukas Schuller
 * @date   Thu Oct 24 09:37:08 2013
 * 
 * @brief  
 * 
 */

#include "NfcEmuFileDevice.h"
#include "Util.h"
#include <vector>
#include "Debug.h"

using namespace std;
using namespace boost::asio;

namespace NfcEmu {
    
    FileDevice::FileDevice(boost::asio::io_service & io, 
                           boost::filesystem::path const & inFilename, 
                           boost::filesystem::path const & outFilename) : Device(io) {
        Open(inFilename, outFilename);
    }

    FileDevice::~FileDevice() {
        Close();
    }

    bool FileDevice::Open(boost::filesystem::path const & inFilename, 
                          boost::filesystem::path const & outFilename) {
        inFile.open(inFilename.native());
        if(inFile.bad()) {
            Error("Failed to open input file");
            return false;
        }
        outFile.open(outFilename.native());
        if(outFile.bad()) {
            Error("Failed to open output file");
            return false;        
        }

        string line;
        getline(inFile, line);
        while(inFile.good()) {
            getline(inFile, line);
            cout << line << endl;
            auto v = Util::DecodeHex(line);
            copy(v.begin(), v.end(), back_inserter(mFileBuf));
        }
        inFile.close();
        

        return true;
    }
    bool FileDevice::Close() {
        outFile.close();
        return true;
    }

    size_t FileDevice::Read(boost::asio::mutable_buffer buf) {
        auto pBuf = boost::asio::buffer_cast<unsigned char*>(buf);
        size_t n = std::min(boost::asio::buffer_size(buf), mFileBuf.size());
        copy_n(mFileBuf.begin(), n, pBuf);
        for(size_t i = 0; i < n; ++i) mFileBuf.pop_front();
        return n;
    }

    void FileDevice::StartAsyncRead() {
        vector<unsigned char> readBuf;
        readBuf.resize(1<<7);
        readBuf.resize(Read(boost::asio::buffer(readBuf)));        
        
        copy(readBuf.begin(), readBuf.end(), back_inserter(mPacketBuf));
        mIoService.dispatch(std::bind(&FileDevice::OnRx, this));
    }

    void FileDevice::Write(boost::asio::const_buffer buf) {
        auto pBuf = boost::asio::buffer_cast<unsigned char const*>(buf);
        size_t len = boost::asio::buffer_size(buf);
        if(inFile.bad()) throw Exception("Error in file write");
        outFile << std::hex;
        std::copy(pBuf, pBuf+len, std::ostream_iterator<int>(outFile, " "));
        outFile << std::endl;
    }

    void FileDevice::Accept(DeviceVisitor & visitor) {
        visitor.Visit(*this);
    }
}
