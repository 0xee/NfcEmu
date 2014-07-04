/**
 * @file   PacketLog.cpp
 * @author Lukas Schuller
 * @date   Tue Oct 22 23:17:58 2013
 * 
 * @brief  
 * 
 */


#include <iomanip>
#include <iostream>
#include <list>

#include "PacketLog.h"
#include "NfcEmuPacket.h"
#include "Util.h"

using namespace std;
using namespace Util;

namespace NfcEmu {

    bool PacketLog::Notify(Packet const & p) {
        if(mAcceptedId != UnitId::eAny &&  mAcceptedId != p.Id().GetUnit()) {
            return false;
        }
        if(p.Dir() == Packet::eUp) {
            mOs.get() << "[";
            if(mEnableColor) ColorizeTs(to_string(p.TimeStamp()));
            else mOs.get() << to_string(p.TimeStamp());
            mOs.get() << "] ";
        }
        else if(mEnableColor) mOs.get() << cc::fore::lightgreen;

        string content = FormatHex(p.Begin(), p.End());

        if(p.Id().DataLocation() == UnitId::eDebug && 
           p.Id() == UnitId::eCpu && 
           p.GetData().size()) {

            switch(*p.Begin()) {
            case 0x06: content = "Invalid packet"; break;
            case 0x07: content = "CRC error"; break;
            case 0x09: content = "ISO L4 activated"; break;
            case 0x0B: content = "Packet processed"; break;
            case 0x0D: content = "NAK received"; break;
            case 0x0E: content = "ISO L4 deselect"; break;
            case 0x0F: content = "WTX ACK"; break;
            case 0xA0: content = "GENERIC 0"; break;
            case 0xA1: content = "GENERIC 1"; break;
            case 0xA2: content = "GENERIC 2"; break;
            case 0xA3: content = "GENERIC 3"; break;

            case 0xFF: content = "ERROR"; break;

            }
        }

        if(mEnableColor) {
            switch(p.Id().DataLocation()) {
            case UnitId::eDown:
                mOs.get() << cc::fore::lightyellow;
                break;
            case UnitId::eUp:
                mOs.get() << cc::fore::lightblue;
                break;
            case UnitId::eLogic:
                mOs.get() << cc::fore::lightgreen;
                break;      
            case UnitId::eStatus:
            case UnitId::eSpecial:
                mOs.get() << cc::fore::red;
                break;      

            case UnitId::eDebug:
                mOs.get() << cc::fore::lightblack;
                break;      

            case UnitId::eAny:
                break;
            }
        }
        string unitText = p.Dir() == Packet::eDown ? "To " : "";
        unitText += p.Id().Name() + ": ";
        mOs.get() << setw(20) << left << unitText;
        mOs.get() << content;
    
  
        if(mEnableColor) mOs.get() << cc::back::console << cc::fore::console;
        mOs.get() << endl << endl;
        return true;
    }

    void PacketLog::ColorizeTs(std::string const & ts) {
        bool toggle = false;    
        mOs.get() << cc::fore::lightgreen;
//    mOs.get() << ts;
        string str = string( 3-(ts.size()%3) , ' ') + ts;

//    while(str.size() % 3 != 0) str = " " + str; 
    
        for(auto it = str.begin(); it != str.end(); it += 3) {

            mOs.get() << (toggle ? cc::fore::lightgreen : cc::fore::console)
                      << string(it, it+3);
            toggle = !toggle;
        }

//     for(auto it = ts.rbegin(); it != ts.rend(); it += 3) {
//       string s(it, it+3);
//       mOs.get() << s;
//       if(toggle) {
//       mOs.get() << "a"; //string(it, last);      
//       //       mOs.get() << " " << cc::fore::lightgreen << " ";
//       } else {
//       mOs.get() << "b"; //string(it, last);      
// //        mOs.get() << " " << cc::fore::console << " ";
//       }
//       toggle = !toggle;
//     }
        mOs.get() << cc::fore::console;
    }

    vector<string> const PacketLog::debugMsg = {"dummy message",
                                                "PICC power on",
                                                "PICC power lost",
                                                "PICC is ready",
                                                "PICC selected",
                                                "PICC halted",      // 5
                                                "Received config packet",
                                                "Invalid CRC sum",
                                                "T51 ready",
                                                "ISO Layer 4 activated",
                                                "ISO Layer 4 deactivated", // 10
                                                "Packet processed",
                                                "ACK received",
                                                "NAK received",
                                                "Received ISO-4 deselect",
                                                "Debug point 0",
                                                "Debug point 1",
                                                "Debug point 2",
                                                "Debug point 3",
    };




}
