/**
 * @file   iso.h
 * @author Lukas Schuller
 * @date   Thu Sep 26 21:39:20 2013
 * 
 * @brief Abstraction layer for iso14443-4
 * 
 */


#ifndef ISO_H
#define ISO_H

#define NONE 0
#define NORMAL 1
#define SINGLE 2

#define USE_WTX NORMAL

void IsoProcessPcd(void);
void IsoProcessPicc(void);
void IsoInit(void);


#define DECODE_FSDI(FSDI) (fsdTable[(FSDI)])

static void SendAts(void);

static void ProcessIBlock(void);
static void ProcessRBlock(void);
static void ProcessSBlock(void);
static void ProcessPps(void);


static void SendDeselectResp(void);

#endif /* ISO_H */
