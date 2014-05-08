/**
 * @file   NfcEmuDeviceCfg.cpp
 * @author Lukas Schuller
 * @date   Tue Sep 24 22:34:41 2013
 * 
 * @brief  
 * 
 */


#include "NfcEmuDeviceCfg.h"

NfcEmuMode ModeFromString(std::string const & str) {
    if(str == "demod" || str == "am") return eAmDemodMode;
    if(str == "sniffer") return eNfcSnifferMode;
    if(str == "picc") return eIso14443aPiccMode;
    if(str == "pcd") return eIso14443aPcdMode;

    return eIdleMode;
}
