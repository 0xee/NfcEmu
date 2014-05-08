/**
 * @file   NfcEmuDevice.h
 * @author Lukas Schuller
 * @date   Fri Aug 23 12:55:17 2013
 * 
 * @brief  Abstract NfcEmu device base class 
 * 
 */

#ifndef NFCEMUDEVICE_H
#define NFCEMUDEVICE_H

#include <string>
#include <algorithm>
#include <iostream>

class NfcEmuDevice {

public:
    virtual ~NfcEmuDevice() {
        //std::cerr << "Device dtor" << std::endl;
    }
    

    virtual int Read(unsigned char * buf, size_t const maxLen) = 0;
    
    // template<typename OutputIterator>
//     int Read(OutputIterator oi, size_t const maxLen = 1<<20) {
//         unsigned char * buf = new unsigned char[maxLen];
// //        std::cout << "buflen: " << maxLen << std::endl;
//         int read = Read(buf, maxLen);
//         std::copy(buf, buf+read, oi);
//         delete [] buf; buf = 0;
//         return read;
//     }

    virtual int Write(unsigned char const * buf, size_t const len) = 0;

    template<typename InputIterator>
    int Write(InputIterator first, InputIterator last) {
        unsigned char buf[10240];
        std::copy(first, last, buf);
        return (buf, (last-first));
    }

protected:
    

};

#endif /* NFCEMUDEVICE_H */
