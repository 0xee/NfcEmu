/**
 * @file   ServiceAdvertiser.h
 * @author Lukas Schuller
 * @date   Sun Oct  6 14:34:31 2013
 * 
 * @brief  
 * 
 */

#ifndef SERVICEADVERTISER_H
#define SERVICEADVERTISER_H

#include <iostream>
#include <exception>
#include <boost/asio.hpp>
#include <boost/array.hpp>

class AdvertiserException : public std::exception {
public:
    AdvertiserException(const char * msg) : message(msg) { }
    virtual ~AdvertiserException() throw() {}
    virtual char const * what() const throw() {
        return message;
    }
private:
    char const * message;
};

class ServiceAdvertiser {

public:
    ServiceAdvertiser(std::shared_ptr<boost::asio::io_service> const & ios,
                      int const port);
    void AcceptClient(boost::asio::ip::tcp::socket & client,
                      int const port = -1);
private:

    void StartReceive();
    void AcceptCb(const boost::system::error_code& error);
    void ReceiveCb(const boost::system::error_code& error);


    std::shared_ptr<boost::asio::io_service> pIoService;
    boost::asio::ip::udp::socket mAdSocket;
    boost::asio::ip::udp::endpoint remoteEndpoint;
    int mPort;
    boost::array<char, 1> rxBuf;
};

#endif /* SERVICEADVERTISER_H */
