/**
 * @file   NfcEmuDevice.h
 * @author Lukas Schuller
 * @date   Mon Nov 18 16:32:52 2013
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


#ifndef NFCEMUDEVICE_H
#define NFCEMUDEVICE_H

#include "NfcEmuPacket.h"
#include "DeviceVisitor.h"
#include <deque>
#include <memory>
#include <boost/asio.hpp>
#include <boost/signals2.hpp>
#include <list>

#include "PacketListener.h"
namespace NfcEmu {
    class Device {
    
    public:
        typedef std::unique_ptr<Device> Ptr;
        
        typedef boost::signals2::signal<void (Packet const &)> PacketReceived;
        typedef PacketReceived::slot_type PacketCallback;

        Device(boost::asio::io_service & io) : mIoService(io), 
                                               mpWork(new boost::asio::io_service::work(io)) {}
        virtual ~Device() {}

//        Packet::Ptr ReceivePacket(size_t const timeout);
        void SendPacket(Packet const & packet);
    
        void StartReceive(PacketCallback & handler);
        virtual void Accept(DeviceVisitor & visitor) = 0; 
        virtual void StopReceive() = 0;    

    protected:    
        virtual void StartAsyncRead() = 0;
        void OnRx();
        virtual void Write(boost::asio::const_buffer buf) = 0;
        virtual size_t Read(boost::asio::mutable_buffer buf) = 0;

        boost::asio::io_service & mIoService;
        std::deque<unsigned char> mPacketBuf;
        PacketReceived mPacketHandler;
        std::unique_ptr<boost::asio::io_service::work> mpWork;

    private:
        Packet::Ptr ExtractRxPacket();
    };
}
#endif /* NFCEMUDEVICE_H */
