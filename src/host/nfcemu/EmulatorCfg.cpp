/**
 * @file   EmulatorCfg.cpp
 * @author Lukas Schuller
 * @date   Mon Oct  7 16:50:34 2013
 * 
 * @brief  
 * 
 */

#include "EmulatorCfg.h"

using namespace std;
using namespace NfcEmu;

EmulatorCfg::EmulatorCfg(Configuration & cfg) {
    mMode = ModeFromString(cfg.GetMode("sniffer"));

    cfg.RegisterOption("miller-th", "mth", 10);
    cfg.RegisterOption("subcarrier-th", "scth", 30);
    cfg.RegisterOption("picc-uid", "uid", "a1b2c3d4");    

    mMillerTh = cfg.GetOption("miller-th");
    mSubCarrierTh = cfg.GetOption("subcarrier-th");
    mPiccUid = cfg.GetOption("picc-uid").Str();
}
