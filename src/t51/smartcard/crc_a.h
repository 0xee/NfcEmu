/**
 * @file   crc_a.h
 * @author Lukas Schuller
 * @date   Fri Sep 27 14:54:22 2013
 * 
 * @brief  
 * 
 */

#ifndef CRC_A_H
#define CRC_A_H

#define CRC_A 1
#define CRC_B 2

#include <stdint.h>

typedef unsigned char BYTE;

void AppendCrc(char *Data, int Length);
uint16_t CalcCrc(char const *Data, int Length);

#endif /* CRC_A_H */
