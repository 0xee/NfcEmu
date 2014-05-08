/**
 * @file   PacketListener.h
 * @author Lukas Schuller
 * @date   Fri Apr 18 15:14:18 2014
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

#ifndef PACKETLISTENER_H
#define PACKETLISTENER_H

#include <memory>

namespace NfcEmu {

    class Packet;

    class PacketListener {

    public:
        typedef std::unique_ptr<PacketListener> Ptr;

        PacketListener() { }
        virtual ~PacketListener() {} 

        /** 
         * Inform the listener about a received
         * 
         * @param packet 
         * 
         * @return true if packet was handled by the listener
         */
        virtual bool Notify(Packet const & packet) = 0;

        /** 
         * Check if the listener wants to accept more packets
         * 
         * @return true if the listener accepts at least one future packet
         */
        virtual bool IsAccepting() const {
            return true;
        }


    };

}

#endif /* PACKETLISTENER_H */
