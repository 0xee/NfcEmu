/**
 * @file   PyWrapper.h
 * @author Lukas Schuller
 * @date   Fri Apr 25 18:40:54 2014
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

#ifndef PYWRAPPER_H
#define PYWRAPPER_H

#include "Emulator.h"
#include "Util.h"
#include "IntelHexFile.h"

#include <thread>
#include <boost/python.hpp>
#include <boost/python/stl_iterator.hpp>
#include <boost/asio.hpp>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <unistd.h>

namespace NfcEmu {
    namespace py = boost::python;
    namespace asio = boost::asio;
    class PyWrapper : boost::noncopyable {
    public:
        PyWrapper() : mpEmu(new Emulator()) {
        }
        
        ~PyWrapper() {
            //std:: cout << "DTor called" << std::endl;
        }
        bool OpenUsbDevice(std::string const & fpgaConfiguration) {
            return mpEmu->OpenUsbDevice(fpgaConfiguration);
        }

        bool OpenFileDevice(std::string const & inFile, 
                            std::string const & outFile = "") {
            return mpEmu->OpenFileDevice(inFile, outFile);
        }

        void CloseDevice() {
            mpEmu->CloseDevice();
        }

        bool SetFlag(size_t const flag, bool const enable) {
            return mpEmu->SetFlag(flag, enable);
        }

        bool GetFlag(size_t const flag) {
            return mpEmu->GetFlag(flag);
        }

        bool SetUnitEnable(UnitId::Id const unit, bool const enable) {
            return mpEmu->SetUnitEnable(unit, enable);
        }
        bool GetUnitEnable(UnitId::Id const unit) {
            return mpEmu->GetUnitEnable(unit);
        }

        void SetPiccUid(py::list uid) {
            std::vector<unsigned char> vec;
            ListToVector(uid, vec);
            mpEmu->SetPiccUid(vec);
        }
        
        bool Send(UnitId::Id const unit, py::list data) {
            std::vector<unsigned char> vec;
            ListToVector(data, vec);
            return mpEmu->Send(unit, vec);
        }

        bool SendIHexFile(UnitId::Id const unit, std::string const & fileName) {
            size_t const bs = 128;
            IntelHexFile ihex(fileName);
            std::vector<unsigned char> image;
            ihex.GetImage(back_inserter(image));
            image.resize(4096);
            for(int i = 0; i < 4096; i += bs) {
                if(!mpEmu->Send(unit, std::vector<unsigned char>(image.begin()+i,
                                                                 image.begin()+i+bs))) return false;
                std::cout << "." << std::flush;
            }
            std::cout << std::endl;
            return true;
        }

        py::list SendCmd(UnitId::Id const unit, py::list cmd, size_t const timeoutMs = 0) {
            std::vector<unsigned char> vec;
            ListToVector(cmd, vec);
            try {
                auto resp =  mpEmu->SendCmd(unit, vec, timeoutMs);
                py::list pyResp;
                for(auto c : resp) { pyResp.append(c); }
//std::cout << "Response: " << Util::FormatHex(resp.begin(), resp.end()) << std::endl;
                return pyResp;
            } catch(std::exception & e) {
                D(std::string("Exception caught: ") + e.what());
                return py::list();
            }
        }
        

        bool AddLogFile(UnitId::Id const unit, std::string const & logFile) {
            return mpEmu->AddLogFile(unit, logFile);
        }

        bool RemoveLog(size_t const logIdx) {
            return mpEmu->RemoveLog(logIdx);
        }

        void AddDisplayLog(UnitId::Id const unit) {
            mpEmu->AddDisplayLog(unit);
        }

        int ConnectSocket(UnitId const & endpoint, size_t const sock, bool const binary = true) {
            return mpEmu->ConnectSocket(endpoint, sock, binary);
        }

        void WaitForDisconnect(size_t const idx) {
            mpEmu->WaitForDisconnect(idx);
        }

        bool DisconnectSocket(int const idx) {
            return mpEmu->DisconnectSocket(idx);
        }

        bool Test() {
            return mpEmu->Test();
        }

    private:


        template<typename T>
        void ListToVector(py::object o, std::vector<T> & v) {
            py::stl_input_iterator<T> begin(o);
            py::stl_input_iterator<T> end;
            v = std::vector<T>(begin,end);
        }

        Emulator::Ptr mpEmu;
    };



}


#endif /* PYWRAPPER_H */
