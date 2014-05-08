/**
 * @file   NfcSniffer.h
 * @author Lukas Schuller
 * @date   Wed Aug 21 12:14:29 2013
 * 
 * @brief  Nfc Sniffer class derived from abstract class NfcEmu
 * 
 */

#ifndef NFCSNIFFER_H
#define NFCSNIFFER_H

#include "NfcEmuRole.h"
#include <fstream>
#include "NfcEmuException.h"

class NfcSniffer : public NfcEmuRole {

public:
    NfcSniffer(std::unique_ptr<NfcPacketTranslator>  pTr, 
               std::string const & logFile = "") : NfcEmuRole(std::move(pTr)) {
        dumpFile.open(logFile.c_str());
        if(dumpFile.bad())  throw NfcEmuException("Error opening logfile");
    }

    ~NfcSniffer() {
        dumpFile.close();
    }

    virtual bool ProcessData() {
        auto pPacket = pDev->ReceivePacket();
        if(!pPacket) return false;
        pPacket->Print();
        if(!dumpFile.bad()) {
            dumpFile << std::hex;
            pPacket->GetRawPacket(std::ostream_iterator<int>(dumpFile, " "));
                    
            dumpFile << std::endl << std::dec;
        }
        return true;
    }

private:
    std::ofstream dumpFile;
    
};



#endif /* NFCSNIFFER_H */
