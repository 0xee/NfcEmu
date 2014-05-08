/**
 * @file   NfcEmuConfig.h
 * @author Lukas Schuller
 * @date   Sat Apr 26 12:11:28 2014
 * 
 * @brief  
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

#ifndef NFCEMUCONFIG_H
#define NFCEMUCONFIG_H

#include <memory>

#include "PacketListener.h"

namespace NfcEmu {

    class NfcEmuConfig {
        struct FpgaConfiguration {
            unsigned int Enable;
            unsigned int Flags;
            unsigned char SDacA;
            unsigned char SDacB;
            unsigned char SDacC;
            unsigned char SDacD;
            unsigned char FieldTh;
            unsigned char ScTh;
            unsigned char Uid[7];
        } __attribute__((packed));
    public:
        typedef std::unique_ptr<NfcEmuConfig> Ptr;

        void SetEnable(size_t const unit, bool const enable) {
            if(enable) {
                mCfg.Enable |= (1<<unit);
            } else {
                mCfg.Enable &= ~(1<<unit);
            }
        }

        void SetUid(std::vector<unsigned char> const uid) {
            std::copy_n(uid.begin(), std::min(uid.size(), sizeof(mCfg.Uid)), mCfg.Uid);
        }

        bool GetEnable(size_t const unit) {
            return (mCfg.Enable & (1<<unit));
        }

        void SetFlag(size_t const flag, bool const enable) {
            if(enable) {
                mCfg.Flags |= (1<<flag);
            } else {
                mCfg.Flags &= ~(1<<flag);
            }
        }

        bool GetFlag(size_t const flag) {
            return (mCfg.Flags & (1<<flag));
        }
        
        unsigned char const * Begin() const {
            return (unsigned char const *)&mCfg;
        }

        unsigned char const * End() const {
            return ((unsigned char const *)&mCfg) + sizeof(mCfg);
        }


        template<typename Iterator>
        void Update(Iterator first, Iterator last) {
            std::copy(first, last, (unsigned char *)&mCfg);
        }


    private:
        FpgaConfiguration mCfg;
        
    };


}


#endif /* NFCEMUCONFIG_H */
