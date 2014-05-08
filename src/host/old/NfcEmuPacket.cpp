/**
 * @file   NfcEmuPacket.cpp
 * @author Lukas Schuller
 * @date   Tue Aug 20 16:57:41 2013
 * 
 * @brief  
 * 
 */

#include "NfcEmuPacket.h"
#include <string>
#include <iterator>
#include <iomanip>
#include <sstream>
#include "ccolor.h"

using namespace std;

void NfcEmuPacket::PrintData(ostream & os) const {
    os << hex << setw(2) << setfill('0') << right;
    for(auto ii = data.begin(); ii != data.end(); ++ii) {
        os << setw(2) << static_cast<int>(*ii) << "  ";
    }
    os << dec << setfill(' ') ;
}

void NfcEmuPacket::Print(ostream & os) const {
    string unitText = "   Packet ";

    if(!isDownPacket && IsShortFrame() &&
       (unitId.Type() == UnitId::eNfcCtrl ||
        unitId.UnitKind() == UnitId::eLogic)) {
        // debug message
        if(cc::Enabled()) os << cc::back::lightblack;
        os << ":: ";
        if(data[0] < sizeof(debugMessages)/sizeof(debugMessages[0])) {
            os << debugMessages[data[0]] << " [" << GetUnitName() << "]";
        } else {
            os << "  unknown debug code: " << hex << int(data[0]) << dec << "";
        }
        if(cc::Enabled()) os << cc::back::console;
        
    } else {
        if( unitId.DataLocation() == UnitId::ePcdToPicc) os << cc::fore::lightyellow;
        else if( unitId.DataLocation() == UnitId::ePiccToPcd) os << cc::fore::lightblue;
       
        unitText += (isDownPacket ? "to " : "from ");
        unitText +=  GetUnitName() + ": ";
        os << setw(30) << left << unitText;
        PrintData(os);
        if(shortFrame) os << "  (short)";
        if(cc::Enabled()) os << cc::back::console << cc::fore::console;
    }
    os << endl << endl;
}

string NfcEmuPacket::GetUnitName() const {
    return unitId.Name();
}


std::ostream & operator<<(std::ostream & os, NfcEmuPacket const & p) {
    p.Print(os);
    return os;
}
