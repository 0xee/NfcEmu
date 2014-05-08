/**
 * @file   NfcEmuUnit.h
 * @author Lukas Schuller
 * @date   Fri Apr 18 17:03:03 2014
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

#ifndef NFCEMUUNIT_H
#define NFCEMUUNIT_H


namespace NfcEmu {

    class Unit {
    public:
        UnitId const id;
        
    protected:
        Unit(UnitId id): id(id) { }

    private:

    };


}

#endif /* NFCEMUUNIT_H */
