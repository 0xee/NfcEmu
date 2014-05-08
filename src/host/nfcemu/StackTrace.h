/**
 * @file   StackTrace.h
 * @author Lukas Schuller
 * @date   Tue Nov 19 14:41:09 2013
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

#ifndef STACKTRACE_H
#define STACKTRACE_H

#include <execinfo.h>
#include <signal.h>
#include <cstdlib>
#include <cstdio>
#include <unistd.h>

class StackTrace {

public:
    static void Print() {
        void *array[10];
        size_t size;
// get void*'s for all entries on the stack
        size = backtrace(array, 10);
        FILE * fd = popen("c++filt","w");
// print out all the frames to stderr
        backtrace_symbols_fd(array, size, fileno(fd));
    }

private:
    StackTrace() = delete;
    StackTrace(StackTrace &) = delete;
    StackTrace & operator=(StackTrace &) = delete;


};

#endif /* STACKTRACE_H */
