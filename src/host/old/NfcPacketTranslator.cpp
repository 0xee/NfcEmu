/**
 * @file   NfcPacketTranslator.cpp
 * @author Lukas Schuller
 * @date   Tue Sep 24 23:56:13 2013
 * 
 * @brief  
 * 
 */


#include "NfcPacketTranslator.h"
#include <unistd.h>

using namespace std;

std::unique_ptr<NfcEmuPacket> NfcPacketTranslator::WaitForPacket(size_t timeout, 
                                                                 bool verbose) {
    bool forever = timeout == 0;
    unique_ptr<NfcEmuPacket> pPacket;
    do {
        pPacket = ReceivePacket(verbose);
        usleep(1000);
    } while(!pPacket && (--timeout || forever));

    return pPacket;
}


unique_ptr<NfcEmuPacket> NfcPacketTranslator::ReceivePacket(bool verbose) {
    size_t const bufSize = 1<<10;
    unsigned char rawBuf[bufSize];
    size_t r = pDev->Read(rawBuf, bufSize);
    copy(rawBuf, rawBuf+r, back_inserter(rxBuf));
    int packetCount = 0;
    if(!rxBuf.size()) return nullptr;
    while(rxBuf.front() != NFC_START_BYTE) {
        cout << ":: found non-startbyte " << hex << int(rxBuf.front()) << dec << endl;
        rxBuf.pop_front();
    } 
    if(!rxBuf.size()) return nullptr;
    deque<unsigned char>::iterator last = rxBuf.begin();
    deque<unsigned char>::iterator prev = last;
    while(last != rxBuf.end()) {
        deque<unsigned char>::iterator next = last; ++next;
        if(*last == NFC_START_BYTE && 
           (*prev == NFC_STOP_BYTE || *prev == NFC_STOP_BYTE_SHORT)) {
            break;
        }   
        prev = last;
        ++last;
    }
    // cout << "last: " << hex << int(*last) << ", prev: " << int(*prev) << dec << endl;
            
    auto pPacket = unique_ptr<NfcEmuPacket>(new NfcEmuPacket(rxBuf.begin(), last));
    rxBuf.erase(rxBuf.begin(), last);
    if(verbose) cout << *pPacket;
    return pPacket;
}


void NfcPacketTranslator::SendPacket(NfcEmuPacket const & packet, bool verbose) {

    if(verbose) cout << ":: Sending " << packet << endl;
    vector<unsigned char> rawPacket;
    packet.GetRawPacket(back_inserter(rawPacket));
    // cout << hex << endl;
    // copy(rawPacket.begin(), rawPacket.end(), ostream_iterator<int>(cout, " "));
    // cout << dec << endl;
    int ret = pDev->Write((unsigned char *)rawPacket.data(), rawPacket.size());

    if(ret != rawPacket.size()) {  // @todo: throw exception
        cerr << "Error, only " << ret << " bytes out of "
             << rawPacket.size() << " were sent" << endl;
    }
}
