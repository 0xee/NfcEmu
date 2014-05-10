/**
 * @file   T51Interface.c
 * @author Lukas Schuller
 * @date   Fri Sep 20 17:46:50 2013
 * 
 * @brief  
 * 
 */

#include "T51Interface.h"
#include "DebugCodes.h"

typedef struct T51Port T51Port;
struct T51Port {
    uint8_t rx[BUFSIZE];
    uint8_t tx;
    uint8_t control;
    uint8_t rxCount;
    uint8_t id;
    uint8_t padding[BUFSIZE-4];
};


T51Port __xdata volatile * const pPorts = IF_BASE_ADDRESS;

uint8_t __xdata txBuf[BUFSIZE];


#define PortById(port) (&(pPorts[port]))

#define SetId(port, newId) do { PortById(port)->id = newId; } while(0)

#define SetEof(port) do { PortById(port)->control = EOF_MASK; } while(0)
#define ClearEof(port) do { PortById(port)->control = 0; } while(0)
#define SetError(port) do { PortById(port)->control = EOF_MASK | SHORTFRAME_MASK; } while(0)
//#define ClearTxFlags(port) // tx flags are cleared by hardware when a byte is sent

#define Send(port, c) do { PortById(port)->tx = c; } while(0)


rx_t GetRx(uint8_t const port) {
    return ((rx_t)PortById(port)->rx);
}

tx_t GetTxBuf() {
    return (tx_t)txBuf;
}
void ResetRx(uint8_t const port) {
    PortById(port)->control = RX_RESET_MASK; 
}

uint16_t GetRxCount(uint8_t const port) {
    return PortById(port)->rxCount;
}


uint8_t PacketAvailable(uint8_t const port) {
    return ((PortById(port)->control) & EOF_MASK);
//         || (GetRxCount(port) == BUFSIZE);
}

void SendPacket(uint8_t const port, uint8_t const id,
                uint8_t __xdata const * buf, uint16_t const len) {


    uint8_t i = 0;        
    if(!len) return;

    SetId(port, id);
    for(i = 0; i < len-1; ++i) {                            
        Send(port, buf[i]);                                   
    }                                                             
    SetEof(port);
    Send(port, buf[i]);                                    
}

void SendDebug(uint8_t const code) {
    SetId(HOST, ID_DEBUG);    
    SetEof(HOST);
    Send(HOST, code);
}


void IfInit(void) {
    uint8_t i;
    for(i = 0; i < N_PORTS; ++i) {
        ResetRx(i);
    }
    SetId(HOST, ID_DEBUG);
    SendDebug(D_T51_READY);
}
