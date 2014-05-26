/**
 * @file   PacketLog.h
 * @author Lukas Schuller
 * @date   Fri Apr 18 17:36:22 2014
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

#ifndef PACKETLOG_H
#define PACKETLOG_H

#include "PacketListener.h"
#include <ostream>
#include <fstream>
#include "ccolor.h"
#include <vector>
#include "UnitId.h"

namespace NfcEmu {

class PacketLog : public PacketListener {

public:
    PacketLog(UnitId const & id, std::ostream & os,
              bool color = false) : mOs(os), 
                                    mAcceptedId(id),
                                    mEnableColor(color) {
    }

    PacketLog(UnitId const & id, std::string const & fileName) : 
        mAcceptedId(id),
        mOs(ref(std::cout)), // temporary
        mEnableColor(false) {

        mLogFile.reset(new std::ofstream(fileName));
        mOs = *mLogFile;
    }

    virtual bool Notify(Packet const & packet);

protected:
    static std::vector<std::string> const debugMsg;

    void ColorizeTs(std::string const & ts);

private:
    UnitId mAcceptedId;
    std::reference_wrapper<std::ostream> mOs;
    bool mEnableColor;
    std::unique_ptr<std::ofstream> mLogFile;

};

}

#endif /* PACKETLOG_H */
