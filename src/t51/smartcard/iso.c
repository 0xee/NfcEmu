/**
 * @file   mifare.c
 * @author Lukas Schuller
 * @date   Thu Sep 26 21:39:48 2013
 * 
 * @brief  
 * 
 */

#include "../common/T51Interface.h"
#include "iso.h"
#include "crc_a.h"
#include <string.h>

#include "DebugCodes.h"

// pcd commands
#define CMD_RATS         0xE0
#define CMD_ATTRIB       0x1D
#define CMD_DESELECT     0xC2
#define CMD_DESELECT_CID 0xCA
#define CMD_PPS          0xD0

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
#define SWTX_INTERVAL (360L)*(SWTX_INTERVAL_MS)
                       
                       
                       
static void ResetWtx(WtxContext * wtx) {
    wtx->spinCount = 0;
    wtx->missingAcks = 0;
}                      
                       
static void SendSwtx(void) {
    TX_BUF[0] = WTX_REQUEST;
    TX_BUF[1] = 14;
    AppendCrc(TX_BUF, 2);
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
        //SendDebug(D_WTX_ACK);
        
        ResetRx(PICC);
        return 0;
    }
    return wtx->missingAcks;

}

volatile uint8_t __xdata apduBuf[256];
uint16_t apduLen;

void IsoInit() {
    piccRx = GetRx(PICC);
    hostRx = GetRx(HOST);
}

void IsoProcessPcd(void) {
    uint8_t rxLen = GetRxCount(PICC);
    uint16_t crc;
    Trace(0);
    Trace(piccRx[0]);
    if(rxLen > 2) {
        crc = CalcCrc(piccRx, rxLen-2);
        if( (uint8_t)crc != piccRx[rxLen-2] || (uint8_t)(crc>>8) != piccRx[rxLen-1] ) {
            ResetRx(PICC);
            SendDebug(D_CRC_ERROR);
            return;
        }
    } else {
        ResetRx(PICC);
        SendDebug(D_INVALID_PACKET);
        return;
    }

    switch(piccRx[0] & BLOCK_MASK) {
    case I_BLOCK:
        ProcessIBlock();
        break;

    case R_BLOCK:
        ProcessRBlock();
        break;

    case S_BLOCK:
        if((piccRx[0] & 0xF0) == CMD_PPS) {
            ProcessPps();
        } else {
            ProcessSBlock();
        }
        break;

    default:
        switch(piccRx[0]) {
        case CMD_RATS:        
            blockNumber = 1;
            iBlockReceived = 0;
            fsd = DECODE_FSDI(piccRx[1] >> 4);
            cid = piccRx[1] & 0x0F;
            SendAts();
            break;
        }
        ResetRx(PICC);
        break;
    }
}

static uint8_t __code const ats[] = {0x77, 0x00, 0x70, 0x00};

static uint8_t __code const historical[] = {0x45, 0x50, 0x41, 0x00, 0x00, 0x00, 0x00, 0x61, 0x27, 0x38, 0x94, 0x00, 0x00, 0x00, 0x00};
//static uint8_t __code const historical[] = {0x45, 0x50, 0x41, 0x00, 0x00, 0x00, 0x00, 0x61, 0x27, 0x38, 0x94, 0x00, 0x00, 0x00, 0x00};

static void SendAts(void) {
    TX_BUF[0] = 1;
    memcpy(TX_BUF+TX_BUF[0], ats, sizeof(ats));
    TX_BUF[3] = 0xd0; // override default fwi
    TX_BUF[0] += sizeof(ats);
    memcpy(TX_BUF+TX_BUF[0], historical, sizeof(historical));
    TX_BUF[0] += sizeof(historical);
    AppendCrc(TX_BUF, TX_BUF[0]);
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
    uint16_t spinCount;
    uint8_t i;
    iBlockReceived = 1;
    blockNumber ^= 1;
    ResetRx(HOST);
    /* if(pcb & CID_FOLLOWING) { */
    /*     ++apduOffset; */
    /*     cid = piccRx[1]; */
    /* } */
    if(pcb & NAD_FOLLOWING) ++apduOffset;


    apduLen = GetRxCount(PICC)-apduOffset-2;
    SendPacket(HOST, ID_APDU_DOWN, piccRx+apduOffset, apduLen);

    ResetRx(PICC);

    if(apduLen == 0) {        
        apduBuf[0] = 0x02 | blockNumber;                      // PCB
        apduLen = apduOffset;
        AppendCrc(apduBuf, apduLen);  // CRC
        SendPacket(PICC, 0, piccRx+apduOffset, apduLen);
    }

    needSwtxAck = 0;
    spinCount = SWTX_INTERVAL/2;
    /* SendSwtx(); */
    /* needSwtxAck = 1; */
    // send apdu to host
    //SendDebug(D_GEN_0);

    // wait for response
    while(1) {
        P0 = 0;

        if(needSwtxAck != 0) {
            while(!PacketAvailable(PICC));
            /* SendDebug(D_GEN_2); */
            /* SendDebug(GetRxCount(PICC)); */

            P0 = 1;
            if(piccRx[0] == WTX_RESPONSE) {
                /* for(i = 0; i < 4; ++i) { */
                /*     if(piccRx[i] != expSwtx[i]) { */
                /*         //SendDebug(D_GEN_1); */
                /*         //                SendDebug(i); */
                /*         //               SendDebug(piccRx[i]); */
                /*         break; */
                /*     } */
                /* } */
                //SendDebug(D_WTX_ACK);
                needSwtxAck = 0;
                spinCount = SWTX_INTERVAL;
                //           SendDebug(GetRxCount(PICC));
                ResetRx(PICC);
            } else {
                SendDebug(D_NAK_RECEIVED);
                return;
            }
        } else {
            
            if(PacketAvailable(PICC)) { // NAK or stray packet
                if(IS_NAK(piccRx[0])) {
                    SendDebug(D_NAK_RECEIVED);
                    return;
                }
                ResetRx(PICC);
                SendDebug(D_ERR);
            }

            if(spinCount == 0) {
                SendSwtx();
                needSwtxAck = 1;
                continue;
            }
            --spinCount;

            if(PacketAvailable(HOST)) {  // host sent (last part of) response
                //   SendPacket(HOST, ID_DEBUG, GetRx(HOST), GetRxCount(HOST));
                apduBuf[0] = 0x02 | blockNumber;                      // PCB
                apduLen = GetRxCount(HOST);
                memcpy(apduBuf+apduOffset, hostRx, apduLen); // APDU data
                apduLen += apduOffset;
                AppendCrc(apduBuf, apduLen);  // CRC
                apduLen += 2;
                SendPacket(PICC, 0, apduBuf,  apduLen);
                ResetRx(HOST);
                return;
            }
        }
    }
    /* else if(GetRxCount(HOST) == (BUFSIZE-1))  { // host sent part of response */
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

static void ProcessRBlock() {
    if(piccRx[0] & R_NAK) {
        SendDebug(D_NAK_RECEIVED);

        if((piccRx[0] & 1) == blockNumber) {
            if(iBlockReceived == 0) blockNumber ^= 1;
            SendDebug(D_GEN_0);
        } else {
//            blockNumber ^= 1;
            SendDebug(D_GEN_1);
        }


        TX_BUF[0] = 0xA3;
        AppendCrc(TX_BUF, 1);
        SendPacket(PICC, 0, TX_BUF, 3);
    } else {
        // retransmit last apdu?
        
        SendPacket(PICC, 0, apduBuf,  apduLen);      
        //SendDebug(D_ACK_RECEIVED);
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

static void ProcessPps(void) {
    TX_BUF[0] = piccRx[0];
    ResetRx(PICC);
    AppendCrc(TX_BUF, 1);
    SendPacket(PICC, 0, TX_BUF, 3);
}
