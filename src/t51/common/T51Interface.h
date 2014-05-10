/**
 * @file   T51Interface.h
 * @author Lukas Schuller
 * @date   Fri Sep 20 12:34:33 2013
 * 
 * @brief  T51 Interface
 * 
 */

#ifndef T51INTERFACE_H
#define T51INTERFACE_H

#include <stdint.h>
#include <8052.h>

#define IF_BASE_ADDRESS 0x800
#define BUFSIZE 0x100
#define PORT_RANGE (2*BUFSIZE)

#define EOF_MASK 1
#define RX_RESET_MASK 2
#define SHORTFRAME_MASK 4

#define N_PORTS 2
 
#define HOST 0
#define PICC 1

#define MY_ID 0x01

#define ID_DEBUG (0xE0 | MY_ID)
#define ID_STATUS  (0x60 | MY_ID)
#define ID_CTRL  ID_STATUS
#define ID_FW    0x02
#define ID_APDU_UP  (0x40 | MY_ID)
#define ID_APDU_DOWN  (0x20 | MY_ID)

#define ID_PICC 0x25

#define TX_BUF GetTxBuf()

typedef volatile uint8_t __xdata * rx_t;
typedef volatile uint8_t __xdata * tx_t;

void IfInit(void);

void SendPacket(uint8_t const port, uint8_t const id,
                uint8_t __xdata const * buf, uint16_t len);

rx_t GetRx(uint8_t const port);
tx_t GetTxBuf();
void ResetRx(uint8_t const port);
uint16_t GetRxCount(uint8_t const port);

uint8_t PacketAvailable(uint8_t const port);

void SendDebug(uint8_t const code);



#endif /* T51INTERFACE_H */
