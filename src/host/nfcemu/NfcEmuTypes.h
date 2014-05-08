/**
 * @file   NfcEmuTypes.h
 * @author Lukas Schuller
 * @date   Fri Oct  4 19:10:33 2013
 * 
 * @brief  
 * 
 */

#ifndef NFCEMUTYPES_H
#define NFCEMUTYPES_H

#include <string>

namespace NfcEmu {

    enum EmuMode {
        eSnifferMode,
        ePiccMode,
        ePcdMode,
        eDemodMode,
    };


    enum NfcProtocol {
        eIso14443a = 0x1,
        eIso14443b = 0x2,
        eIso15693 = 0x3,
        eIso14443_4 = 0x4,
        eMifare = 0x5,
    };


    enum NfcDeviceType {
        ePcdDevice = 0x00,
        ePiccDevice = 0x01
    };


    inline EmuMode ModeFromString(std::string const & str) {
        if(str == "sniffer") {
            return eSnifferMode;
        } else if(str == "demod") {
            return eDemodMode;
        } else if(str == "picc") {
            return ePiccMode;
        } else if(str == "pcd") {
            return ePcdMode;
        }        

        return eSnifferMode;
    }
}

#endif /* NFCEMUTYPES_H */
