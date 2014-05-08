/**
 * @file   NfcEmuPacket.h
 * @author Lukas Schuller
 * @date   Tue Aug 20 16:54:39 2013
 * 
 * @brief  
 * 
 */

#ifndef NFCEMUPACKET_H
#define NFCEMUPACKET_H

#include <string>
#include <vector>
#include <iostream>
#include <iterator>
#include "NfcConstants.h"
#include "UnitId.h"

class NfcEmuPacket {

    typedef std::vector<unsigned char> DataContainer;
    
public:
    // constructor for down-packets
    template<typename InputIterator> 
    NfcEmuPacket(unsigned int const id, 
                 InputIterator first, InputIterator last,
                 bool shortFrame = false,
                 bool downPacket = true) : unitId(id), data(first, last), 
                                            isDownPacket(downPacket), shortFrame(shortFrame) {}

    // constructor for up packets from raw data
    template<typename InputIterator> 
    NfcEmuPacket(InputIterator first, InputIterator last, bool downPacket = false) : isDownPacket(downPacket) {
        std::vector<unsigned char> rawPacket(first,last);
        // std::cout << std::endl << std::hex;
        // std::copy(first, last, std::ostream_iterator<int>(std::cout, " "));
        // std::cout << std::dec << std::endl;

        if(rawPacket.size() < 5 ||
           rawPacket[0] != NFC_START_BYTE ||
           (*rawPacket.rbegin() != NFC_STOP_BYTE &&
            *rawPacket.rbegin() != NFC_STOP_BYTE_SHORT)) {
            std::cerr << "Buffer (" << rawPacket.size() << " bytes) contains no valid packet: " << std::hex;
            std::copy(rawPacket.begin(), rawPacket.end(), std::ostream_iterator<int>(std::cerr, " "));
            std::cerr << std::endl << std::dec;
        } else {
            unitId = rawPacket[1];
            std::copy(rawPacket.begin()+3,
                      rawPacket.begin()+rawPacket.size()-1,
                      back_inserter(data)); 
            shortFrame = *rawPacket.rbegin() == NFC_STOP_BYTE_SHORT;
        }
    }

    template<typename OutputIterator>
    void GetRawPacket(OutputIterator oi) const {
        oi = NFC_START_BYTE;
        oi = unitId;
        oi = data.size();
        std::copy(data.begin(), data.end(), oi);
        oi = shortFrame ? NFC_STOP_BYTE_SHORT : NFC_STOP_BYTE;
    }

    unsigned char const * Data() const {
        return data.data();
    }

    size_t Size() const {
        return data.size();
    }


    DataContainer::const_iterator Begin() const {
        return data.cbegin();
    }

    DataContainer::const_iterator End() const {
        return data.cend();
    }

    int GetId() const { return unitId; }

    void PrintData(std::ostream & os = std::cout) const ;
    void Print(std::ostream & os = std::cout) const;
    std::string GetUnitName() const;
    bool IsShortFrame() const { return shortFrame; }
    
protected:

    NfcEmuPacket() : unitId(0) {}
    UnitId unitId;
    bool shortFrame;
    bool isDownPacket;
    DataContainer data;
};

std::ostream & operator<<(std::ostream & os, NfcEmuPacket const & p);

#endif 
