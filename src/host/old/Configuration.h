/**
 * @file   Configuration.h
 * @author Lukas Schuller
 * @date   Tue Sep 24 15:51:08 2013
 * 
 * @brief  
 * 
 */

#ifndef CONFIGURATION_H
#define CONFIGURATION_H

#include <string>
#include <map>
#include <vector>
#include <sstream>
#include <exception>

class OptionName {
public:

    OptionName(std::string const & l, std::string const & s = "") : l(l), s(s) {}
    bool operator==(std::string const & rhs) const {
        return (rhs == l) || (s.size() && rhs.size() && (rhs == s)) ;
    }
    bool operator<(OptionName const & rhs) const {
        bool ret = (l < rhs.l) && !(rhs == l) && !(rhs == s) ;
        //std::cout << Long() << "/" << Short() 
        //          << " < " << rhs.l << "/" << rhs.s
        //          << " = " << ret << std::endl;
        return ret;
    }

    std::string const & Long() const { return l; }
    std::string const & Short() const { return s; }
    
private:
    std::string l, s;
};


/// dirty, dirty class that converts anything to a string and back 
class OptionValue {
public:
    OptionValue() {}
    OptionValue(std::string const & s) {
        value = s;
    }
    OptionValue(char const * s) {
        value = s;
    }
    OptionValue(int v) {
        std::ostringstream oss;
        oss << v;
        value = oss.str();
    }

    
    operator std::string() const {
        return value;
    }
    operator int() const {
        std::istringstream iss(value);
        int v;
        iss >> v;
        return v;
    }
    std::string Str() const {
        return value;
    }
private:
    std::string value;
};


class Configuration {
    
public:
    class ConfigException : public std::exception {
    public:
        ConfigException(const char * msg) : message(msg) { }
        virtual ~ConfigException() throw() {}
        virtual char const * what() const throw() {
            return message;
        }
    private:
    char const * message;

    };
    Configuration(int argc, char * argv[]);

    std::string GetMode(std::string const & defaultMode = "") const;

    void RegisterOption(std::string const & longName,
                        std::string const shortName,
                        OptionValue const & defaultValue = 0);
    void RegisterOption(OptionName const & name, OptionValue const & defaultValue = 0);

    void RegisterFlag(std::string const & longName,
                      std::string const shortName,
                      bool const defaultValue = false);
    void RegisterFlag(OptionName const & name, bool const defaultValue = false);
    void Print(std::ostream & os) const;

    OptionValue GetOption(std::string const & name);
    bool GetFlag(std::string const & name);

private:
    std::vector<std::string> cmdArgs;

    std::map<OptionName, OptionValue> options;
    std::map<OptionName, bool> flags;
    std::string mode;


};

std::ostream & operator << (std::ostream & os, Configuration const & cfg);


#endif /* CONFIGURATION_H */
