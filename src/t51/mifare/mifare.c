/**
 * @file   mifare.c
 * @author Lukas Schuller
 * @date   Thu Sep 26 21:39:48 2013
 * 
 * @brief  
 * 
 */

#include "mifare.h"
#include "T51Interface.h"

#define IDLE 0
#define WAIT_FOR_AB 1
#define AUTHENTICATED 2

#define CMD_L4_QUERY 0xE0
#define CMD_AUTH_A 0x60
#define MF_NAK     0x04

static uint8_t mifareState = IDLE;
static uint8_t currentSector;

void MifareProcessCmd(void) {

    uint8_t rxLen = GetRxCount(PICC);
    rx_t rx = RxData(PICC);
    switch(mifareState) {
    case IDLE: 
        if(rx[0] == CMD_L4_QUERY) {
            SendShort(PICC, MF_NAK);
        }
        else if(rx[0] == CMD_AUTH_A) {
            currentSector = rx[1];
            // todo: check crc in rx[2..3]
            SendEof(HOST, 0xAB);
            SendNonce();
            mifareState = WAIT_FOR_AB;
        }
        break;
    case WAIT_FOR_AB:
        if(rxLen == 8) {
            SendNonce();
        }
        break;
    }
    
}

static void SendNonce() {
    Send(PICC,0x0a);
    Send(PICC,0x0b);
    Send(PICC,0x0c);
    SendEof(PICC,0x0d);
    
}
