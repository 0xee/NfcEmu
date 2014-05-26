/**
 * @file   Emulator.cpp
 * @author Lukas Schuller
 * @date   Fri Oct  4 19:11:33 2013
 * 
 * @brief  
 * 
 */

#include "Emulator.h"
#include "Util.h"
#include "PacketLog.h"
#include <fstream>
#include "SyncResponseHandler.h"
#include "SocketConnection.h"

#define DBG_LOCKING 0

#if DBG_LOCKING == 2
#define LOCK_SCOPE2 D("locked scope: " + to_string(__LINE__))
#elif DBG_LOCKING == 1
#define LOCK_SCOPE2 D("locked scope: " + to_string(__LINE__)); ScopedLock critical(mMtx)
#else
#define LOCK_SCOPE2 ScopedLock critical(mMtx)
#endif

#define LOCK_SCOPE LOCK_SCOPE2

using namespace Util;
using namespace std;

namespace NfcEmu {

    Emulator::~Emulator() {
        ScopedLock critical(mMtx);
        if(mpDev) {
            mpDev->StopReceive();
        }
        mIo.stop();
        mpWorker->join();
    }

    bool Emulator::OpenUsbDevice(string const & fpgaCfg) {
        if(mpDev) {
            return false;
        }
        
        mpDev = DeviceFactory::BuildUsbDevice(mIo);
        if(mpDev) {            
            Device::PacketReceived::slot_type slot = boost::bind(&Emulator::PacketHandler, 
                                                                 this, _1);            
            mpDev->StartReceive(slot);
            bool firstTry = true;
            while(true) {
                try {
                    ReadConfig();
                    //D("Received response from device");
                    break;
                } catch(exception & e) {
                    //D(string("e: ") + e.what());
                    if(firstTry) {
                        D("No response, programming FPGA");
                        system(string("../scripts/fpga_pgm.sh ").append(fpgaCfg).c_str());
                        firstTry = false;
                    } else {
                        D("Error initializing device");
                        return false;
                    }
                } 
            }
    
        }
        return mpDev != nullptr;
    }

    bool Emulator::OpenFileDevice(std::string const & inFile, 
                                  std::string const & outFile) {

        boost::filesystem::path realOutFile(outFile);
        if(outFile.empty()) realOutFile.replace_extension("out.log");

        mpDev = DeviceFactory::BuildFileDevice(mIo, boost::filesystem::path(inFile), realOutFile);
        return mpDev != nullptr;
    }


    void Emulator::CloseDevice() {
        LOCK_SCOPE;
        mpDev.reset();
    }

    bool Emulator::SetFlag(size_t const flag, bool const enable) {
        ReadConfig();
        mpCfg->SetFlag(flag, enable);
        WriteConfig();
    }

    bool Emulator::GetFlag(size_t const flag) {
        ReadConfig();
        return mpCfg->GetFlag(flag);
    }

    bool Emulator::SetUnitEnable(size_t const unit, bool const enable) {
        ReadConfig();        
        mpCfg->SetEnable(unit, enable);
        WriteConfig();

    }

    bool Emulator::GetUnitEnable(size_t const unit) {
        ReadConfig();
        return mpCfg->GetEnable(unit);
    }
    
    void Emulator::SetPiccUid(std::vector<unsigned char> const & uid) {
        D("UID: " + Util::FormatHex(uid.begin(), uid.end()));
        ReadConfig();    
        mpCfg->SetUid(uid);
        WriteConfig();
    }
        
    bool Emulator::Send(size_t const unit, std::vector<unsigned char> const & packet) {
        auto p = Packet::Down(UnitId(unit), packet.begin(), packet.end());
        try {
            mpDev->SendPacket(*p);
        } catch(exception e) {
            D(string("error: ") + e.what());
            return false;
        }
        return true;
    }

    std::vector<unsigned char> Emulator::SendCmd(size_t const unit,
                                                 std::vector<unsigned char> const & packet, 
                                                 size_t const timeoutMs) {

        PacketListener::Ptr pRh(new SyncResponseHandler(UnitId(unit)));
        auto pPacketPromise = dynamic_cast<SyncResponseHandler*>(pRh.get())->GetPromise();
        auto packetFuture = pPacketPromise->get_future();
        size_t handler;
        {
            LOCK_SCOPE;
            handler = NextIdx(mExclusiveHandlers);
            mExclusiveHandlers.emplace(handler, pRh);
        }

        mpDev->SendPacket(*Packet::Down(UnitId(unit), packet.begin(), packet.end()));

        if(timeoutMs && 
           packetFuture.wait_for(chrono::milliseconds(timeoutMs)) == future_status::timeout) { 
            LOCK_SCOPE;
            mExclusiveHandlers.erase(handler);
            throw runtime_error("Response timeout");
        }

        // if the handler got called, it has been removed from the handler
        // stack automatically.
        
        auto resp = packetFuture.get();


        return std::vector<unsigned char>(resp.Begin(), resp.End());
    }

    size_t Emulator::AddLog(PacketListener::Ptr log) {
        LOCK_SCOPE;
        size_t idx = NextIdx(mLogs);
        mLogs.emplace(idx, log);
        
        return idx;                
    }

    size_t Emulator::AddLogFile(size_t const unit, std::string const & logFile) {
        UnitId id(unit);        
        return AddLog(PacketListener::Ptr(new PacketLog(id, logFile)));
    }

    size_t Emulator::AddDisplayLog(size_t const unit) {
        UnitId id(unit);
        return AddLog(PacketListener::Ptr(new PacketLog(id, cout, true)));
    }

    bool Emulator::RemoveLog(size_t const logIdx) {
        LOCK_SCOPE;
        if(mLogs.find(logIdx) == mLogs.end()) return false;
        mLogs.erase(logIdx);
        return true;
    }

    int Emulator::ConnectSocket(UnitId const & endpoint, int const socket, bool const binary) {
        LOCK_SCOPE;
        PacketListener::Ptr pSc(new SocketConnection(endpoint, *mpDev, socket));
        size_t newIdx = NextIdx(mExclusiveHandlers);
        mExclusiveHandlers.emplace(newIdx, pSc);
        return newIdx;
    }

    bool Emulator::DisconnectSocket(int const idx) {
        LOCK_SCOPE;
        if(mExclusiveHandlers.find(idx) == mExclusiveHandlers.end()) return false;
        mExclusiveHandlers.erase(idx);
        return true;
    }


    bool Emulator::Test() {
    }


    void Emulator::WorkerRun() {
        //D("WorkerRun");
        boost::asio::io_service::work work(mIo);
        mIo.run();
        //D("WorkerRun returns");
    }


    void Emulator::PacketHandler(Packet const & p) {
        LOCK_SCOPE;
        UnitId id(p.Id().GetUnit());

        auto first = mExclusiveHandlers.begin();
        auto last = mExclusiveHandlers.end();
    
        while(first != last) {
            // look for a handler which accepts the packet
            if(first->second->Notify(p)) {
                // check if the handler is still accepting
                if(!first->second->IsAccepting()) {
                    mExclusiveHandlers.erase(first);
                }
                break;
            }
            ++first;
        }
        for(auto & log : mLogs) {
            log.second->Notify(p); 
        }
    }

    void Emulator::WriteConfig() {
        LOCK_SCOPE;
        Packet::ContentType cfgPacket;
        cfgPacket.push_back(cmdWriteCfg);
        copy(mpCfg->Begin(), mpCfg->End(), back_inserter(cfgPacket));
        cfgPacket.push_back(0xee); // dummy
        //D("Sending: " + FormatHex(cfgPacket.begin(), cfgPacket.end()));

        mpDev->SendPacket(*Packet::Down(UnitId::eControlReg, cfgPacket.begin(), cfgPacket.end()));
    }

    bool Emulator::ConfigCb(Packet const & p) {
        //D("Response: " + FormatHex(p.Begin(), p.End()));
        mpCfg->Update(p.Begin(), p.End());
        return true;
    }

    void Emulator::ReadConfig() {
        auto resp = SendCmd(UnitId::eControlReg, vector<unsigned char>(1, cmdReadCfg), 100);
        mpCfg->Update(resp.begin(), resp.end());
    }
    

}
