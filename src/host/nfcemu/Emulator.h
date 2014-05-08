/**
 * @file   Emulator.h
 * @author Lukas Schuller
 * @date   Thu Apr 24 18:53:09 2014
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

#ifndef EMULATOR_H
#define EMULATOR_H

#include "DeviceFactory.h"
#include "NfcEmuConfig.h"
#include <boost/asio.hpp>
#include <boost/utility.hpp>
#include <boost/filesystem.hpp>
#include <stack>
#include <thread>
#include <mutex>
#include <future>

#include "PacketListener.h"

namespace NfcEmu {

    class Emulator : boost::noncopyable {
    public:
        typedef std::unique_ptr<Emulator> Ptr;

        int const cmdReadCfg = 0x01;
        int const cmdWriteCfg = 0x02;


        Emulator() : mpDev(nullptr),
                     mpWorker(new std::thread(std::bind(&Emulator::WorkerRun, this))),
                     mpCfg(new NfcEmuConfig) {
        }

        ~Emulator();

        bool OpenUsbDevice(std::string const & fpgaCfg);

        bool OpenFileDevice(std::string const & inFile, 
                            std::string const & outFile);

        void CloseDevice();

        bool SetFlag(size_t const flag, bool const enable);
        bool GetFlag(size_t const flag);

        bool SetUnitEnable(size_t const unit, bool const enable);
        bool GetUnitEnable(size_t const unit);
        
        bool Send(size_t const unit, std::vector<unsigned char> const & packet); // send packet

        std::vector<unsigned char> SendCmd(size_t const unit,
                                           std::vector<unsigned char> const & packet,
                                           size_t const timeoutMs = 0); // send + sync receive packet
    
        size_t AddLogFile(size_t const unit, std::string const & logFile);

        size_t AddDisplayLog(size_t const unit);

        bool RemoveLog(size_t const logIdx);



        int ConnectSocket(UnitId const & endpoint, int const socket, bool const binary);

        bool Test();
        
        void SetPiccUid(std::vector<unsigned char> const & uid);
    private:
        size_t AddLog(PacketListener::Ptr log);


        void PacketHandler(Packet const &);
        void WorkerRun();

        bool ConfigCb(Packet const & p);
        void WriteConfig();
        void ReadConfig();

        boost::asio::io_service mIo;
        Device::Ptr mpDev;
        NfcEmuConfig::Ptr mpCfg;
        std::unique_ptr<std::thread> mpWorker;
        std::mutex mMtx;


        std::list<PacketListener::Ptr> mExclusiveHandlers;
        std::map<size_t, PacketListener::Ptr> mLogs;
    };

}


#endif /* NFCEMU_H */
