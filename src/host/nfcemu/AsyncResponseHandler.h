/**
 * @file   SyncResponseHandler.h
 * @author Lukas Schuller
 * @date   Sat Apr 26 16:36:38 2014
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

#ifndef SYNCRESPONSEHANDLER_H
#define SYNCRESPONSEHANDLER_H

#include <boost/signals2.hpp>

#include "PacketListener.h"
#include "UnitId.h"

namespace NfcEmu {

    class SyncResponseHandler : public PacketListener {

    public:
        typedef boost::signals2::signal<bool (Packet const &, 
                                              SyncResponseHandler &)> CompletionSignal;
        typedef CompletionSignal::slot_type CompletionCallback;

        SyncResponseHandler(CompletionCallback cb) : mAccepting(true) {
            mSig.connect(cb);
        }

        bool Notify(Packet const & p) {            
            return *mSig(p, *this);
        }    
    
        void Destroy() {
            mAccepting = false;
        }
        

        bool IsAccepting() {
            return mAccepting;
        }
    private:
        bool mAccepting;
        CompletionSignal mSig;

    };

}
#endif /* SYNCRESPONSEHANDLER_H */
