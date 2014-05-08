/**
 * @file   Iso14443aPicc.h
 * @author Lukas Schuller
 * @date   Wed Aug 21 12:14:29 2013
 * 
 * @brief  Nfc Sniffer class derived from abstract class NfcEmu
 * 
 */

#ifndef ISO14443APICC_H
#define ISO14443APICC_H

#include "NfcEmuRole.h"
#include <fstream>
#include <boost/asio.hpp>

using boost::asio::ip::tcp;

class Iso14443aPicc : public NfcEmuRole {

public:
    Iso14443aPicc(std::unique_ptr<NfcPacketTranslator> pTr) : NfcEmuRole(std::move(pTr)),
                                                              readerSocket(ioService) {

        try {
            tcp::acceptor acceptor(ioService, tcp::endpoint(tcp::v4(), 1337));        
            acceptor.accept(readerSocket);
            boost::system::error_code ignored_error;
        }
        catch (std::exception& e)
        {
            std::cerr << e.what() << std::endl;
        }
        
    }

    ~Iso14443aPicc() { }

    virtual bool ProcessData() {
        auto pPacket = pDev->ReceivePacket();
        if(!pPacket) return false;
        pPacket->Print();
        if(pPacket->GetId() == UnitId::eL4CpuApdu) {
            std::cout << "iframe" << std::endl;
            boost::system::error_code ignored_error;
            boost::asio::write(readerSocket, boost::asio::buffer(pPacket->Data(),pPacket->Size()));
        }
        return true;
    }

private:
    boost::asio::io_service ioService;
    tcp::socket readerSocket;
    
};



#endif /* ISO14443APICC_H */
