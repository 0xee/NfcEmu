/**
 * @file   NfcEmuPacket.h
 * @author Lukas Schuller
 * @date   Sat Apr 12 15:56:20 2014
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

#ifndef NFCEMUPACKET_H
#define NFCEMUPACKET_H

#include <memory>
#include <vector>
#include <deque>
#include "Util.h"
#include "NfcConstants.h"
#include "UnitId.h"
#include "Debug.h"

namespace NfcEmu {

    class Packet {

    public:
        enum Direction {eUp, eDown};
        typedef std::deque<unsigned char> ContentType;

        typedef std::shared_ptr<Packet> Ptr;
        typedef size_t Ts;

        template<typename Iterator>
        static Ptr FromUpBuffer(Iterator first, Iterator last, Iterator & packetEnd) {
            size_t leading = 0;
            while(first != last) { 
                if(*first == NFC_START) break;
                ++first;
                ++leading;
            }

            //if(leading) D("Leading bytes: " + std::to_string(leading));
            if(first == last || !FindEnd(first, last, packetEnd)) {
                // D("no packet in buffer");
                return nullptr;
            }
            
            // D(Util::FormatHex(first, last));
            // D(Util::FormatHex(first, packetEnd));

            ++first; // omit start byte
            UnitId id(*(first++));
            Ts ts = 0;
            std::copy(first, first+nfcTimeStampSize, (unsigned char *)&ts);
            first += 4;
    // for(int i = 0; i < nfcTimeStampSize; ++i) {
    //             ts <<= 8;
    //             ts |= (Ts)*(first);
    //             ++first;
    //         }
            
            ContentType buf;

            // first now points to the first data byte
            bool escaped = false;
            while(first != packetEnd) {
                if(escaped) {
                    if(*first == NFC_STOP) {
                        return Ptr(new Packet(eUp, id, buf, ts));
                    } else if(*first == NFC_DLE) {
                        buf.push_back(*first);                        
                        escaped = false;
                    }
                } else {
                    if(*first == NFC_DLE) {
                        escaped = true;  
                    } else {
                        buf.push_back(*first);                        
                    }
                }
                ++first;
            }
            return nullptr;
            
        }

        template<typename Iterator>
        static Ptr Down(UnitId id, Iterator first, Iterator last, Ts ts = 0) {
            ContentType bv(first, last);
            return Ptr(new Packet(eDown, id, bv, ts));
        }

        
        
        template<typename BackInserter>
                void ToBuffer(BackInserter bi) const {
            bi = NFC_START;
            ++bi = mId;
            for(int i = 0; i < nfcTimeStampSize; ++i) {
                ++bi = (mTs >> (8*i)) & 0xFF;
            }
            for(auto d : mData) {
                if(d == NFC_DLE) ++bi = NFC_DLE;
                ++bi = d;
            }
            ++bi = NFC_DLE;
            ++bi = NFC_STOP;
        }


        template<typename Iterator>
        static bool FindEnd(Iterator first, Iterator last, Iterator & packetEnd) {
            if(first == last || *first != NFC_START) return false;
            ++first;
            if(first++ == last) return false;
            for(int i = 0; i < nfcTimeStampSize+1; ++i) {
                if(first++ == last) return false;
            }
            // first now points to the first data byte
            bool escaped = false;
            while(first != last) {
                if(escaped && *first == NFC_STOP) {
                    packetEnd = ++first;
                    return true;
                } else {
                    escaped = *first == NFC_DLE;
                }
                ++first;
            }
            return false;
        }
        
        Direction Dir() const {
            return mDir;
        }

        UnitId Id() const {
            return mId;
        }

        size_t TimeStamp() const {
            return (double)mTs*tsToUs;
        }
        
        void SetData(ContentType const & v) {
            mData = v;
        }
        
        void Prepend(unsigned char const c) {
            mData.push_front(c);
        }

        ContentType const & GetData() const {
            return mData;
        }

        ContentType::iterator Begin() {
            return mData.begin();
        }

        ContentType::iterator End() {
            return mData.end();
        }

        ContentType::const_iterator Begin() const {
            return mData.cbegin();
        }

        ContentType::const_iterator End() const {
            return mData.cend();
        }

    protected:
        Packet(Direction dir, UnitId id, ContentType & data, Ts ts = 0) : mDir(dir), mId(id), mTs(ts) {
            mData.swap(data);
        }

    private:
        Direction mDir;
        UnitId mId;
        ContentType mData;
        Ts mTs;

    };

}

#endif /* NFCEMUPACKET_H */
