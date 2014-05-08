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

class NfcEmuFileDevice : public NfcEmuDevice {

public:
    NfcEmuFileDevice(std::string const & inFilename, std::string const & outFilename) {
        Open(inFilename, outFilename);
    }
    ~NfcEmuFileDevice() {
        Close();
    }

    bool Open(std::string const & inFilename, std::string const & outFilename) {
        inFile.open(inFilename.c_str());
        if(inFile.bad()) {
            std::cerr << ":: Failed to open input file" << std::endl;
            return false;
        }
        outFile.open(outFilename.c_str());
        if(outFile.bad()) {
            std::cerr << ":: Failed to open output file" << std::endl;
            return false;        
        }
        return true;
    }
    bool Close() {
        inFile.close();
        outFile.close();
    }

    int Read(unsigned char * buf, size_t const maxLen) {

        if(inFile.bad() || inFile.eof()) return 0;
        char strBuf[2048] = {0};
        inFile.getline(strBuf, sizeof(strBuf));
        std::istringstream iss(strBuf);
        iss >> std::hex;
        int read = 0;
        while(!iss.eof() && read < maxLen) {
            int byte;
            iss >> byte;
            buf[read++] = byte;
        }
        return read;
    }

    int Write(unsigned char const * buf, size_t const len) {
        if(inFile.bad() || inFile.eof()) return 0;
        outFile << std::hex;
        std::copy(buf, buf+len, std::ostream_iterator<int>(outFile, " "));
        outFile << std::endl;
        return len;
    }

private:
    std::ofstream outFile;
    std::ifstream inFile;
};

#endif /* NFCEMUFILEDEVICE_H */
