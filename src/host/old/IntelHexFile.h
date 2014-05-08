/**
 * @file   IntelHexFile.h
 * @author Lukas Schuller
 * @date   Fri Sep  6 12:45:30 2013
 * 
 * @brief  
 * 
 */

#ifndef INTELHEXFILE_H
#define INTELHEXFILE_H

#include <iostream>
#include <iomanip>
#include <fstream>
#include <string>
#include <vector>
#include <list>
#include <iterator>

class IHexException : public std::exception {
public:
    IHexException(const char * msg) : message(msg) { }
    virtual ~IHexException() throw() {}
    virtual char const * what() const throw() {
        return message;
    }
private:
    char const * message;
};


class IntelHexFile {

public:
    struct IHexLine {
        size_t address;
        size_t type;
        std::vector<unsigned char> data;
    };

    IntelHexFile(std::string const & fileName) {
        std::ifstream ifs(fileName.c_str());
        if(ifs.bad()) throw IHexException("bad file");
        FromFile(ifs);
    }

    IntelHexFile(std::ifstream & inFile) {
        FromFile(inFile);
    }

    std::list<IHexLine>::iterator Begin() {
        return lines.begin();
    }

    std::list<IHexLine>::const_iterator Begin() const {
        return lines.cbegin();
    }

    std::list<IHexLine>::iterator End() {
        return lines.end();
    }

    std::list<IHexLine>::const_iterator End() const {
        return lines.cend();
    }

    void DumpRaw(std::ostream & os = std::cout, size_t const imageSize = 1<<12) const {

        std::vector<unsigned char> image(imageSize, 0);
        os << image.size() << std::endl;

        for(auto ii = Begin(); ii != End(); ++ii) {
            std::copy(ii->data.begin(), ii->data.end(), image.begin()+ii->address); 
        }
        
        os << "Image size: " << imageSize << std::endl << std::hex;
        for(int i = 0; i < image.size()/16; ++i) {
            for(int j = 0; j < 16; ++j) {
                os << std::setw(2) << std::setfill('0') << (size_t)image[i*16+j] << "  ";
            }
            os << std::endl;
        }
        os << std::dec;

    }

    template<typename T>
    void GetImage(T bi, size_t const imageSize = 1<<12) const {
          std::vector<unsigned char> image(imageSize, 0);
          
          for(auto ii = Begin(); ii != End(); ++ii) {
              std::copy(ii->data.begin(), ii->data.end(), image.begin()+ii->address); 
          }
          std::copy(image.begin(), image.end(), bi); 
        
    }

private:
    
    void FromFile(std::ifstream & inFile) {
        lines.clear();
        while(!(inFile.bad() || inFile.eof())) {
            std::string line;
            getline(inFile, line);
            if(line.size() == 0) continue;
            if(line[0] != ':') throw IHexException("invalid ihex format");
            IHexLine content;
            size_t byteCount = HexToInt(line.substr(1,2));
            size_t checksum = byteCount;
            if(2*byteCount + 11 != line.size()) throw IHexException("invalid ihex format");
            content.address = HexToInt(line.substr(3,4));        
            checksum += (content.address & 0xFF) + (content.address >> 8);
            content.type = HexToInt(line.substr(7,2));
            checksum += content.type;

            for(int i = 0; i < byteCount; ++i) {
                size_t d = HexToInt(line.substr(9+2*i,2));
                checksum += d;
                content.data.push_back(d);
            }
            checksum &= 0xFF;
            checksum = 0x100 - checksum;
            checksum &= 0xFF;

            if(checksum != HexToInt(line.substr(line.size()-2,2))) {
                throw IHexException("invalid ihex checksum");
            }
            lines.push_back(content);
        }
//        Print();
    }

    size_t HexToInt(std::string const & str) {
        size_t n = 0;
        for(int i = 0; i < str.size(); ++i) {
            n*= 16;
            if(str[i] >= '0' && str[i] <= '9')  n += str[i]-'0';
            else if(str[i] >= 'A' && str[i] <= 'F')  n += str[i]-'A'+10;
            else if(str[i] >= 'a' && str[i] <= 'a')  n += str[i]-'a'+10;
            else throw IHexException("invalid ihex file");
        }
        return n;
    }

    void Print() {
        std::cout << std::hex;
        for(auto ii = lines.begin(); ii != lines.end(); ++ii) {
            std::cout << ii->address << ": (" << ii->type << ") ";
            std::copy(ii->data.begin(), ii->data.end(), std::ostream_iterator<int>(std::cout," "));
            std::cout << std::endl;
        }
        std::cout << std::dec; 
        
    }

    std::list<IHexLine> lines;

};



#endif /* INTELHEXFILE_H */
