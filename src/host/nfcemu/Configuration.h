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
#include <memory>
#include <iostream>

class OptionName {
public:

    OptionName(std::string const & l, std::string const & s = "") : l(l), s(s) {}
    bool operator==(std::string const & rhs) const {
        return (rhs == l);
    }
    bool operator<(OptionName const & rhs) const {
        bool ret = (l < rhs.l);
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
    OptionValue() : mSet(false) {}
    OptionValue(std::string const & s) : mSet(false) {
        value = s;
    }
    OptionValue(char const * s) : mSet(false) {
        value = s;
    }
    OptionValue(int v) : mSet(false) {
        std::ostringstream oss;
        oss << v;
        value = oss.str();
    }
    void Set() {
        mSet = true;
    }

    void Unset() {
        mSet = false;
    }

    bool IsSet() const {
        return mSet;
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
    bool mSet;
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
    static Configuration & Get();
    static void ParseCmd(int argc, char * argv[]);

    static std::string GetMode(std::string const & defaultMode = "");

    static void RegisterOption(std::string const & longName,
                        std::string const shortName,
                        OptionValue const & defaultValue = 0);
    static void RegisterOption(OptionName const & name, OptionValue const & defaultValue = 0);
    static void SetOption(std::string const & name, OptionValue const & value);

    static void Print(std::ostream & os = std::cout);

    static OptionValue GetOption(std::string const & name);
    static bool IsSet(std::string const & name);

private:
    Configuration() {}

    static Configuration & r; // static reference for internal use

    std::vector<std::string> cmdArgs;

    std::map<OptionName, OptionValue> options;

    std::string mode;


};

std::ostream & operator << (std::ostream & os, Configuration const & cfg);


#endif /* CONFIGURATION_H */
