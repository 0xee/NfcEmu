/**
 * @file   crc_a.c
 * @author Lukas Schuller
 * @date   Fri Sep 27 14:54:13 2013
 * 
 * @brief  
 * 
 */

#include "crc_a.h"

static inline uint16_t UpdateCrc(unsigned char ch, uint16_t *lpwCrc)
{
    ch = (ch^(unsigned char)((*lpwCrc) & 0x00FF));
    ch = (ch^(ch<<4));
    *lpwCrc = (*lpwCrc >> 8)^((uint16_t)ch << 8)^((uint16_t)ch<<3)^((uint16_t)ch>>4);
    return(*lpwCrc);
}

void AppendCrc(char *Data, int Length) {
    unsigned char chBlock;
    uint16_t wCrc;
    wCrc = 0x6363; /* ITU-V.41 */
    do {
        chBlock = *Data++;
        UpdateCrc(chBlock, &wCrc);
    } while (--Length);

    *Data++ = (BYTE) (wCrc & 0xFF);
    *Data++ = (BYTE) ((wCrc >> 8) & 0xFF);
    return;
}

uint16_t CalcCrc(char const *Data, int Length) {
    unsigned char chBlock;
    uint16_t wCrc;
    wCrc = 0x6363; /* ITU-V.41 */
    do {
        chBlock = *Data++;
        UpdateCrc(chBlock, &wCrc);
    } while (--Length);

    return wCrc;
}
