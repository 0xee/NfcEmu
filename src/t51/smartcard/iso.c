/**
 * @file   mifare.c
 * @author Lukas Schuller
 * @date   Thu Sep 26 21:39:48 2013
 * 
 * @brief  
 * 
 */

#include "T51Interface.h"
#include "iso.h"
#include "crc_a.h"
#include <string.h>

#include "DebugCodes.h"

// pcd commands
#define CMD_RATS         0xE0
#define CMD_ATTRIB       0x1D
#define CMD_DESELECT     0xC2
#define CMD_DESELECT_CID 0xCA

#define WTX_REQUEST      0xF2
#define WTX_RESPONSE      0xF2

#define BLOCK_MASK       0xE0
#define I_BLOCK          0x00
#define R_BLOCK          0xA0
#define S_BLOCK          0xC0

#define R_NAK            0x10

// flag bits 
#define CID_FOLLOWING 0x08
#define NAD_FOLLOWING 0x04

//

#define IS_ACK(pcb) ( ((pcb) & ((BLOCK_MASK) | (R_NAK))) == (R_BLOCK))
#define IS_NAK(pcb) ( ((pcb) & ((BLOCK_MASK) | (R_NAK))) == ((R_BLOCK) | (R_NAK)))

#define FSCI 8 // fsc = 256 bytes
#define T0 (FSCI)

// protocol parameters
static uint16_t __code const fsdTable[] = {16, 24, 32, 40, 48, 64, 96, 128, 256};


static uint8_t fsd;
static uint8_t cid;
static uint8_t blockNumber = 1;
static uint8_t lastTxLen = 0;
static uint8_t iBlockReceived;


rx_t hostRx, piccRx;


typedef struct {
    uint32_t spinCount;
    uint8_t missingAcks;
} WtxContext;

                       
#define SWTX_INTERVAL_MS 10L
#define SWTX_INTERVAL (60L)*(SWTX_INTERVAL_MS)
                       
                       
                       
static void ResetWtx(WtxContext * wtx) {
    wtx->spinCount = 0;
    wtx->missingAcks = 0;
}                      
                       
static void SendSwtx(void) {
    TX_BUF[0] = WTX_REQUEST;
    TX_BUF[1] = 14;
    ComputeCrc(TX_BUF, 2);
    SendPacket(PICC, 0, TX_BUF, 4);
}


static int8_t HandleWtx(WtxContext * wtx) {

    if(wtx->spinCount == 0 && !wtx->missingAcks) {
        SendSwtx();
        ++(wtx->missingAcks);
        wtx->spinCount = SWTX_INTERVAL;
    }
    --(wtx->spinCount);
    // wait for swtx ack and discard
    if(PacketAvailable(PICC)) {
        if(piccRx[0] != WTX_RESPONSE) {
            return -1;
        }
        wtx->missingAcks = 0;
        SendDebug(D_WTX_ACK);
        
        ResetRx(PICC);
        return 0;
    }
    return wtx->missingAcks;

}

volatile uint8_t __xdata apduBuf[256];

void IsoInit() {
    piccRx = GetRx(PICC);
    hostRx = GetRx(HOST);
    iBlockReceived = 0;
}

void IsoProcessPcd(void) {
    uint8_t rxLen = GetRxCount(PICC);
    /* SetId(HOST, ID_DEBUG); */
    /* SendEof(HOST, rx[0]); */
    /* SetId(HOST, ID_APDU); */
    switch(piccRx[0] & BLOCK_MASK) {
    case I_BLOCK:
        ProcessIBlock();
        break;

    case R_BLOCK:
        ProcessRBlock();
        break;

    case S_BLOCK:
        ProcessSBlock();
        break;

    default:
        switch(piccRx[0]) {
        case CMD_RATS:        
            blockNumber = 1;
            fsd = DECODE_FSDI(piccRx[1] >> 4);
            cid = piccRx[1] & 0x0F;
            SendAts();
            break;
        }
        ResetRx(PICC);
        break;
    }
}

static uint8_t __code const ats[] = {0x77, 0x80, 0x70, 0x00};

static uint8_t __code const historical[] = {0x45, 0x50, 0x41, 0x00, 0x00, 0x00, 0x00, 0x61, 0x27, 0x38, 0x94, 0x00, 0x00, 0x00, 0x00};
//static uint8_t __code const historical[] = {0x45, 0x50, 0x41, 0x00, 0x00, 0x00, 0x00, 0x61, 0x27, 0x38, 0x94, 0x00, 0x00, 0x00, 0x00};

static void SendAts(void) {
    TX_BUF[0] = 1;
    memcpy(TX_BUF+TX_BUF[0], ats, sizeof(ats));
    TX_BUF[3] = 0xd0; // override default fwi
    TX_BUF[0] += sizeof(ats);
    memcpy(TX_BUF+TX_BUF[0], historical, sizeof(historical));
    TX_BUF[0] += sizeof(historical);
    ComputeCrc(TX_BUF, TX_BUF[0]);
    SendPacket(PICC, 0, TX_BUF, TX_BUF[0]+2);
    
    SendDebug(D_ISO_L4_ACTIVATED); 
}

static volatile WtxContext sWtx;

static void ProcessIBlock() {    
    uint8_t apduOffset = 1;
    int8_t needSwtxAck = 0;
    uint8_t responseComplete = 0;
    uint8_t pcb = piccRx[0];
    uint8_t cid = 0;
    iBlockReceived = 1;
    blockNumber ^= 1;
    ResetRx(HOST);
    /* if(pcb & CID_FOLLOWING) { */
    /*     ++apduOffset; */
    /*     cid = piccRx[1]; */
    /* } */
    if(pcb & NAD_FOLLOWING) ++apduOffset;

    // send apdu to host
    SendPacket(HOST, ID_APDU_DOWN, piccRx+apduOffset, GetRxCount(PICC)-apduOffset-2);

    ResetRx(PICC);
    ResetWtx(&sWtx);

#if USE_WTX == SINGLE
    SendSwtx();
    while(!PacketAvailable(PICC));

    if(piccRx[0] != WTX_RESPONSE) {
        SendDebug(D_NAK_RECEIVED);
        return;
    }
    ResetRx(PICC);
#endif

    // wait for response
    while(1) {

#if USE_WTX == NORMAL
        // handle waiting time extension if necessary
        needSwtxAck = HandleWtx(&sWtx);
        if(needSwtxAck < 0) { // pcd sent something other than wtx ack            
            SendDebug(D_NAK_RECEIVED);
            return;
        }
        if(needSwtxAck > 0) { // wtx ack needed before response can be sent
            continue;
        } 
#endif    
        if(PacketAvailable(HOST)) {  // host sent (last part of) response
            TX_BUF[0] = 0x02 | blockNumber;                      // PCB
            TX_BUF[1] = 0x6A;
            TX_BUF[2] = 0x82;
            memcpy(TX_BUF+apduOffset, hostRx, GetRxCount(HOST)); // APDU data
            ComputeCrc(TX_BUF, GetRxCount(HOST)+apduOffset);  // CRC

            SendPacket(PICC, 0, TX_BUF,  GetRxCount(HOST) +apduOffset+2);
            ResetRx(HOST);
            return;
        } /* else if(GetRxCount(HOST) == (BUFSIZE-1))  { // host sent part of response */
        /*     while(1) { SendDebug(D_ERR); } */
        /*     TX_BUF[0] = 0x12 | blockNumber; // PCB w/ chaining bit */
        /*     memcpy(TX_BUF+apduOffset, hostRx, GetRxCount(HOST)); // APDU data */
        /*     ComputeCrc(TX_BUF, GetRxCount(HOST)+apduOffset);  // CRC */
        /*     SendPacket(PICC, 0, TX_BUF, GetRxCount(HOST)+apduOffset+2); */
        /*     ResetRx(HOST);             */

        /*     // wait for ack */
        /*     while(!PacketAvailable(PICC)); */
        /*     if(IS_NAK(piccRx[0])) {  */
        /*         SendDebug(D_NAK_RECEIVED); */
        /*         return; */
        /*     } else if(IS_ACK(piccRx[0])) { */
        /*         SendDebug(D_ACK_RECEIVED); */
        /*     } */
        /*     ResetRx(PICC);  */
        /*     blockNumber ^= 1; */

        /* }  */




    }

}



static void ProcessRBlock() {
    if(piccRx[0] & R_NAK) {
        SendDebug(D_NAK_RECEIVED);

        if((piccRx[0] & 1) == blockNumber) {
            if(iBlockReceived == 0) blockNumber ^= 1;
            
        } else {

        }


        TX_BUF[0] = 0xA3;
        ComputeCrc(TX_BUF, 1);
        SendPacket(PICC, 0, TX_BUF, 3);
    } else {
        SendDebug(D_ACK_RECEIVED);
    }
    ResetRx(PICC);
}

static void ProcessSBlock() { 

    switch(piccRx[0]) {
    case CMD_DESELECT_CID:
        if(piccRx[1] == cid) {
        case CMD_DESELECT:
            SendDebug(D_ISO_DESELECT);        
            SendDeselectResp();            
            iBlockReceived = 0;
        }
        break;
    }
    ResetRx(PICC);
}

static void SendDeselectResp(void) {
    memcpy(TX_BUF,piccRx,3);
    SendPacket(PICC, 0, piccRx, 3);
}
