/**
 * @file   UsbTypes.cpp
 * @author Lukas Schuller
 * @date   Tue Nov  5 22:17:50 2013
 * 
 * @brief  
 * 
 */


#include "UsbTypes.h"

namespace Usb { 
    UsbErrorCategory errorCategory;

    std::error_condition make_error_condition (UsbErrc e) {
        return std::error_condition(static_cast<int>(e), errorCategory);
    }

}
