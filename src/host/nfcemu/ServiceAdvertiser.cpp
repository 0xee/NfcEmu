


/**
 * @file   ServiceAdvertiser.cpp
 * @author Lukas Schuller
 * @date   Sun Oct  6 14:58:20 2013
 * 
 * @brief  
 * 
 */

#include "ServiceAdvertiser.h"
#include <string>
#include <iostream>
#include "Debug.h"

#include <boost/bind.hpp>
#include <boost/lexical_cast.hpp>

using namespace std;
using namespace boost::asio;
using namespace boost::asio::ip;


ServiceAdvertiser::ServiceAdvertiser(shared_ptr<io_service> const & ios,
                                     int const port) : 
    pIoService(ios), mPort(port),
    mAdSocket(*pIoService, udp::endpoint(address_v4::any(), port))
{
    socket_base::broadcast option(true);
    mAdSocket.set_option(option);
}

void ServiceAdvertiser::AcceptClient(tcp::socket & client, int const port) {
    int actualPort = (port == -1) ? mPort : port;
    tcp::acceptor acc(*pIoService, tcp::endpoint(tcp::v4(), actualPort));
    acc.async_accept(client, boost::bind(&ServiceAdvertiser::AcceptCb, 
                                      this,  boost::asio::placeholders::error));
    StartReceive();
    pIoService->run();
    
}

void ServiceAdvertiser::StartReceive()
{
    mAdSocket.async_receive_from(buffer(rxBuf), remoteEndpoint,
                              boost::bind(&ServiceAdvertiser::ReceiveCb, this,
                                          boost::asio::placeholders::error));
}

void ServiceAdvertiser::AcceptCb(const boost::system::error_code& error) {    
        cout << "accept" << endl;
    if(error) {
        Fatal(string("Error ") + boost::lexical_cast<std::string>(error.value()) + " while accepting connection");
        throw AdvertiserException("Error while accepting connection");
    }    
    mAdSocket.cancel();
    pIoService->stop();
    pIoService->reset();
}

void ServiceAdvertiser::ReceiveCb(const boost::system::error_code& error)
  {
    if (!error || error == error::message_size)
    {
        Info("Received udp request from " + boost::lexical_cast<std::string>(remoteEndpoint.address()));
      string message = "b";
      mAdSocket.send_to(buffer(message), remoteEndpoint);
      StartReceive();
    }
  }
