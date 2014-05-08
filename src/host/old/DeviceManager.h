/**
 * @file   DeviceManager.h
 * @author Lukas Schuller
 * @date   Tue Sep 24 20:50:17 2013
 * 
 * @brief  Constructs NfcEmuDevices
 * 
 */

#ifndef DEVICEMANAGER_H
#define DEVICEMANAGER_H

#include "Configuration.h"

#include "NfcEmuUsbDevice.h"
#include "NfcEmuFileDevice.h"
#include "NfcEmuDeviceCfg.h"

#include <memory>

class DeviceManager{
    
public:
    DeviceManager(std::shared_ptr<Configuration> & pCfg);
    std::shared_ptr<NfcEmuDevice> ConstructDevice();
    
    
    
    
private:
    void ConfigureDevice(std::shared_ptr<NfcEmuDevice> & dev, bool const tryFpga = true);
    void ProgramFpga(std::shared_ptr<NfcEmuDevice> & dev);
    void UpdateT51(std::shared_ptr<NfcEmuDevice> pDev, std::string const & fw);
    std::unique_ptr<NfcEmuCfg> GetDeviceCfg();
    void ParseUid(NfcEmuCfg & devCfg);

    DeviceManager();
    DeviceManager(DeviceManager &);
    DeviceManager & operator= (DeviceManager &);


    std::shared_ptr<Configuration> mCfg;

};


#endif /* DEVICEMANAGER_H */
