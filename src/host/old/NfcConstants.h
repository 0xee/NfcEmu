/**
 * @file   NfcEmuConstants.h
 * @author Lukas Schuller
 * @date   Tue Aug 20 16:16:31 2013
 * 
 * @brief  Constants
 * 
 */

#ifndef NFCEMUCONSTANTS_H
#define NFCEMUCONSTANTS_H

#include <string>

unsigned int const NFC_START_BYTE = 0xAA;
unsigned int const NFC_STOP_BYTE = 0xE0;
unsigned int const NFC_STOP_BYTE_SHORT = 0xE1;

std::string const debugMessages[] = {"dummy message",
                                     "PICC power on",
                                     "PICC power lost",
                                     "PICC is ready",
                                     "PICC selected",
                                     "PICC halted",           // 5
                                     "Received config packet",
                                     "Invalid CRC sum",
                                     "T51 ready",
                                     "ISO Layer 4 activated",
                                     "ISO Layer 4 deactivated"};


#define FX2_POLL_FW 0xC0
#define FX2_FW_OK 0xA1
#define FX2_RESET_FPGA 0xC1


#endif /* NFCEMUCONSTANTS_H */
