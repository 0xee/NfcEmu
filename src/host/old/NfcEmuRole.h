/**
 * @file   NfcEmu.h
 * @author Lukas Schuller
 * @date   Tue Aug 20 16:12:23 2013
 * 
 * @brief  Class representing an NfcEmu Role
 * 
 */

#ifndef NFCEMUROLE_H
#define NFCEMUROLE_H

#include <memory>

#include "NfcPacketTranslator.h"

class NfcEmuRole {
public:

    NfcEmuRole(std::unique_ptr<NfcPacketTranslator> pTr) : pDev(std::move(pTr)) { }
    virtual ~NfcEmuRole() { }

    virtual bool ProcessData() = 0;
    NfcPacketTranslator & GetDevice() { return *pDev; }
protected:
    
    std::unique_ptr<NfcPacketTranslator>  pDev;
};

#endif /* NFCEMUROLE_H */
