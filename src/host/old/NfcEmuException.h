/**
 * @file   NfcEmuException.h
 * @author Lukas Schuller
 * @date   Tue Sep  3 17:08:12 2013
 * 
 * @brief  
 * 
 */

#ifndef NFCEMUEXCEPTION_H
#define NFCEMUEXCEPTION_H

#include <exception>

class NfcEmuException : public std::exception {
public:
    NfcEmuException(const char * msg) : message(msg) { }
    virtual ~NfcEmuException() throw() {}
    virtual char const * what() const throw() {
        return message;
    }
private:
    char const * message;
};

#endif /* NFCEMUEXCEPTION_H */
