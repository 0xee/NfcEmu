/**
 * @file   Util.h
 * @author Lukas Schuller
 * @date   Wed Oct  9 17:21:11 2013
 * 
 * @brief  
 * 
 */

#ifndef UTIL_H
#define UTIL_H

#include <string>
#include <vector>
#include <boost/asio.hpp>
#include <iomanip>
#include <sstream>
#include <mutex>

namespace Util {
        typedef std::unique_lock<std::mutex> ScopedLock;


    typedef unsigned char Byte;
    
    template <typename T>
    void SendAll(boost::asio::basic_stream_socket<T> & s, boost::asio::const_buffer const & buf) {
        size_t len = boost::asio::buffer_size(buf);
        size_t sent = 0;
        while(sent < len) {
            sent += s.send(boost::asio::buffer(buf+sent));
        }
    }

    
    std::vector<unsigned char>  DecodeHex(std::string const & hex);

    template <typename I>
    std::string EncodeHex(I first, I last, std::string delim = "") {
        std::ostringstream oss;
        oss << std::hex;
        while(first != last) {
            oss << std::setfill('0') << std::setw(2) << static_cast<size_t>(*first) << delim;
            ++first;
        }

        return oss.str();
    }

    std::string RemoveWhitespace(std::string const & str); 
    
    template<typename InputIter>
    std::string FormatHex(InputIter first, InputIter last) {

        return EncodeHex(first, last, " ");
    }

    template<typename Container>
    std::string FormatHex(Container const & c) {
        auto first = c.begin();
        auto last = c.end();
        return EncodeHex(first, last, " ");
    }
    
    template <typename Iterator>
    class IteratorPair {
    public:
        IteratorPair ( Iterator first, Iterator last) : f_ (first), l_ (last) {}
        Iterator begin () const { return f_; }
        Iterator end   () const { return l_; }

    private:
        Iterator f_;
        Iterator l_;
    };


    template <typename Iterator>
    IteratorPair<Iterator> Range( Iterator f, Iterator l ) {
        return IteratorPair<Iterator> ( f, l );
    }


}

#endif /* UTIL_H */
