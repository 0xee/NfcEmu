/**
 * @file   SocketConnection.h
 * @author Lukas Schuller
 * @date   Sat May  3 17:57:15 2014
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

#ifndef SOCKETCONNECTION_H
#define SOCKETCONNECTION_H

#include "PacketListener.h"
#include <vector>
#include <boost/asio.hpp>
#include "Debug.h"
#include "Util.h"
#include "NfcEmuDevice.h"

namespace NfcEmu {
    namespace asio =  boost::asio;
    
    class SocketConnection : public PacketListener {
        typedef std::vector<char> BufferType;
    public:

        SocketConnection(asio::io_service & io, 
                         UnitId const & accepted, 
                         Device & device, 
                         int const nativeSocket, 
                         int const id,
                         Owner & owner) : mIo(io),
                                          mAcceptedId(accepted),
                                          mDev(device),
                                          mSocket(mIo),
                                          mStop(false),
                                          mId(id), 
                                          mOwner(owner) {
            mSocket.assign(asio::ip::tcp::v4(), nativeSocket);
            StartReceive();
        }

        ~SocketConnection() {
            //D("dtor");
            mSocket.cancel();
            // socket is closed on the python side
        }

        bool Notify(Packet const & p) {            
            if(p.Id() == mAcceptedId) {
                D(std::string("Local: ") + Util::FormatHex(p.GetData()));
                auto encoded = Util::EncodeHex(p.Begin(), p.End()) + "\n";
                Util::SendAll(mSocket, asio::buffer(encoded));
                return !mStop;
            } else {
//                D(std::string("rejected: ") + std::to_string(p.Id()));
            }
            return false;
        }

        bool IsAccepting() const {
            return !mStop;
        }

    private:

        void RxCallback(const boost::system::error_code& error,
                        std::size_t nReceived) {
            if(!nReceived) {
                D("Client lost");
                mStop = true;
                mOwner.HasDied(mId);
            } else {
                boost::asio::streambuf::const_buffers_type bufs = mRxBuf.data();
                std::string respStr(buffers_begin(bufs), buffers_begin(bufs) + nReceived);
                //D(std::string("Remote: ") + respStr);
                auto resp = Util::DecodeHex(respStr);

                if(resp.size()) {
                    mDev.SendPacket(*Packet::Down(mAcceptedId, resp.begin(), resp.end()));
                }
                mRxBuf.consume(nReceived);
                StartReceive();
            }
        }
        
        void StartReceive() {
            asio::async_read_until(mSocket, mRxBuf, '\n',
                                   boost::bind(&SocketConnection::RxCallback, this,
                                               boost::asio::placeholders::error,
                                               boost::asio::placeholders::bytes_transferred));
        }

        Device & mDev;
        boost::asio::streambuf mRxBuf;
        UnitId mAcceptedId;
        asio::io_service & mIo;
        asio::ip::tcp::socket mSocket;
        
        bool mStop;
        int mId;
        Owner & mOwner;

    };


}
#endif /* SOCKETCONNECTION_H */
