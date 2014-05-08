/**
 * @file   NfcPacketTranslator.h
 * @author Lukas Schuller
 * @date   Tue Sep 24 23:09:04 2013
 * 
 * @brief  
 * 
 */

#ifndef NFCPACKETTRANSLATOR_H
#define NFCPACKETTRANSLATOR_H

#include "NfcEmuDevice.h"
#include "NfcEmuPacket.h"
#include <memory>
#include <deque>

class NfcPacketTranslator {

public:
    NfcPacketTranslator(std::shared_ptr<NfcEmuDevice> dev) : pDev(dev) { }

    std::unique_ptr<NfcEmuPacket> ReceivePacket(bool verbose = false);
    std::unique_ptr<NfcEmuPacket> WaitForPacket(size_t timeout = 0, bool verbose = false);
    void SendPacket(NfcEmuPacket const & packet, bool verbose = false);

private:
    std::shared_ptr<NfcEmuDevice> pDev;
    std::deque<unsigned char> rxBuf;

};

#endif /* NFCPACKETTRANSLATOR_H */
