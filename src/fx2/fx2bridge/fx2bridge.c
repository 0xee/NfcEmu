/**
 * @file   fx2bridge.c
 * @author Lukas Schuller
 * @date   Tue Jun 11 00:00:13 2013
 * 
 * @brief  Simple FIFO bridge for Cypress FX2
 *
 * EP2OUT and EP6IN are relayed between host and fpga, 
 * EP1OUT can be used for communication between host 
 * and the 8051 core (eg. fpga reset on PA7)
 * 
 */

#define ALLOCATE_EXTERN
#include <fx2regs.h>

// See TRM p.15-115
#define	NOP		__asm nop __endasm
#define	SYNCDELAY	NOP; NOP; NOP; NOP


#define CMD_POLL_FW 0xC0
#define CMD_FW_OK 0xA0
#define CMD_RESET_FPGA 0xC1
#define CMD_ACK_RESET 0xA1

void ResetFifos() {
	FIFORESET = 0x80;  SYNCDELAY;  // NAK all requests from host. 
	FIFORESET = 0x82;  SYNCDELAY;  // Reset individual EP (2,4,6,8)
	FIFORESET = 0x86;  SYNCDELAY;
	FIFORESET = 0x00;  SYNCDELAY;  // Resume normal operation. 

    // flush quad buffered EP2 fifo
	EP2FIFOCFG = 0x00; SYNCDELAY;
	OUTPKTEND = 0x82;  SYNCDELAY;
	OUTPKTEND = 0x82;  SYNCDELAY;
	OUTPKTEND = 0x82;  SYNCDELAY;
	OUTPKTEND = 0x82;  SYNCDELAY;

    // flush quad buffered EP6 fifo
	EP6FIFOCFG = 0x00; SYNCDELAY;
	OUTPKTEND = 0x86;  SYNCDELAY;
	OUTPKTEND = 0x86;  SYNCDELAY;
	OUTPKTEND = 0x86;  SYNCDELAY;
	OUTPKTEND = 0x86;  SYNCDELAY;

	EP2FIFOCFG = 0x10; SYNCDELAY; //  AUTOOUT=1; byte-wide operation
	EP6FIFOCFG = 0x0c; SYNCDELAY; //  AUTOIN=1; byte-wide operation
}

static void Initialize(void)
{
	volatile unsigned int i;

	CPUCS=0x12;   // 48 MHz, CLKOUT output enabled. 
	SYNCDELAY;

	IFCONFIG=0xe3;  // Internal 48MHz IFCLK; IFCLK pin output enabled
			// slave FIFO in synchronous mode
	SYNCDELAY;
	
	REVCTL=0x03;  // See TRM...
	SYNCDELAY;
	
    PORTACFG &= ~0xC0;

	OEA = 0x80;	// PA7 is fpga reset pin
	IOA = 0x00;

	PINFLAGSAB = 0x98;  // FLAGA = EP2 EF (empty flag); FLAGB = EP4 EF
	SYNCDELAY;
	PINFLAGSCD = 0xfe;  // FLAGC = EP6 FF (full flag); FLAGD = EP8 FF
	SYNCDELAY;

	EP1INCFG=0xa0;		// EP1 bulk IN  
	EP1OUTCFG=0xa0;		// EP1 bulk OUT
	EP2CFG=0xa0;  // 1010 0010 (bulk OUT, 512 bytes, double-buffered)
	EP6CFG=0xe0;  // 1110 0010 (bulk IN, 512 bytes, double-buffered)
	SYNCDELAY;

    ResetFifos();
   
	
	EP1OUTBC=0xff; // arm endpoint 1 for OUT (host->device) transfers
	SYNCDELAY;


    // pull PA7 to gnd for some time to reset the fpga
    for (i=0; i<0x2000; i++) NOP;
    IOA = 0x80;
}


// Read/interpret EP1OUT data
static void ProcessEP1Data(void)
{
        volatile unsigned int i;
        unsigned char cmd = *EP1OUTBUF;

        switch(cmd) {
        case CMD_POLL_FW:
            *EP1INBUF = CMD_FW_OK;
            SYNCDELAY;
            EP1INBC = 1;
            break;

        case CMD_RESET_FPGA:
            IOA = 0x00;
            for (i=0; i<2000; i++) NOP;
            IOA = 0x80;
            ResetFifos();
            for (i=0; i<2000; i++) NOP;

            *EP1INBUF = CMD_ACK_RESET;
            SYNCDELAY;
            EP1INBC = 1;
            break;

        default:
            break;
        }

	
        EP1OUTBC=0xff; // re-arm endpoint 1
}


void main(void)
{
	Initialize();
	
	// loop reading EP1 data until FPGA signals CONF_DONE

	while (1)
	{
		// EP1 packet received?
		if (!(EP1OUTCS & (1<<1))) {
			ProcessEP1Data();
		}
	}
}
