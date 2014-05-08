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

#include <string>
#include "Exception.h"
#include "NfcEmuTypes.h"
#include <map>
#include "Debug.h"

namespace NfcEmu {
class UnitId {

public:    
    enum Id {
        eControlReg     = 0,
        eCpu            = 1,
        eCpuFw          = 2,
        eEnvelopeStream = 3,
        eTestStream     = 4,
        eIso14443aPicc  = 5,
        eIso14443aPcd   = 6,
        eIsoLayer4Picc      = 7,
        eIsoLayer4Pcd      = 8,
        eAny = 255};

    enum Flags {
        eLogic   = 0x0 << 5,
        eDown    = 0x1 << 5,
        eUp      = 0x2 << 5,
        eStatus  = 0x3 << 5,
        eSpecial = 0x4 << 5,
        eDebug   = 0x7 << 5,
        eAll   = 0xFF};

    constexpr static size_t const idMask = 0x1F;

    static std::map<Flags, std::string> const mFlagNames;
    static std::map<Id, std::string> const mUnitNames;
    static std::map<Id, Flags> const mDefaultFlags;

//    UnitType Type() const { return UnitType(GetId() & unitTypeMask); }

    UnitId(Id id, size_t flags) {
        mUnit = Id(id & idMask);
        mFlags = Flags(flags & ~idMask);
    }

    UnitId(size_t id) {
        mUnit = Id(id & idMask);
        mFlags = Flags(id & ~idMask);
    }

    UnitId() : mUnit(Id(0)), mFlags(eAll) { }

    operator size_t() const { return GetId(); }
    size_t GetId() const { return mUnit | mFlags; }
    std::string Name() const;

    Flags GetFlags() {
        return mFlags;
    }

    Id GetUnit() {
        return mUnit;
    }

    inline bool operator ==(Id const & rhs) {
        return rhs == mUnit;
    }

    Flags DataLocation() const {
        return mFlags;

    }

private:

    Id mUnit;
    Flags mFlags;

};

}

#endif /* UNITID_H */
