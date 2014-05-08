/**
 * @file   Nfcemudevice.cpp
 * @author Lukas Schuller
 * @date   Tue Sep 24 23:56:13 2013
 * 
 * @brief  
 * 
 */


#include "NfcEmuDevice.h"
#include <unistd.h>
#include <boost/timer/timer.hpp>
#include "Util.h"
#include "Debug.h"
#include "pthread.h"

using namespace std;
using namespace boost::asio;

namespace NfcEmu {

    void Device::OnRx() {
        //cout << "OnRx buffer: " << Util::FormatHex(mPacketBuf.begin(), mPacketBuf.end()) << endl;
        
        auto pP = ExtractRxPacket();
        while(pP) {
            //  cout << "OnRx packet: " << Util::FormatHex(pP->Begin(), pP->End()) << endl;

            mPacketHandler(*pP);
            pP = ExtractRxPacket();
        }
    }

    Packet::Ptr Device::ExtractRxPacket() {
        //cout << "Extract: " << mPacketBuf.size() << ": " << Util::EncodeHex(mPacketBuf.begin(), mPacketBuf.end()) << endl << endl;
        auto packetEnd = mPacketBuf.end();
        auto p = Packet::FromUpBuffer(mPacketBuf.begin(), mPacketBuf.end(), packetEnd);
        if(p) {
            mPacketBuf.erase(mPacketBuf.begin(), packetEnd);
        }
        //cout << "/Extract" << endl;
        return p;

    }


    void Device::SendPacket(Packet const & packet) {
        //D("Sending packet: " + Util::FormatHex(packet.Begin(), packet.End()));
        vector<unsigned char > buf;
        packet.ToBuffer(back_inserter(buf));
        Write(buffer(buf));
    }

    void Device::StartReceive(PacketCallback & handler) {
        // dispatch rx handler to handle all pending packets
        mIoService.dispatch(boost::bind(&Device::OnRx, this));
        // connect rx handler
        mPacketHandler.connect(handler);
        StartAsyncRead();
        //std::cout << ":: Start receive" << std::endl;
    }

}
