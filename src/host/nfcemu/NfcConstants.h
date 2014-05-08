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

unsigned int const NFC_START = 0xAA;
unsigned int const NFC_STOP = 0xCC;
unsigned int const NFC_DLE = 0xEE;

size_t const nfcTimeStampSize = 4;
double const tsToUs = 1.0/(3.0*13.56);


#define FX2_POLL_FW 0xC0
#define FX2_FW_OK 0xA0
#define FX2_RESET_FPGA 0xC1
#define FX2_FPGA_RESET_ACK 0xA1



#endif /* NFCEMUCONSTANTS_H */
