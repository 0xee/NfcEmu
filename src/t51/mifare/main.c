#include <stdint.h>
#include <8052.h>

#define N_PORTS 2
 
#include "../common/T51Interface.h"
#include "mifare.h"

#define T51_READY 8

void Delay(uint16_t const t) {
    volatile uint16_t d = t;
    while(--d);
}

void main(void)
{ 
    uint8_t i = 0;
 
    uint8_t c = 0;
    uint8_t d = 0;
    P0 = 0xAA;
    SetId(HOST, 0xDD);
    SendEof(HOST, T51_READY);
    ResetRx(HOST);

    SetId(PICC, 0xEE);
    ResetRx(PICC);

    while(1) {
        if(GetEof(PICC)) {
            c = GetRxCount(PICC);
            MifareProcessCmd();
            SendEof(HOST,0xAE);
            ResetRx(PICC);
        }
    }
}

