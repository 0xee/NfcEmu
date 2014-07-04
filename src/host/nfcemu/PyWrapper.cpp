/**
 * @file   PyWrapper.cpp
 * @author Lukas Schuller
 * @date   Thu Apr 24 18:56:47 2014
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

#include <boost/python.hpp>
#include "PyWrapper.h"
#include <vector>
#include "UnitId.h"

using namespace std;
using namespace boost::python;
using namespace NfcEmu;
using namespace boost::asio;

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS(OpenFileDeviceOverloads, 
                                       OpenFileDevice, 1, 2)

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS(ConnectSocketOverloads, 
                                       ConnectSocket, 2, 3)

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS(SendCmdOverloads, 
                                       SendCmd, 2, 3)

BOOST_PYTHON_MODULE(nfcemu)
{
    class_<PyWrapper, boost::noncopyable>("NfcEmu")
        .def("OpenFileDevice", &PyWrapper::OpenFileDevice, OpenFileDeviceOverloads())
        .def("OpenUsbDevice", &PyWrapper::OpenUsbDevice)
        .def("CloseDevice", &PyWrapper::CloseDevice)
        .def("SetFlag", &PyWrapper::SetFlag)
        .def("GetFlag", &PyWrapper::GetFlag)
        .def("SetUnitEnable", &PyWrapper::SetUnitEnable)
        .def("GetUnitEnable", &PyWrapper::GetUnitEnable)
        .def("SetPiccUid", &PyWrapper::SetPiccUid)
        .def("Send", &PyWrapper::Send)
        .def("SendIHexFile", &PyWrapper::SendIHexFile)
        .def("SendCmd", &PyWrapper::SendCmd, SendCmdOverloads())
        .def("AddLogFile", &PyWrapper::AddLogFile)
        .def("AddDisplayLog", &PyWrapper::AddDisplayLog)
        .def("RemoveLog", &PyWrapper::RemoveLog)
        .def("ConnectSocket", &PyWrapper::ConnectSocket, ConnectSocketOverloads())
        .def("DisconnectSocket", &PyWrapper::DisconnectSocket)
        .def("WaitForDisconnect", &PyWrapper::WaitForDisconnect)
        .def("Test", &PyWrapper::Test)        
        ;

    class_<UnitId>("UnitId", init<UnitId::Id, UnitId::Flags>())
        ;

    enum_<UnitId::Id>("Id")
        .value("ControlReg", UnitId::eControlReg)
        .value("Cpu", UnitId::eCpu)
        .value("CpuFw", UnitId::eCpuFw)
        .value("EnvelopeStream", UnitId::eEnvelopeStream)
        .value("TestStream", UnitId::eTestStream)
        .value("Iso14443aPicc", UnitId::eIso14443aPicc)
        .value("Iso14443aPcd", UnitId::eIso14443aPcd)
        .value("IsoLayer4Picc", UnitId::eIsoLayer4Picc)
        .value("IsoLayer4Pcd", UnitId::eIsoLayer4Pcd)
        .value("Any", UnitId::eAny)
        ;

    enum_<UnitId::Flags>("Flags")
        .value("Logic", UnitId::eLogic)
        .value("Down", UnitId::eDown)
        .value("Up", UnitId::eUp)
        .value("Status", UnitId::eStatus)
        .value("Special", UnitId::eSpecial)
        .value("Debug", UnitId::eDebug)
        .value("All", UnitId::eAll) 
        ;

}
