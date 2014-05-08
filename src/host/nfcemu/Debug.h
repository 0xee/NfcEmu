/**
 * @file   Debug.h
 * @author Lukas Schuller
 * @date   Thu Dec 19 14:10:54 2013
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

#ifndef DEBUG_H
#define DEBUG_H

#include <iostream>
#include <string>
#include <boost/lexical_cast.hpp>
#include <mutex>

using boost::lexical_cast;

class Debug {

public:
    static void Print(std::string const & msg, size_t level = 1) {
        std::unique_lock<std::mutex> lock(sMutex);
        if(level <= sLevel)
            std::cout << ":: " << msg << std::endl;
    }

    static void D(size_t level = 1) {
        std::unique_lock<std::mutex> lock(sMutex);
        if(level <= sLevel)
            std::cout << ":: Debug" << std::endl;
    }

    static void SetLevel(size_t const l) {
        std::unique_lock<std::mutex> lock(sMutex);
        sLevel = l;
    }

    static size_t GetLevel() {
        std::unique_lock<std::mutex> lock(sMutex);
        return sLevel;
    }

    static std::mutex sMutex;


private:
    static size_t sLevel;

};


inline void D(std::string const & msg, size_t level = 1) {
    Debug::Print(msg, level);
}

inline void Error(std::string const & msg) {
    Debug::Print(msg, 1);

}

inline void Fatal(std::string const & msg) {
    Debug::Print(msg, 0);
}


inline void Info(std::string const & msg) {
    Debug::Print(msg, 3);
}

inline void Warning(std::string const & msg) {
    Debug::Print(msg, 2);
}



#endif /* DEBUG_H */
