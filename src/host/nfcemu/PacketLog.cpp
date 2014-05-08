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
        if(mAcceptedId != UnitId::eAny &&  mAcceptedId != p.Id()) {
            return false;
        }

        if(p.Dir() == Packet::eUp) {
            mOs << "[";
            if(mEnableColor) ColorizeTs(to_string(p.TimeStamp()));
            else mOs << to_string(p.TimeStamp());
            mOs << "] ";
        }
        else if(mEnableColor) mOs << cc::fore::lightgreen;
        // string unitText = "  ";
        // if(p.Dir() == Packet::eUp && p.IsShort() &&
        //    (p.Id().Type() == UnitId::eNfcCtrl ||
        //     p.Id().UnitKind() == UnitId::eLogic)) {
        //     // debug message
        //     if(mEnableColor) mOs << "  " << cc::back::lightblack;
        //     auto dbgCode = *p.Begin();
        //     if(dbgCode < debugMsg.size()) {
        //         mOs << debugMsg[dbgCode];
        //     } else {
        //         mOs << "Unknown debug code: " << hex << int(dbgCode);
               
        //     }
        //     if(mEnableColor) mOs << cc::back::console;
        //     mOs << dec << " [" << p.GetUnitName() << "]";
        // } else {
        if(mEnableColor) {
            switch(p.Id().DataLocation()) {
            case UnitId::eDown:
                mOs << cc::fore::lightyellow;
                break;
            case UnitId::eUp:
                mOs << cc::fore::lightblue;
                break;
            case UnitId::eLogic:
                mOs << cc::fore::lightgreen;
                break;            
            case UnitId::eStatus:
            case UnitId::eSpecial:
                mOs << cc::fore::red;
                break;            

            case UnitId::eDebug:
                mOs << cc::fore::lightblack;
                break;            

            case UnitId::eAny:
                break;
            }
        }
            string unitText = p.Dir() == Packet::eDown ? "To " : "";
            unitText +=  p.Id().Name() + ": ";
            mOs << setw(20) << left << unitText;
            mOs << FormatHex(p.Begin(), p.End());
        
    
        if(mEnableColor) mOs << cc::back::console << cc::fore::console;
        mOs << endl << endl;
        return true;
    }

    void PacketLog::ColorizeTs(std::string const & ts) {
        bool toggle = false;        
        mOs << cc::fore::lightgreen;
//        mOs << ts;
        string str = string( 3-(ts.size()%3) , ' ') + ts;

//        while(str.size() % 3 != 0) str = " " + str; 
        
         for(auto it = str.begin(); it != str.end(); it += 3) {

             mOs << (toggle ? cc::fore::lightgreen : cc::fore::console)
                 << string(it, it+3);
             toggle = !toggle;
         }

//         for(auto it = ts.rbegin(); it != ts.rend(); it += 3) {
//             string s(it, it+3);
//             mOs << s;
//             if(toggle) {
//             mOs << "a"; //string(it, last);            
//             //              mOs << " " << cc::fore::lightgreen << " ";
//             } else {
//             mOs << "b"; //string(it, last);            
// //                mOs << " " << cc::fore::console << " ";
//             }
//             toggle = !toggle;
//         }
        mOs << cc::fore::console;
    }

    vector<string> const PacketLog::debugMsg =  {"dummy message",
                                                 "PICC power on",
                                                 "PICC power lost",
                                                 "PICC is ready",
                                                 "PICC selected",
                                                 "PICC halted",           // 5
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
