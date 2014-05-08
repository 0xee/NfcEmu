/**
 * @file   Utils.cpp
 * @author Lukas Schuller
 * @date   Wed Oct  9 17:24:22 2013
 * 
 * @brief  
 * 
 */

#include "Util.h"

using namespace std;
using namespace boost::asio;

namespace Util {

    vector<unsigned char> DecodeHex(string const & hex) {
        string stripped = RemoveWhitespace(hex);
        constexpr char lookup[32] =
            {0,10,11,12,13,14,15,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0};
        const char* tmp = stripped.c_str(); 
        vector<unsigned char> data;
        data.clear();
        unsigned char ch = 0;
        unsigned char last = 1;
        while(*tmp) {
            ch <<= 4;
            ch |= lookup[*tmp&0x1f];
            if(last ^= 1) 
                data.push_back(ch);
            tmp++;
        }
    return data;
    }

    string RemoveWhitespace(string const & str) {
        string ret;
        for(int i = 0; i < str.size(); ++i) {
            if(str[i] != ' ') ret += str[i];
        }
        return ret;
    }
}
