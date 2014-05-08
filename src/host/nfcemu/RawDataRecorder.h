/**
 * @file   RawDataRecorder.h
 * @author Lukas Schuller
 * @date   Fri Aug 30 13:46:30 2013
 * 
 * @brief  Raw (demod-) data recorder derived from emulator
 * 
 */


#ifndef RAWDATARECORDER_H
#define RAWDATARECORDER_H

#include "NfcEmuDevice.h"

#include <fstream>
#include <iostream>
#include <vector>
#include <memory>
#include <sys/time.h>
#include <unistd.h>
#include <iterator>

class RawDataRecorder {

public:
    RawDataRecorder(std::shared_ptr<NfcEmuDevice> pDevice,
                    std::string const & storageFile = "raw.txt")
        : pDev(pDevice) {       
        dumpFile.open(storageFile.c_str());
        if(dumpFile.bad()) {
            std::cerr << "Could not open log file" << std::endl;
        }

    }

    ~RawDataRecorder() {
        dumpFile.close();
    }
    
    virtual bool Record(size_t const samples) {
        std::unique_ptr<unsigned char> tmpStorage(new unsigned char[2*samples]);
        struct timeval startTv;
        gettimeofday(&startTv, NULL);
        size_t totalRead = 0;
        size_t bytesToRead = samples;        
        //std::cout << samples << std::endl; 
        // c++ fstreams are slow when writing ascii, so we store the 
        // data in a temporary container
        int ret = 0;
        do {
            int bytesMissing = bytesToRead-totalRead;
//            ret = pDev->Read(tmpStorage.get()+totalRead, std::min(bytesMissing,1<<16));
            ret = pDev->Read(tmpStorage.get()+totalRead, 1<<18);
//            std::cout << ret << "/" << totalRead << std::endl;
            totalRead += ret;
            if(ret >= bytesMissing) {
                struct timeval tv;
                gettimeofday(&tv, NULL);
                size_t usElapsed = 1000000*(tv.tv_sec - startTv.tv_sec) +
                    (tv.tv_usec - startTv.tv_usec);
//                while(totalRead > bytesToRead) tmpStorage.pop_back();
                std::cout << ":: Collected " << bytesToRead
                          << " bytes, in " << usElapsed/1000
                          << "ms (" << (bytesToRead/(double)usElapsed) << " MiB/s)" << std::endl
                          << ":: Writing to file..." << std::endl;
//                for(int i = 0; i < nr.size(); ++i) std::cout << nr[i] << " ";
//                std::cout << std::endl;
                std::copy(tmpStorage.get(), tmpStorage.get()+totalRead, 
                          std::ostream_iterator<int>(dumpFile, "\n"));
                return false;
            }
        } while(ret > 0);                
        
        return true;
    }

            

private:
    std::shared_ptr<NfcEmuDevice> pDev;

    std::ofstream dumpFile;

};

#endif /* RAWDATARECORDER_H */
