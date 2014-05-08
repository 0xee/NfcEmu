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

Configuration & Configuration::r = Configuration::Get();

std::ostream & operator << (std::ostream & os, Configuration const & cfg) {
    cfg.Print(os);
}

Configuration & Configuration::Get() {
    static Configuration instance;
    return instance;    
}

void Configuration::ParseCmd(int argc, char * argv[]) {
    int i = 1;
    if(argc > 1 && argv[i][0] != '-') r.mode = argv[i++];
    while(i < argc) {
        // cout << "argv " << i << ": " << argv[i] << endl;
        r.cmdArgs.push_back(std::string(argv[i]));
        ++i;
    }
}

std::string Configuration::GetMode(std::string const & defaultMode) {
    return r.mode.size() ? r.mode : defaultMode;
}

void Configuration::RegisterOption(std::string const & longName,
                    std::string const shortName,
                    OptionValue const & defaultValue) {
    RegisterOption(OptionName(longName,shortName),defaultValue);
}

void Configuration::RegisterOption(OptionName const & name, OptionValue const & defaultValue) {
    if(r.options.find(name) != r.options.end()) return;
    
    r.options[name] = defaultValue;
    r.options[name].Unset();
    auto ii = r.cmdArgs.begin();
    for(; ii != r.cmdArgs.end(); ++ii) {
        if(0 == ii->find( "--" + name.Long()) || 
           0 == ii->find( "-" + name.Short())) {
            size_t valPos = ii->find("=");
            if(valPos != string::npos) {
                ++valPos;
                r.options[name] = ii->substr(valPos, ii->size()-valPos);    
            }
            r.options[name].Set();
            r.cmdArgs.erase(ii);
            break;
        }
    }        
}

void Configuration::SetOption(std::string const & name, OptionValue const & value) {
    if(r.options.find(OptionName(name)) == r.options.end());
    r.options[name] = value;
    r.options[name].Set();
}

void Configuration::Print(std::ostream & os) {
    os << "Options:" << std::endl;
    for(auto ii = r.options.begin(); ii != r.options.end(); ++ii) {
        os << std::setw(16) << ii->first.Long()
           << std::setw(16) << " [" + ii->first.Short() + "] = " 
           << ii->second.Str() << "    (" << ii->second.IsSet() << ")" << std::endl;
    }
}

OptionValue Configuration::GetOption(std::string const & name) {
    //std::cout << "Requested: " << name << std::endl;
    if(r.options.find(name) == r.options.end()) {
        cout << "unknown name: " << name << endl;
        throw invalid_argument("unregistered option");
    }
    //std::cout << "Returning: " <<  options[name].Str() << std::endl;
    return r.options[name];
}

bool Configuration::IsSet(std::string const & name) {
    if(r.options.find(name) == r.options.end()) {
        cout << "unknown name: " << name << endl;
        throw ConfigException("unregistered flag");
    }
    return r.options[name].IsSet();
}
