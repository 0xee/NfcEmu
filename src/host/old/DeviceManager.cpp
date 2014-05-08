/**
 * @file   DeviceManager.cpp
 * @author Lukas Schuller
 * @date   Tue Sep 24 21:12:44 2013
 * 
 * @brief  
 * 
 */


#include "DeviceManager.h"
#include "NfcPacketTranslator.h"
#include "NfcEmuException.h"
#include <cassert>
#include "IntelHexFile.h"

using namespace std;

char getch();

DeviceManager::DeviceManager(shared_ptr<Configuration> & pCfg) : mCfg(pCfg) {
    mCfg->RegisterOption("infile", "in", "");
    mCfg->RegisterOption("outfile", "out", "out.txt");

    mCfg->RegisterOption("fx2fw", "fx2", "../../fx2/fx2bridge/fx2bridge.ihx");
    mCfg->RegisterOption("t51fw", "t51", "../../t51/smartcard/smartcard.ihx");
    pCfg->RegisterOption("fpga-cmd","fp", "./fpga_pgm.sh");

    mCfg->RegisterOption("sdac-a", "gain", 220);
    mCfg->RegisterOption("sdac-b", "offset", 60);
    mCfg->RegisterOption("sdac-c", "", 245);
    mCfg->RegisterOption("sdac-d", "", 40);
    mCfg->RegisterOption("miller-th", "mth", 20);
    mCfg->RegisterOption("subcarrier-th", "scth", 60);
    mCfg->RegisterOption("uid", "", "a1b2c3d4");

    mCfg->RegisterFlag("iso-layer4", "iso4", false);
    mCfg->RegisterFlag("mifare", "mf", false);
}
    
shared_ptr<NfcEmuDevice> DeviceManager::ConstructDevice() {
    string inFile = mCfg->GetOption("infile");
    string outFile = mCfg->GetOption("outfile");

    if(inFile.size()) { // construct file device
        return shared_ptr<NfcEmuDevice>(new NfcEmuFileDevice(inFile, outFile));
    } else { // construct usb device
        try {
            shared_ptr<NfcEmuDevice> pDev(new NfcEmuUsbDevice(mCfg->GetOption("fx2fw")));
            ConfigureDevice(pDev);
            if(mCfg->GetMode("sniffer") != "demod")
                UpdateT51(pDev, mCfg->GetOption("t51fw"));
            cerr << ":: USB device initialized" << endl;
            return pDev;
        } catch(UsbException & e)  {
            cerr << ":: Error connecting to usb device (" << e.what() << ")" << endl;
            return nullptr;
        }       

    }
}
    
void DeviceManager::ConfigureDevice(shared_ptr<NfcEmuDevice> & dev, bool const tryFpga) {
    assert(dynamic_pointer_cast<NfcEmuUsbDevice>(dev) != nullptr);
    auto pCfg = GetDeviceCfg();
    auto pRaw = reinterpret_cast<unsigned char const *>(pCfg.get());

    NfcEmuPacket cfgPacket(UnitId::eCfgUnit, pRaw, pRaw + sizeof(NfcEmuCfg));
    NfcPacketTranslator tr(dev);
 
    tr.SendPacket(cfgPacket);
    cout << "wait for fpga" << endl;
    unique_ptr<NfcEmuPacket> pResp;
    size_t maxDelay = 200;
    pResp = tr.WaitForPacket(200);
    if(!pResp) {
        cout << "no response, updating fpga" << endl;
        if(tryFpga) {
            ProgramFpga(dev);
            ConfigureDevice(dev, false);
        }
        else {
            throw NfcEmuException("Device not responding");
        }
    }
    cout << "received config ack packet" << endl;
}
        
void DeviceManager::ProgramFpga(shared_ptr<NfcEmuDevice> & dev) {

    string cmd = mCfg->GetOption("fpga-cmd");
    int ret = system(cmd.c_str());
    cout << ret << endl;

}


void DeviceManager::UpdateT51(std::shared_ptr<NfcEmuDevice> pDev, string const & fw) {

    IntelHexFile t51fw(fw);
    vector<unsigned char> t51image;
    t51fw.GetImage(back_inserter(t51image));
    NfcPacketTranslator tr(pDev);
   
    size_t bs = 128;
    for(int i = 0; i < t51image.size()/bs; ++i) {
        NfcEmuPacket p(UnitId::eL4CpuFw, t51image.begin()+bs*i, t51image.begin()+bs*(i+1));        
        tr.SendPacket(p);
        
    }

    auto pResp = tr.WaitForPacket(200, false);
    if(!pResp || pResp->GetId() != UnitId::eL4CpuFw) {
        throw NfcEmuException("Protocol processor not responding");
    }

}

unique_ptr<NfcEmuCfg> DeviceManager::GetDeviceCfg() {

    unique_ptr<NfcEmuCfg> devCfg(new NfcEmuCfg);

    devCfg->Mode = ModeFromString(mCfg->GetMode("sniffer"));
    devCfg->SDacA = (size_t)mCfg->GetOption("sdac-a");
    devCfg->SDacB = (size_t)mCfg->GetOption("sdac-b");
    devCfg->SDacC = (size_t)mCfg->GetOption("sdac-c");
    devCfg->SDacD = (size_t)mCfg->GetOption("sdac-d");
    devCfg->MillerTh = (size_t)mCfg->GetOption("miller-th");

    devCfg->ScTh = (size_t)mCfg->GetOption("subcarrier-th");
    devCfg->Iso14443aFlags = 0;
    if(mCfg->GetFlag("iso-layer4")) {
        devCfg->Iso14443aFlags |= eEnableIsoL4;
    }
    ParseUid(*devCfg);
    return devCfg;
}

void DeviceManager::ParseUid(NfcEmuCfg & devCfg) {
    string str = mCfg->GetOption("uid");
    //cout << str << endl;
    int idx = 0;
    int pos = 0;
    unsigned char * uid = devCfg.Uid;
    fill(uid, uid+sizeof(devCfg.Uid), 0);
    while(pos != str.size()) {
        uid[idx] = 0;
        for(int i = 0; i < 2;) {            
            int c = str[pos++];
            if(c >= '0' && c <= '9') { uid[idx] = (uid[idx] << 4) + c-'0'; ++i; }
            else if(c >= 'a' && c <= 'f') { uid[idx] = (uid[idx] << 4) + c-'a'+10; ++i; }
            else if(c >= 'A' && c <= 'F') { uid[idx] = (uid[idx] << 4) + c-'A'+10; ++i; }          
            else if(i > 0) break;
            if(pos == str.size()) break;
        }
        ++idx; 
    }

    if(idx == 7) devCfg.Iso14443aFlags |= eLongUid;


}
