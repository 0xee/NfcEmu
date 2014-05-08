/**
 * @file   Configuration.cpp
 * @author Lukas Schuller
 * @date   Tue Sep 24 21:21:57 2013
 * 
 * @brief  
 * 
 */

#include "Configuration.h"

#include <iostream>
#include <algorithm>
#include <iomanip>

using namespace std;


std::ostream & operator << (std::ostream & os, Configuration const & cfg) {
    cfg.Print(os);
}


Configuration::Configuration(int argc, char * argv[]) {
    int i = 1;
    if(argc > 1 && argv[i][0] != '-') mode = argv[i];
    while(++i < argc) {      
        cout << "argv " << i << ": " << argv[i] << endl;
        cmdArgs.push_back(std::string(argv[i]));
    }
}

std::string Configuration::GetMode(std::string const & defaultMode) const {
    return mode.size() ? mode : defaultMode;
}

void Configuration::RegisterOption(std::string const & longName,
                    std::string const shortName,
                    OptionValue const & defaultValue) {
    RegisterOption(OptionName(longName,shortName),defaultValue);
}

void Configuration::RegisterOption(OptionName const & name, OptionValue const & defaultValue) {
    if(options.find(name) != options.end()) return;
    
    options[name] = defaultValue;

    auto ii = std::find(cmdArgs.begin(), cmdArgs.end(), "--" + name.Long());
    if(name.Short().size() && ii == cmdArgs.end()) {
        ii = std::find(cmdArgs.begin(), cmdArgs.end(), "-" + name.Short());
    }
        
    if(ii == cmdArgs.end()) return;
    auto iiVal = ii + 1;
    if(iiVal == cmdArgs.end()) return;
    options[name] = *iiVal;
    cmdArgs.erase(ii,iiVal);
}

void Configuration::RegisterFlag(std::string const & longName,
                  std::string const shortName,
                  bool const defaultValue) {
    RegisterFlag(OptionName(longName, shortName), defaultValue);
}

void Configuration::RegisterFlag(OptionName const & name, bool const defaultValue) {
    if(flags.find(name) != flags.end()) return;
    
    flags[name] = defaultValue;
    auto ii = std::find(cmdArgs.begin(), cmdArgs.end(), "--" + name.Long());
    if(name.Short().size() && ii == cmdArgs.end()) {
        ii = std::find(cmdArgs.begin(), cmdArgs.end(), "-" + name.Short());
    }
    if(ii == cmdArgs.end()) return;
    flags[name] = true;
    cmdArgs.erase(ii);
}

void Configuration::Print(std::ostream & os) const {
    os << "Options:" << std::endl;
    for(auto ii = options.begin(); ii != options.end(); ++ii) {
        os << std::setw(16) << ii->first.Long()
           << std::setw(16) << " [" + ii->first.Short() + "] = " 
           << ii->second.Str() << std::endl;
    }
    os << "Flags:" << std::endl;
    for(auto ii = flags.begin(); ii != flags.end(); ++ii) {
        os << std::setw(16) << ii->first.Long()
           << std::setw(16) << " [" + ii->first.Short() + "] = " 
           << std::boolalpha << ii->second << std::endl;
    }
}

OptionValue Configuration::GetOption(std::string const & name) {
    //std::cout << "Requested: " << name << std::endl;
    if(options.find(name) == options.end()) {
        cout << "unknown name: " << name << endl;
        throw ConfigException("unregistered option");
    }
    //std::cout << "Returning: " <<  options[name].Str() << std::endl;
    return options[name];
}

bool Configuration::GetFlag(std::string const & name) {
    if(flags.find(name) == flags.end()) {
        cout << "unknown name: " << name << endl;
        throw ConfigException("unregistered flag");
    }
    return flags[name];
}
