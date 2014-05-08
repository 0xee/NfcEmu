/**
 * @file   UnitId.h
 * @author Lukas Schuller
 * @date   Thu Sep 26 14:51:04 2013
 * 
 * @brief  
 * 
 */


#ifndef UNITID_H
#define UNITID_H

#include "NfcEmuException.h"
#include <string>

class UnitId {

public:    
    constexpr static unsigned int unitTypeMask = 0x80;
    enum UnitType {
        eNfcData = 0x00,
        eNfcCtrl = 0x80
    };
    

    constexpr static unsigned int const protocolMask = 0x70;
    enum NfcProtocol {
        eIso14443a = 0x10,
        eIso14443b = 0x20,
        eIso15693 = 0x30,
        eIsoLayer4 = 0x40,
        eMifare = 0x50,
    };

    constexpr static unsigned int const deviceTypeMask = 0x08;
    enum NfcDeviceType {
        ePcdDevice = 0x00,
        ePiccDevice = 0x08
    };

    constexpr static unsigned int const unitKindMask = 0x07;
    enum NfcUnitKind {
        eRx = 0x00,
        eLogic = 0x01,
        eTx = 0x02,
    };

    enum NfcControlUnit {
        eCfgUnit = 0xCC,
        eL4CpuDebug = 0xDD,
        eL4CpuFw = 0xDE,
        eL4CpuApdu = 0xDF,
        eTestData = 0xC0
    };

    enum NfcDataLocation {
        ePcdLogic,
        ePcdToPicc,
        ePiccLogic,
        ePiccToPcd,
        eNoLocation
    };

    UnitType Type() const { return UnitType(GetId() & unitTypeMask); }
    NfcProtocol Protocol() const { return NfcProtocol(GetId() & protocolMask); }
    NfcDeviceType Device() const { return NfcDeviceType(GetId() & deviceTypeMask); }
    NfcUnitKind UnitKind() const { return NfcUnitKind(GetId() & unitKindMask); }

    UnitId() : id(0) { }
    UnitId(unsigned int id) : id(id) { }
    operator unsigned int() const { return GetId();  };
    unsigned int GetId() const { return id; }
    std::string Name() const;

    NfcDataLocation DataLocation() const {
        if(Type() == eNfcCtrl) return eNoLocation;

        if(Device() == ePcdDevice) {
            switch(UnitKind()) {
            case eRx: return ePiccToPcd;
            case eTx: return ePcdToPicc;
            case eLogic: return ePcdLogic;
            }
        } else {
            switch(UnitKind()) {
            case eRx: return ePcdToPicc;
            case eTx: return ePiccToPcd;
            case eLogic: return ePiccLogic;
            }            
        }       
    }

private:

    unsigned int id;

};



#endif /* UNITID_H */
