/**
 * @file   SignalHandler.cpp
 * @author Lukas Schuller
 * @date   Wed Oct 23 18:16:24 2013
 * 
 * @brief  
 * 
 */

#include "SignalHandler.h"
#include "StackTrace.h"
#include <iostream>

using namespace std;

SignalHandler * SignalHandler::pInstance = 0;

void SignalHandler::Handler(int s){
    cout << endl << "Caught "; 
    
    switch(s) {
    case SIGINT:
        cout << "SIGINT";
        break;
    case SIGTERM:
        cout << "SIGTERM";
        StackTrace::Print();        
        break;
    case SIGSEGV:
        StackTrace::Print();
        terminate();
        break;
    default:
        cout << "signal " << s;
        break;
    }
    cout << ", exiting" << endl;
    if(Running()) {
        Stop();
    } else {
        exit(0);
    }        
}



void SignalHandler::Init(std::shared_ptr<boost::asio::io_service> io) {
    if(pInstance) delete pInstance;
    pInstance = new SignalHandler(io);
    struct sigaction sigIntHandler;
    sigIntHandler.sa_handler = Handler;
    sigemptyset(&sigIntHandler.sa_mask);
    sigIntHandler.sa_flags = 0;
    sigaction(SIGINT, &sigIntHandler, NULL);
    sigaction(SIGSEGV, &sigIntHandler, NULL);
    sigaction(SIGTERM, &sigIntHandler, NULL);
}


