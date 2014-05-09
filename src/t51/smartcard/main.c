#include <stdint.h>
#include <8052.h>

#include "../common/T51Interface.h"
#include "iso.h"
#include "../common/DebugCodes.h"


//delays for about t * 1/2 us
void Delay(uint16_t const t) {
    volatile uint16_t d = t;
    while(--d);
}

void DelayMs(uint16_t const ms) {
    volatile uint16_t n = ms;
    while(--n) Delay(1820);
}

#define ECHO_MODE 0
#define ECHO_COUNT_MODE 1
#define SMARTCARD_MODE 2
#define INVALID_MODE 0xFF

#define RESP_OK 0
#define RESP_ERROR 1

void EchoMode();
void EchoCountMode();
void SmartcardMode();

void main(void)
{ 
    uint8_t mode = INVALID_MODE;
    P0 = 0x00;

    IfInit();
    
    while(mode == INVALID_MODE) {
        while(!PacketAvailable(HOST));
        if(GetRxCount(HOST) == 1) {
            mode = *GetRx(HOST);
            TX_BUF[0] = RESP_OK;
            TX_BUF[1] = mode;
            SendPacket(HOST, ID_CTRL, TX_BUF, 2);
        } else {
            TX_BUF[0] = RESP_ERROR;
            SendPacket(HOST, ID_CTRL, TX_BUF, 1);
        }
        ResetRx(HOST);
    }

    switch(mode) {
    case ECHO_MODE:
        EchoMode();
        break;
    case ECHO_COUNT_MODE:
        EchoCountMode();
        break;
    case SMARTCARD_MODE:
        SmartcardMode();
        break;
    }

}

void EchoMode() {
    uint16_t n = 300;
    uint8_t x;
    while(1) {
        while(!PacketAvailable(HOST));
        //SendDebug(n++);
        x = GetRxCount(HOST);
        SendPacket(HOST, ID_DEBUG, GetRx(HOST), x);
        ResetRx(HOST);            
    }
}

void EchoCountMode() {
    uint16_t s;    
    while(1) {
        s = 0;
        while(!PacketAvailable(HOST)) {
            if(GetRxCount(HOST) == BUFSIZE-1) {
                s += GetRxCount(HOST);
                ResetRx(HOST);
            }
        }

        s += GetRxCount(HOST);
        TX_BUF[0] = (s >> 8) & 0xFF;
        TX_BUF[1] = s & 0xFF;
        SendPacket(HOST, ID_DEBUG, TX_BUF, 2); 
        ResetRx(HOST);            
    }
}


void SmartcardMode() {
     IsoInit();
     
     while(1) {
         if(PacketAvailable(PICC)) {
             IsoProcessPcd();
//            DelayMs(3);
             SendDebug(D_PACKET_PROCESSED);
         }
    }
 } 

