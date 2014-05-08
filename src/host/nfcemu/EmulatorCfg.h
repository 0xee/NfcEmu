/**
 * @file   EmulatorCfg.h
 * @author Lukas Schuller
 * @date   Fri Apr 18 17:39:16 2014
 * 
 * @brief  Config for the emulator device
 * 
 * @license 
 *  Copyright (C) 2014 Lukas Schuller
 * 
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 * 
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef EMULATORCFG_H
#define EMULATORCFG_H

#include "NfcEmuTypes.h"
#include "Configuration.h"

namespace NfcEmu {

class EmulatorCfg { 

public:
    EmulatorCfg() {}
    EmulatorCfg(Configuration & cfg);
    
EmulatorCfg(NfcEmu::EmuMode mode, std::string piccUid,
                size_t millerTh, size_t subCarrierTh,
                bool longUid) : mMode(mode), mPiccUid(piccUid),
                                mMillerTh(millerTh), mSubCarrierTh(subCarrierTh), 
                                mLongUid(longUid) {}

    NfcEmu::EmuMode mMode;
    std::string mPiccUid;
    size_t mMillerTh; 
    size_t mSubCarrierTh;
    bool mLongUid;
};
}

#endif /* EMULATORCFG_H */
