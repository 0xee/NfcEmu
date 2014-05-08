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

#include "PacketListener.h"
#include "UnitId.h"

#include <future>

namespace NfcEmu {

    class SyncResponseHandler : public PacketListener {

    public:
        typedef std::shared_ptr<std::promise<Packet> > PromisePtr;

        SyncResponseHandler(UnitId const & id) : mAccepting(true), 
                                                 mAcceptedId(id),
                                                 pProm(new PromisePtr::element_type()) {
        }
        
        bool Notify(Packet const & p) {            
            //D("Received packet: " + std::to_string(p.Id()) + ": " + 
            //Util::FormatHex(p.Begin(), p.End()));
            if(mAcceptedId == UnitId::eAny || p.Id().GetUnit() == mAcceptedId) {
                //D("Accepted");
                pProm->set_value(p);
                mAccepting = false;
                return true;
            }            
            return false;
        }    
        
        /** 
         * Returns a shared_ptr pointing to the packet promise.
         * This can be used to make sure the received packet object is
         * still valid, when the handler is destroyed 
         * 
         * @return Promise
         */
        PromisePtr GetPromise() {
            return pProm;
        }
            
        bool IsAccepting() const {
            return mAccepting;
        }   
    private:
        bool mAccepting;
        UnitId mAcceptedId;
        PromisePtr pProm;
            
    };

}
#endif /* RESPONSEHANDLER_H */
