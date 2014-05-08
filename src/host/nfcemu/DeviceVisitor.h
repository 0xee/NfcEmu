/**
 * @file   DeviceVisitor.h
 * @author Lukas Schuller
 * @date   Fri Oct  4 13:09:20 2013
 * 
 * @brief  
 * 
 */

#ifndef DEVICEVISITOR_H
#define DEVICEVISITOR_H

namespace NfcEmu {
    class UsbDevice;
    class FileDevice;


    class DeviceVisitor {

    public:
        virtual void Visit(UsbDevice &) = 0;
        virtual void Visit(FileDevice &) = 0;


    };

}
#endif /* STREAMDEVICEVISITOR_H */
