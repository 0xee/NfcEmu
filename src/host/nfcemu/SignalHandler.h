/**
 * @file   SignalHandler.h
 * @author Lukas Schuller
 * @date   Wed Oct 23 18:12:12 2013
 * 
 * @brief  
 * 
 */

#ifndef SIGNALHANDLER_H
#define SIGNALHANDLER_H

#include <memory>
#include <boost/asio.hpp>
#include "Exception.h"

class SignalHandler {

public:
    static void Init(std::shared_ptr<boost::asio::io_service> io);
    static SignalHandler & GetInstance() { 
        if(pInstance) return *pInstance;
        throw Exception("SignalHandler not initialized");
    }

    static bool Running() { return GetInstance().running; }
    static void Stop() { 
        GetInstance().running = false;
        GetInstance().pIo->stop();
        std::cout << "stop" << std::endl;
    }
private:
    bool running;
    static SignalHandler * pInstance;
    static void Handler(int s);
    SignalHandler(std::shared_ptr<boost::asio::io_service> io) : pIo(io), running(true) {}
    std::shared_ptr<boost::asio::io_service> pIo;
};

#endif /* SIGNALHANDLER_H */
