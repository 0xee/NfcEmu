/**
 * @file   NfcEmuDeviceCfg.h
 * @author Lukas Schuller
 * @date   Tue Sep 24 20:56:40 2013
 * 
 * @brief  
 * 
 */

#ifndef NFCEMUDEVICECFG_H
#define NFCEMUDEVICECFG_H

#include "NfcConstants.h"

enum NfcEmuMode {
    eIdleMode              = 0x00,
    eAmDemodMode               = 0x10,
    eNfcSnifferMode  = 0x20,

    eIso14443aPiccMode     = 0x40,
    eIso14443bPiccMode     = 0x41,
    eIso15693PiccMode     = 0x42,

    eIso14443aPcdMode      = 0x80,
    eIso14443bPcdMode      = 0x81,
    eIso15693PcdMode      = 0x82,

    eCommTest = 0xC0
};

NfcEmuMode ModeFromString(std::string const & str);

struct NfcEmuCfg {
    unsigned char Mode;
    unsigned char SDacA;
    unsigned char SDacB;
    unsigned char SDacC;
    unsigned char SDacD;
    unsigned char MillerTh;
    unsigned char ScTh;
    unsigned char Iso14443aFlags;
    unsigned char Uid[7];
};

enum Iso14443aFlags {
    eLongUid = 0x01,
    eEnableIsoL4 = 0x02
};

#endif /* NFCEMUDEVICECFG_H */
