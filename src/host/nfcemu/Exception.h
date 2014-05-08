/**
 * @file   Exception.h
 * @author Lukas Schuller
 * @date   Tue Sep  3 17:08:12 2013
 * 
 * @brief  
 * 
 */

#ifndef EXCEPTION_H
#define EXCEPTION_H

#include <exception>

class Exception : public std::exception {
public:
    Exception(const char * msg) : message(msg) { }
    virtual ~Exception() throw() {}
    virtual char const * what() const throw() {
        return message;
    }
private:
    char const * message;
};

#endif /* EXCEPTION_H */
