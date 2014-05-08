/**
 * @file   UsbTypes.h
 * @author Lukas Schuller
 * @date   Tue Nov  5 21:40:55 2013
 * 
 * @brief  
 * 
 */


#ifndef USBTYPES_H
#define USBTYPES_H

#include <libusb.h>
#include <system_error>
#include <memory>


namespace Usb {

//    typedef std::shared_ptr<libusb_transfer> TransferPtr;
    typedef libusb_transfer * Transfer;
    typedef libusb_device_handle * DeviceHandle;
    
// custom error conditions enum type:
    enum class UsbErrc { success=0, libError, logicError};
}

namespace std {
    template<> struct is_error_condition_enum<Usb::UsbErrc> : public true_type {};
}

namespace Usb {
    
// custom category:
    class UsbErrorCategory : public std::error_category {
    public:
        virtual const char* name() const noexcept { return "usb"; }
        virtual std::error_condition default_error_condition (int ev) const noexcept {
            if(ev == 0) return std::error_condition(UsbErrc::success);
            if(ev == -1) return std::error_condition(UsbErrc::logicError);
            else    return std::error_condition(UsbErrc::libError);
        }
        virtual bool equivalent (const std::error_code& code, int condition) const noexcept {
            return *this==code.category() &&
                static_cast<int>(default_error_condition(code.value()).value())==condition;
        }
        virtual std::string message(int ev) const noexcept {
            return std::string(libusb_error_name(ev));
        }
    };
    extern UsbErrorCategory errorCategory;

    // make_error_code overload to generate custom conditions:
    std::error_condition make_error_condition (UsbErrc e);

    class Error : public std::system_error {
    public:
        Error(int usbErrno, std::string const & msg = "") :
            std::system_error(std::error_code(usbErrno, errorCategory), msg) { }
        Error(std::string const & msg = "") :
            std::system_error(std::error_code(-1, errorCategory), msg) { }
        
    };

}


#endif /* USBERROR_H */
