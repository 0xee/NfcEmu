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

uint16_t UpdateCrc(unsigned char ch, uint16_t *lpwCrc);

void ComputeCrc(char *Data, int Length);

#endif /* CRC_A_H */
