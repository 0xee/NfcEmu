/**
 * @file   UnitId.cpp
 * @author Lukas Schuller
 * @date   Thu Sep 26 15:46:29 2013
 * 
 * @brief  
 * 
 */

#include "UnitId.h"
#include <sstream>
#include <iostream>
#include <iomanip>

using namespace std;
using namespace NfcEmu;

map<UnitId::Flags, string> const UnitId::mFlagNames = {
        {eLogic  , "Logic"},
        {eDown   , "Down"},
        {eUp     , "Up"},
        {eStatus , "Status"},
        {eSpecial, "Special"},
        {eDebug  , "Debug"}
    };
map<UnitId::Id, string> const UnitId::mUnitNames = {
    {eControlReg, "ControlReg"},
    {eCpu, "Cpu"},
    {eCpuFw, "CpuFw"},
    {eEnvelopeStream, "EnvelopeStream"},
    {eTestStream, "TestStream"},
    {eIso14443aPicc, "Iso14443aPicc"},
    {eIso14443aPcd, "Iso14443aPcd"},
    {eIsoLayer4Picc, "IsoLayer4Picc"},
    {eIsoLayer4Pcd, "IsoLayer4Pcd"}
};

map<UnitId::Id, UnitId::Flags> const UnitId::mDefaultFlags = {
    {eControlReg, eLogic},
    {eCpu, eLogic},
    {eCpuFw, eStatus},
    {eEnvelopeStream, eSpecial},
    {eTestStream, eSpecial},
    {eIso14443aPicc, eAll},
    {eIso14443aPcd, eAll},
    {eIsoLayer4Picc, eAll},
    {eIsoLayer4Pcd, eAll}
};

string UnitId::Name() const {

    string name;
    bool isKnownUnit = mUnitNames.find(mUnit) != mUnitNames.end();
    if(isKnownUnit) {
        name = mUnitNames.at(mUnit);
    } else {
        ostringstream oss;
        oss << hex << mUnit;   
        name = "Unknown: 0x" + oss.str() + ")";

    }
    

    if(!isKnownUnit || mFlags != mDefaultFlags.at(mUnit) || mDefaultFlags.at(mUnit) == eAll) {
        if(mFlagNames.find(mFlags) != mFlagNames.end()) {
            name += " " + mFlagNames.at(mFlags);
        }
    }

    return name;
}
