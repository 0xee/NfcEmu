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

string UnitId::Name() const {
    
    string name;
    if(Type() == eNfcCtrl) {
        switch(GetId()) {
        case eCfgUnit:
            name += "Config unit";
            break;
        case eL4CpuDebug:
            name += "Protocol processor";
            break;
        case eL4CpuApdu:
            name += "APDU";
            break;
        case eL4CpuFw:
            name += "Protocol firmware controller";
            break;
        case eTestData:
            name += "Test data generator";
            break;
        default:
            ostringstream oss;
            oss << hex << id;
            return "<Invalid unit id 0x" + oss.str() + ">";
        }
    }
    else {
        if(Device() == ePiccDevice) {
            name += "PICC";
        }      
        else {
            name += "PCD";
        }
        name += " (";
        switch (Protocol()) {
        case eIso14443a:
            name += "A";
            break;
        case eIso14443b:
            name += "B";
            break;
        case eIso15693:
            name += "V";
            break;
        case eIsoLayer4:
            name += "ISO-4";
            break;
        case eMifare:
            name += "MF";
            break;
        default:
            ostringstream oss;
            oss << hex << id;
            return "<Invalid unit id 0x" + oss.str() + ">";
        }
        name += ") ";
        switch(UnitKind()) {
        case eRx:
            name += "Rx";
            break;
        case eTx:
            name += "Tx";
            break;
        case eLogic:
            name += "Logic";
            break;
        default:
            ostringstream oss;
            oss << hex << id;
            return "<Invalid unit id 0x" + oss.str() + ">";
        }
    }
    ostringstream oss;
    oss << hex << id;
   
    return name + " (" + oss.str() + ")";
}
