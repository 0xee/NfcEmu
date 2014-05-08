;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.3.0 #8604 (Sep  2 2013) (Linux)
; This file was generated Thu May  8 18:45:16 2014
;--------------------------------------------------------
	.module iso
	.optsdcc -mmcs51 --model-small
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _memcpy
	.globl _ComputeCrc
	.globl _SendDebug
	.globl _PacketAvailable
	.globl _GetRxCount
	.globl _ResetRx
	.globl _GetTxBuf
	.globl _GetRx
	.globl _SendPacket
	.globl _TF2
	.globl _EXF2
	.globl _RCLK
	.globl _TCLK
	.globl _EXEN2
	.globl _TR2
	.globl _C_T2
	.globl _CP_RL2
	.globl _T2CON_7
	.globl _T2CON_6
	.globl _T2CON_5
	.globl _T2CON_4
	.globl _T2CON_3
	.globl _T2CON_2
	.globl _T2CON_1
	.globl _T2CON_0
	.globl _PT2
	.globl _ET2
	.globl _CY
	.globl _AC
	.globl _F0
	.globl _RS1
	.globl _RS0
	.globl _OV
	.globl _F1
	.globl _P
	.globl _PS
	.globl _PT1
	.globl _PX1
	.globl _PT0
	.globl _PX0
	.globl _RD
	.globl _WR
	.globl _T1
	.globl _T0
	.globl _INT1
	.globl _INT0
	.globl _TXD
	.globl _RXD
	.globl _P3_7
	.globl _P3_6
	.globl _P3_5
	.globl _P3_4
	.globl _P3_3
	.globl _P3_2
	.globl _P3_1
	.globl _P3_0
	.globl _EA
	.globl _ES
	.globl _ET1
	.globl _EX1
	.globl _ET0
	.globl _EX0
	.globl _P2_7
	.globl _P2_6
	.globl _P2_5
	.globl _P2_4
	.globl _P2_3
	.globl _P2_2
	.globl _P2_1
	.globl _P2_0
	.globl _SM0
	.globl _SM1
	.globl _SM2
	.globl _REN
	.globl _TB8
	.globl _RB8
	.globl _TI
	.globl _RI
	.globl _P1_7
	.globl _P1_6
	.globl _P1_5
	.globl _P1_4
	.globl _P1_3
	.globl _P1_2
	.globl _P1_1
	.globl _P1_0
	.globl _TF1
	.globl _TR1
	.globl _TF0
	.globl _TR0
	.globl _IE1
	.globl _IT1
	.globl _IE0
	.globl _IT0
	.globl _P0_7
	.globl _P0_6
	.globl _P0_5
	.globl _P0_4
	.globl _P0_3
	.globl _P0_2
	.globl _P0_1
	.globl _P0_0
	.globl _TH2
	.globl _TL2
	.globl _RCAP2H
	.globl _RCAP2L
	.globl _T2CON
	.globl _B
	.globl _ACC
	.globl _PSW
	.globl _IP
	.globl _P3
	.globl _IE
	.globl _P2
	.globl _SBUF
	.globl _SCON
	.globl _P1
	.globl _TH1
	.globl _TH0
	.globl _TL1
	.globl _TL0
	.globl _TMOD
	.globl _TCON
	.globl _PCON
	.globl _DPH
	.globl _DPL
	.globl _SP
	.globl _P0
	.globl _apduBuf
	.globl _piccRx
	.globl _hostRx
	.globl _IsoInit
	.globl _IsoProcessPcd
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
_P0	=	0x0080
_SP	=	0x0081
_DPL	=	0x0082
_DPH	=	0x0083
_PCON	=	0x0087
_TCON	=	0x0088
_TMOD	=	0x0089
_TL0	=	0x008a
_TL1	=	0x008b
_TH0	=	0x008c
_TH1	=	0x008d
_P1	=	0x0090
_SCON	=	0x0098
_SBUF	=	0x0099
_P2	=	0x00a0
_IE	=	0x00a8
_P3	=	0x00b0
_IP	=	0x00b8
_PSW	=	0x00d0
_ACC	=	0x00e0
_B	=	0x00f0
_T2CON	=	0x00c8
_RCAP2L	=	0x00ca
_RCAP2H	=	0x00cb
_TL2	=	0x00cc
_TH2	=	0x00cd
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
_P0_0	=	0x0080
_P0_1	=	0x0081
_P0_2	=	0x0082
_P0_3	=	0x0083
_P0_4	=	0x0084
_P0_5	=	0x0085
_P0_6	=	0x0086
_P0_7	=	0x0087
_IT0	=	0x0088
_IE0	=	0x0089
_IT1	=	0x008a
_IE1	=	0x008b
_TR0	=	0x008c
_TF0	=	0x008d
_TR1	=	0x008e
_TF1	=	0x008f
_P1_0	=	0x0090
_P1_1	=	0x0091
_P1_2	=	0x0092
_P1_3	=	0x0093
_P1_4	=	0x0094
_P1_5	=	0x0095
_P1_6	=	0x0096
_P1_7	=	0x0097
_RI	=	0x0098
_TI	=	0x0099
_RB8	=	0x009a
_TB8	=	0x009b
_REN	=	0x009c
_SM2	=	0x009d
_SM1	=	0x009e
_SM0	=	0x009f
_P2_0	=	0x00a0
_P2_1	=	0x00a1
_P2_2	=	0x00a2
_P2_3	=	0x00a3
_P2_4	=	0x00a4
_P2_5	=	0x00a5
_P2_6	=	0x00a6
_P2_7	=	0x00a7
_EX0	=	0x00a8
_ET0	=	0x00a9
_EX1	=	0x00aa
_ET1	=	0x00ab
_ES	=	0x00ac
_EA	=	0x00af
_P3_0	=	0x00b0
_P3_1	=	0x00b1
_P3_2	=	0x00b2
_P3_3	=	0x00b3
_P3_4	=	0x00b4
_P3_5	=	0x00b5
_P3_6	=	0x00b6
_P3_7	=	0x00b7
_RXD	=	0x00b0
_TXD	=	0x00b1
_INT0	=	0x00b2
_INT1	=	0x00b3
_T0	=	0x00b4
_T1	=	0x00b5
_WR	=	0x00b6
_RD	=	0x00b7
_PX0	=	0x00b8
_PT0	=	0x00b9
_PX1	=	0x00ba
_PT1	=	0x00bb
_PS	=	0x00bc
_P	=	0x00d0
_F1	=	0x00d1
_OV	=	0x00d2
_RS0	=	0x00d3
_RS1	=	0x00d4
_F0	=	0x00d5
_AC	=	0x00d6
_CY	=	0x00d7
_ET2	=	0x00ad
_PT2	=	0x00bd
_T2CON_0	=	0x00c8
_T2CON_1	=	0x00c9
_T2CON_2	=	0x00ca
_T2CON_3	=	0x00cb
_T2CON_4	=	0x00cc
_T2CON_5	=	0x00cd
_T2CON_6	=	0x00ce
_T2CON_7	=	0x00cf
_CP_RL2	=	0x00c8
_C_T2	=	0x00c9
_TR2	=	0x00ca
_EXEN2	=	0x00cb
_TCLK	=	0x00cc
_RCLK	=	0x00cd
_EXF2	=	0x00ce
_TF2	=	0x00cf
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	.area REG_BANK_0	(REL,OVR,DATA)
	.ds 8
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	.area DSEG    (DATA)
_fsd:
	.ds 1
_cid:
	.ds 1
_blockNumber:
	.ds 1
_lastTxLen:
	.ds 1
_iBlockReceived:
	.ds 1
_hostRx::
	.ds 2
_piccRx::
	.ds 2
_ProcessIBlock_apduOffset_1_54:
	.ds 1
_ProcessIBlock_sWtx_1_54:
	.ds 5
_ProcessIBlock_sloc0_1_0:
	.ds 3
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	.area	OSEG    (OVR,DATA)
;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	.area ISEG    (DATA)
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	.area IABS    (ABS,DATA)
	.area IABS    (ABS,DATA)
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	.area BSEG    (BIT)
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	.area PSEG    (PAG,XDATA)
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
_apduBuf::
	.ds 256
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area XABS    (ABS,XDATA)
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
	.area XISEG   (XDATA)
	.area HOME    (CODE)
	.area GSINIT0 (CODE)
	.area GSINIT1 (CODE)
	.area GSINIT2 (CODE)
	.area GSINIT3 (CODE)
	.area GSINIT4 (CODE)
	.area GSINIT5 (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area CSEG    (CODE)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME    (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area GSINIT  (CODE)
;	iso.c:51: static uint8_t blockNumber = 1;
	mov	_blockNumber,#0x01
;	iso.c:52: static uint8_t lastTxLen = 0;
	mov	_lastTxLen,#0x00
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME    (CODE)
	.area HOME    (CODE)
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CSEG    (CODE)
;------------------------------------------------------------
;Allocation info for local variables in function 'ResetWtx'
;------------------------------------------------------------
;wtx                       Allocated to registers r5 r6 r7 
;------------------------------------------------------------
;	iso.c:70: static void ResetWtx(WtxContext * wtx) {
;	-----------------------------------------
;	 function ResetWtx
;	-----------------------------------------
_ResetWtx:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
;	iso.c:71: wtx->spinCount = SWTX_INTERVAL;
	mov	a,#0xB0
	lcall	__gptrput
	inc	dptr
	mov	a,#0x04
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
	inc	dptr
	clr	a
	ljmp	__gptrput
;------------------------------------------------------------
;Allocation info for local variables in function 'SendSwtx'
;------------------------------------------------------------
;	iso.c:74: static void SendSwtx(void) {
;	-----------------------------------------
;	 function SendSwtx
;	-----------------------------------------
_SendSwtx:
;	iso.c:75: TX_BUF[0] = WTX_REQUEST;
	lcall	_GetTxBuf
	mov	a,#0xF2
	movx	@dptr,a
;	iso.c:76: TX_BUF[1] = 10;
	lcall	_GetTxBuf
	mov	a,dpl
	mov	b,dph
	add	a,#0x01
	mov	dpl,a
	clr	a
	addc	a,b
	mov	dph,a
	mov	a,#0x0A
	movx	@dptr,a
;	iso.c:77: ComputeCrc(TX_BUF, 2);
	lcall	_GetTxBuf
	mov	r6,dpl
	mov	r7,dph
	mov	r5,#0x00
	mov	_ComputeCrc_PARM_2,#0x02
	mov	(_ComputeCrc_PARM_2 + 1),#0x00
	mov	dpl,r6
	mov	dph,r7
	mov	b,r5
	lcall	_ComputeCrc
;	iso.c:78: SendPacket(PICC, 0, TX_BUF, 4);
	lcall	_GetTxBuf
	mov	_SendPacket_PARM_3,dpl
	mov	(_SendPacket_PARM_3 + 1),dph
	mov	_SendPacket_PARM_2,#0x00
	mov	_SendPacket_PARM_4,#0x04
	mov	(_SendPacket_PARM_4 + 1),#0x00
	mov	dpl,#0x01
	ljmp	_SendPacket
;------------------------------------------------------------
;Allocation info for local variables in function 'HandleWtx'
;------------------------------------------------------------
;wtx                       Allocated to registers r5 r6 r7 
;------------------------------------------------------------
;	iso.c:82: static int8_t HandleWtx(WtxContext * wtx) {
;	-----------------------------------------
;	 function HandleWtx
;	-----------------------------------------
_HandleWtx:
;	iso.c:84: if(wtx->spinCount == 0 && !wtx->missingAcks) {
	mov	r5,dpl
	mov	r6,dph
	mov	r7,b
	lcall	__gptrget
	mov	r1,a
	inc	dptr
	lcall	__gptrget
	mov	r2,a
	inc	dptr
	lcall	__gptrget
	mov	r3,a
	inc	dptr
	lcall	__gptrget
	mov	r4,a
	mov	a,r1
	orl	a,r2
	orl	a,r3
	orl	a,r4
	jnz	00102$
	mov	a,#0x04
	add	a,r5
	mov	r2,a
	clr	a
	addc	a,r6
	mov	r3,a
	mov	ar4,r7
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	lcall	__gptrget
	jnz	00102$
;	iso.c:85: SendSwtx();
	push	ar7
	push	ar6
	push	ar5
	push	ar4
	push	ar3
	push	ar2
	lcall	_SendSwtx
	pop	ar2
	pop	ar3
	pop	ar4
	pop	ar5
	pop	ar6
	pop	ar7
;	iso.c:86: ++(wtx->missingAcks);
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	lcall	__gptrget
	mov	r1,a
	inc	r1
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r1
	lcall	__gptrput
;	iso.c:87: wtx->spinCount = SWTX_INTERVAL;
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	mov	a,#0xB0
	lcall	__gptrput
	inc	dptr
	mov	a,#0x04
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
00102$:
;	iso.c:89: --(wtx->spinCount);
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	lcall	__gptrget
	mov	r1,a
	inc	dptr
	lcall	__gptrget
	mov	r2,a
	inc	dptr
	lcall	__gptrget
	mov	r3,a
	inc	dptr
	lcall	__gptrget
	mov	r4,a
	dec	r1
	cjne	r1,#0xFF,00124$
	dec	r2
	cjne	r2,#0xFF,00124$
	dec	r3
	cjne	r3,#0xFF,00124$
	dec	r4
00124$:
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	mov	a,r1
	lcall	__gptrput
	inc	dptr
	mov	a,r2
	lcall	__gptrput
	inc	dptr
	mov	a,r3
	lcall	__gptrput
	inc	dptr
	mov	a,r4
	lcall	__gptrput
;	iso.c:91: if(PacketAvailable(PICC)) {
	mov	dpl,#0x01
	push	ar7
	push	ar6
	push	ar5
	lcall	_PacketAvailable
	mov	a,dpl
	pop	ar5
	pop	ar6
	pop	ar7
	jz	00107$
;	iso.c:92: if(piccRx[0] != WTX_RESPONSE) {
	mov	dpl,_piccRx
	mov	dph,(_piccRx + 1)
	movx	a,@dptr
	mov	r4,a
	cjne	r4,#0xF2,00126$
	sjmp	00105$
00126$:
;	iso.c:93: return -1;
	mov	dpl,#0xFF
	ret
00105$:
;	iso.c:95: --(wtx->missingAcks);
	mov	a,#0x04
	add	a,r5
	mov	r2,a
	clr	a
	addc	a,r6
	mov	r3,a
	mov	ar4,r7
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	lcall	__gptrget
	mov	r1,a
	dec	r1
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r1
	lcall	__gptrput
;	iso.c:96: SendDebug(D_WTX_ACK);
	mov	dpl,#0x0F
	push	ar7
	push	ar6
	push	ar5
	lcall	_SendDebug
;	iso.c:98: ResetRx(PICC);
	mov	dpl,#0x01
	lcall	_ResetRx
	pop	ar5
	pop	ar6
	pop	ar7
00107$:
;	iso.c:100: return wtx->missingAcks;
	mov	a,#0x04
	add	a,r5
	mov	r5,a
	clr	a
	addc	a,r6
	mov	r6,a
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	lcall	__gptrget
	mov	dpl,a
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'IsoInit'
;------------------------------------------------------------
;	iso.c:106: void IsoInit() {
;	-----------------------------------------
;	 function IsoInit
;	-----------------------------------------
_IsoInit:
;	iso.c:107: piccRx = GetRx(PICC);
	mov	dpl,#0x01
	lcall	_GetRx
	mov	_piccRx,dpl
	mov	(_piccRx + 1),dph
;	iso.c:108: hostRx = GetRx(HOST);
	mov	dpl,#0x00
	lcall	_GetRx
	mov	_hostRx,dpl
	mov	(_hostRx + 1),dph
;	iso.c:109: iBlockReceived = 0;
	mov	_iBlockReceived,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'IsoProcessPcd'
;------------------------------------------------------------
;rxLen                     Allocated to registers 
;------------------------------------------------------------
;	iso.c:112: void IsoProcessPcd(void) {
;	-----------------------------------------
;	 function IsoProcessPcd
;	-----------------------------------------
_IsoProcessPcd:
;	iso.c:113: uint8_t rxLen = GetRxCount(PICC);
	mov	dpl,#0x01
	lcall	_GetRxCount
;	iso.c:117: switch(piccRx[0] & BLOCK_MASK) {
	mov	dpl,_piccRx
	mov	dph,(_piccRx + 1)
	movx	a,@dptr
	mov	r7,a
	anl	ar7,#0xE0
	cjne	r7,#0x00,00122$
	sjmp	00101$
00122$:
	cjne	r7,#0xA0,00123$
	sjmp	00102$
00123$:
;	iso.c:118: case I_BLOCK:
	cjne	r7,#0xC0,00104$
	sjmp	00103$
00101$:
;	iso.c:119: ProcessIBlock();
;	iso.c:120: break;
;	iso.c:122: case R_BLOCK:
	ljmp	_ProcessIBlock
00102$:
;	iso.c:123: ProcessRBlock();
;	iso.c:124: break;
;	iso.c:126: case S_BLOCK:
	ljmp	_ProcessRBlock
00103$:
;	iso.c:127: ProcessSBlock();
;	iso.c:128: break;
;	iso.c:130: default:
	ljmp	_ProcessSBlock
00104$:
;	iso.c:131: switch(piccRx[0]) {
	mov	dpl,_piccRx
	mov	dph,(_piccRx + 1)
	movx	a,@dptr
	mov	r7,a
	cjne	r7,#0xE0,00106$
;	iso.c:133: blockNumber = 1;
	mov	_blockNumber,#0x01
;	iso.c:134: fsd = DECODE_FSDI(piccRx[1] >> 4);
	mov	dpl,_piccRx
	mov	dph,(_piccRx + 1)
	inc	dptr
	movx	a,@dptr
	mov	r7,a
	swap	a
	anl	a,#0x0F
	mov	b,#0x02
	mul	ab
	add	a,#_fsdTable
	mov	dpl,a
	mov	a,#(_fsdTable >> 8)
	addc	a,b
	mov	dph,a
	clr	a
	movc	a,@a+dptr
	mov	r5,a
	inc	dptr
	clr	a
	movc	a,@a+dptr
	mov	_fsd,r5
;	iso.c:135: cid = piccRx[1] & 0x0F;
	mov	a,#0x0F
	anl	a,r7
	mov	_cid,a
;	iso.c:136: SendAts();
	lcall	_SendAts
;	iso.c:138: }
00106$:
;	iso.c:139: ResetRx(PICC);
	mov	dpl,#0x01
;	iso.c:141: }
	ljmp	_ResetRx
;------------------------------------------------------------
;Allocation info for local variables in function 'SendAts'
;------------------------------------------------------------
;__00010001                Allocated to registers r6 r7 
;__00010002                Allocated to registers r6 r7 
;------------------------------------------------------------
;	iso.c:149: static void SendAts(void) {
;	-----------------------------------------
;	 function SendAts
;	-----------------------------------------
_SendAts:
;	iso.c:150: TX_BUF[0] = 1;
	lcall	_GetTxBuf
	mov	a,#0x01
	movx	@dptr,a
;	iso.c:151: memcpy(TX_BUF+TX_BUF[0], ats, sizeof(ats));
	lcall	_GetTxBuf
	mov	r6,dpl
	mov	r7,dph
	push	ar7
	push	ar6
	lcall	_GetTxBuf
	pop	ar6
	pop	ar7
	movx	a,@dptr
	add	a,r6
	mov	r6,a
	clr	a
	addc	a,r7
	mov	r7,a
	mov	r5,#0x00
	mov	_memcpy_PARM_2,#_ats
	mov	(_memcpy_PARM_2 + 1),#(_ats >> 8)
	mov	(_memcpy_PARM_2 + 2),#0x80
	mov	_memcpy_PARM_3,#0x04
	mov	(_memcpy_PARM_3 + 1),#0x00
	mov	dpl,r6
	mov	dph,r7
	mov	b,r5
	lcall	_memcpy
;	iso.c:152: TX_BUF[3] = 0xa0; // override default fwi
	lcall	_GetTxBuf
	mov	a,dpl
	mov	b,dph
	add	a,#0x03
	mov	dpl,a
	clr	a
	addc	a,b
	mov	dph,a
	mov	a,#0xA0
	movx	@dptr,a
;	iso.c:153: TX_BUF[0] += sizeof(ats);
	lcall	_GetTxBuf
	mov	r6,dpl
	mov  r7,dph
	movx	a,@dptr
	add	a,#0x04
	mov	dpl,r6
	mov	dph,r7
	movx	@dptr,a
;	iso.c:154: memcpy(TX_BUF+TX_BUF[0], historical, sizeof(historical));
	lcall	_GetTxBuf
	mov	r6,dpl
	mov	r7,dph
	push	ar7
	push	ar6
	lcall	_GetTxBuf
	pop	ar6
	pop	ar7
	movx	a,@dptr
	add	a,r6
	mov	r6,a
	clr	a
	addc	a,r7
	mov	r7,a
	mov	r5,#0x00
	mov	_memcpy_PARM_2,#_historical
	mov	(_memcpy_PARM_2 + 1),#(_historical >> 8)
	mov	(_memcpy_PARM_2 + 2),#0x80
	mov	_memcpy_PARM_3,#0x0F
	mov	(_memcpy_PARM_3 + 1),#0x00
	mov	dpl,r6
	mov	dph,r7
	mov	b,r5
	lcall	_memcpy
;	iso.c:155: TX_BUF[0] += sizeof(historical);
	lcall	_GetTxBuf
	mov	r6,dpl
	mov  r7,dph
	movx	a,@dptr
	add	a,#0x0F
	mov	dpl,r6
	mov	dph,r7
	movx	@dptr,a
;	iso.c:156: ComputeCrc(TX_BUF, TX_BUF[0]);
	lcall	_GetTxBuf
	mov	r6,dpl
	mov	r7,dph
	mov	r5,#0x00
	push	ar7
	push	ar6
	push	ar5
	lcall	_GetTxBuf
	pop	ar5
	pop	ar6
	pop	ar7
	movx	a,@dptr
	mov	r4,a
	mov	_ComputeCrc_PARM_2,r4
	mov	(_ComputeCrc_PARM_2 + 1),#0x00
	mov	dpl,r6
	mov	dph,r7
	mov	b,r5
	lcall	_ComputeCrc
;	iso.c:157: SendPacket(PICC, 0, TX_BUF, TX_BUF[0]+2);
	lcall	_GetTxBuf
	mov	r6,dpl
	mov	r7,dph
	push	ar7
	push	ar6
	lcall	_GetTxBuf
	pop	ar6
	pop	ar7
	movx	a,@dptr
	mov	r5,a
	mov	r4,#0x00
	mov	a,#0x02
	add	a,r5
	mov	_SendPacket_PARM_4,a
	clr	a
	addc	a,r4
	mov	(_SendPacket_PARM_4 + 1),a
	mov	_SendPacket_PARM_2,#0x00
	mov	_SendPacket_PARM_3,r6
	mov	(_SendPacket_PARM_3 + 1),r7
	mov	dpl,#0x01
	lcall	_SendPacket
;	iso.c:159: SendDebug(D_ISO_L4_ACTIVATED); 
	mov	dpl,#0x09
	ljmp	_SendDebug
;------------------------------------------------------------
;Allocation info for local variables in function 'ProcessIBlock'
;------------------------------------------------------------
;apduOffset                Allocated with name '_ProcessIBlock_apduOffset_1_54'
;needSwtxAck               Allocated to registers 
;responseComplete          Allocated to registers 
;pcb                       Allocated to registers r6 
;cid                       Allocated to registers 
;sWtx                      Allocated with name '_ProcessIBlock_sWtx_1_54'
;sloc0                     Allocated with name '_ProcessIBlock_sloc0_1_0'
;------------------------------------------------------------
;	iso.c:162: static void ProcessIBlock() {    
;	-----------------------------------------
;	 function ProcessIBlock
;	-----------------------------------------
_ProcessIBlock:
;	iso.c:163: uint8_t apduOffset = 1;
	mov	_ProcessIBlock_apduOffset_1_54,#0x01
;	iso.c:166: uint8_t pcb = piccRx[0];
	mov	dpl,_piccRx
	mov	dph,(_piccRx + 1)
	movx	a,@dptr
	mov	r6,a
;	iso.c:169: iBlockReceived = 1;
	mov	_iBlockReceived,#0x01
;	iso.c:170: blockNumber ^= 1;
	xrl	_blockNumber,#0x01
;	iso.c:175: if(pcb & NAD_FOLLOWING) ++apduOffset;
	mov	a,r6
	jnb	acc.2,00102$
	mov	_ProcessIBlock_apduOffset_1_54,#0x02
00102$:
;	iso.c:176: ResetRx(HOST);
	mov	dpl,#0x00
	lcall	_ResetRx
;	iso.c:179: SendPacket(HOST, ID_APDU_DOWN, piccRx+apduOffset, GetRxCount(PICC)-apduOffset-2);
	mov	a,_ProcessIBlock_apduOffset_1_54
	add	a,_piccRx
	mov	r5,a
	clr	a
	addc	a,(_piccRx + 1)
	mov	r6,a
	mov	dpl,#0x01
	push	ar6
	push	ar5
	lcall	_GetRxCount
	mov	r3,dpl
	mov	r4,dph
	pop	ar5
	pop	ar6
	mov	r1,_ProcessIBlock_apduOffset_1_54
	mov	r2,#0x00
	mov	a,r3
	clr	c
	subb	a,r1
	mov	r3,a
	mov	a,r4
	subb	a,r2
	mov	r4,a
	mov	a,r3
	add	a,#0xFE
	mov	_SendPacket_PARM_4,a
	mov	a,r4
	addc	a,#0xFF
	mov	(_SendPacket_PARM_4 + 1),a
	mov	_SendPacket_PARM_2,#0x21
	mov	_SendPacket_PARM_3,r5
	mov	(_SendPacket_PARM_3 + 1),r6
	mov	dpl,#0x00
	push	ar2
	push	ar1
	lcall	_SendPacket
;	iso.c:181: ResetRx(PICC);
	mov	dpl,#0x01
	lcall	_ResetRx
;	iso.c:182: ResetWtx(&sWtx);
	mov	dptr,#_ProcessIBlock_sWtx_1_54
	mov	b,#0x40
	lcall	_ResetWtx
;	iso.c:184: SendSwtx();
	lcall	_SendSwtx
	pop	ar1
	pop	ar2
;	iso.c:185: while(!PacketAvailable(PICC));
00103$:
	mov	dpl,#0x01
	push	ar2
	push	ar1
	lcall	_PacketAvailable
	mov	a,dpl
	pop	ar1
	pop	ar2
	jz	00103$
;	iso.c:187: if(piccRx[0] != WTX_RESPONSE) {
	mov	dpl,_piccRx
	mov	dph,(_piccRx + 1)
	movx	a,@dptr
	mov	r6,a
	cjne	r6,#0xF2,00161$
	sjmp	00107$
00161$:
;	iso.c:188: return;
	ret
00107$:
;	iso.c:190: SendDebug(D_WTX_ACK);
	mov	dpl,#0x0F
	push	ar2
	push	ar1
	lcall	_SendDebug
;	iso.c:191: ResetRx(PICC);
	mov	dpl,#0x01
	lcall	_ResetRx
	pop	ar1
	pop	ar2
;	iso.c:194: while(1) {
00122$:
;	iso.c:202: if(PacketAvailable(HOST)) {  // host sent (last part of) response
	mov	dpl,#0x00
	push	ar2
	push	ar1
	lcall	_PacketAvailable
	mov	a,dpl
	pop	ar1
	pop	ar2
	jnz	00162$
	ljmp	00119$
00162$:
;	iso.c:203: SendDebug(D_GEN_0);
	mov	dpl,#0x10
	push	ar2
	push	ar1
	lcall	_SendDebug
;	iso.c:204: TX_BUF[0] = 0x02 | blockNumber;                      // PCB
	lcall	_GetTxBuf
	mov	a,#0x02
	orl	a,_blockNumber
	movx	@dptr,a
;	iso.c:205: memcpy(TX_BUF+apduOffset, hostRx, GetRxCount(HOST)); // APDU data
	lcall	_GetTxBuf
	mov	a,dpl
	mov	b,dph
	pop	ar1
	pop	ar2
	add	a,_ProcessIBlock_apduOffset_1_54
	mov	r5,a
	clr	a
	addc	a,b
	mov	r6,a
	mov	_ProcessIBlock_sloc0_1_0,r5
	mov	(_ProcessIBlock_sloc0_1_0 + 1),r6
	mov	(_ProcessIBlock_sloc0_1_0 + 2),#0x00
	mov	r0,_hostRx
	mov	r3,(_hostRx + 1)
	mov	r6,#0x00
	mov	dpl,#0x00
	push	ar6
	push	ar3
	push	ar2
	push	ar1
	push	ar0
	lcall	_GetRxCount
	mov	_memcpy_PARM_3,dpl
	mov	(_memcpy_PARM_3 + 1),dph
	pop	ar0
	pop	ar1
	pop	ar2
	pop	ar3
	pop	ar6
	mov	_memcpy_PARM_2,r0
	mov	(_memcpy_PARM_2 + 1),r3
	mov	(_memcpy_PARM_2 + 2),r6
	mov	dpl,_ProcessIBlock_sloc0_1_0
	mov	dph,(_ProcessIBlock_sloc0_1_0 + 1)
	mov	b,(_ProcessIBlock_sloc0_1_0 + 2)
	push	ar2
	push	ar1
	lcall	_memcpy
;	iso.c:206: ComputeCrc(TX_BUF, GetRxCount(HOST)+apduOffset);  // CRC
	lcall	_GetTxBuf
	mov	r5,dpl
	mov	r6,dph
	pop	ar1
	pop	ar2
	mov	r4,#0x00
	mov	dpl,#0x00
	push	ar6
	push	ar5
	push	ar4
	push	ar2
	push	ar1
	lcall	_GetRxCount
	mov	a,dpl
	mov	b,dph
	pop	ar1
	pop	ar2
	pop	ar4
	pop	ar5
	pop	ar6
	add	a,r1
	mov	_ComputeCrc_PARM_2,a
	mov	a,r2
	addc	a,b
	mov	(_ComputeCrc_PARM_2 + 1),a
	mov	dpl,r5
	mov	dph,r6
	mov	b,r4
	push	ar2
	push	ar1
	lcall	_ComputeCrc
;	iso.c:208: SendPacket(PICC, 0, TX_BUF, GetRxCount(HOST)+apduOffset+2);
	lcall	_GetTxBuf
	mov	r5,dpl
	mov	r6,dph
	pop	ar1
	pop	ar2
	mov	dpl,#0x00
	push	ar6
	push	ar5
	push	ar2
	push	ar1
	lcall	_GetRxCount
	mov	a,dpl
	mov	b,dph
	pop	ar1
	pop	ar2
	pop	ar5
	pop	ar6
	add	a,r1
	mov	r3,a
	mov	a,r2
	addc	a,b
	mov	r4,a
	mov	a,#0x02
	add	a,r3
	mov	_SendPacket_PARM_4,a
	clr	a
	addc	a,r4
	mov	(_SendPacket_PARM_4 + 1),a
	mov	_SendPacket_PARM_2,#0x00
	mov	_SendPacket_PARM_3,r5
	mov	(_SendPacket_PARM_3 + 1),r6
	mov	dpl,#0x01
	lcall	_SendPacket
;	iso.c:209: ResetRx(HOST);
	mov	dpl,#0x00
;	iso.c:210: return;
	ljmp	_ResetRx
00119$:
;	iso.c:211: } else if(GetRxCount(HOST) == (BUFSIZE-1))  { // host sent part of response
	mov	dpl,#0x00
	push	ar2
	push	ar1
	lcall	_GetRxCount
	mov	r5,dpl
	mov	r6,dph
	pop	ar1
	pop	ar2
	cjne	r5,#0xFF,00163$
	cjne	r6,#0x00,00163$
	sjmp	00164$
00163$:
	ljmp	00122$
00164$:
;	iso.c:212: TX_BUF[0] = 0x12 | blockNumber; // PCB w/ chaining bit
	push	ar2
	push	ar1
	lcall	_GetTxBuf
	mov	a,#0x12
	orl	a,_blockNumber
	movx	@dptr,a
;	iso.c:213: memcpy(TX_BUF+apduOffset, hostRx, GetRxCount(HOST)); // APDU data
	lcall	_GetTxBuf
	mov	a,dpl
	mov	b,dph
	pop	ar1
	pop	ar2
	add	a,_ProcessIBlock_apduOffset_1_54
	mov	r5,a
	clr	a
	addc	a,b
	mov	r6,a
	mov	r4,#0x00
	mov	r0,_hostRx
	mov	r3,(_hostRx + 1)
	mov	r7,#0x00
	mov	dpl,#0x00
	push	ar7
	push	ar6
	push	ar5
	push	ar4
	push	ar3
	push	ar2
	push	ar1
	push	ar0
	lcall	_GetRxCount
	mov	_memcpy_PARM_3,dpl
	mov	(_memcpy_PARM_3 + 1),dph
	pop	ar0
	pop	ar1
	pop	ar2
	pop	ar3
	pop	ar4
	pop	ar5
	pop	ar6
	pop	ar7
	mov	_memcpy_PARM_2,r0
	mov	(_memcpy_PARM_2 + 1),r3
	mov	(_memcpy_PARM_2 + 2),r7
	mov	dpl,r5
	mov	dph,r6
	mov	b,r4
	push	ar2
	push	ar1
	lcall	_memcpy
;	iso.c:214: ComputeCrc(TX_BUF, GetRxCount(HOST)+apduOffset);  // CRC
	lcall	_GetTxBuf
	mov	r6,dpl
	mov	r7,dph
	pop	ar1
	pop	ar2
	mov	r5,#0x00
	mov	dpl,#0x00
	push	ar7
	push	ar6
	push	ar5
	push	ar2
	push	ar1
	lcall	_GetRxCount
	mov	a,dpl
	mov	b,dph
	pop	ar1
	pop	ar2
	pop	ar5
	pop	ar6
	pop	ar7
	add	a,r1
	mov	_ComputeCrc_PARM_2,a
	mov	a,r2
	addc	a,b
	mov	(_ComputeCrc_PARM_2 + 1),a
	mov	dpl,r6
	mov	dph,r7
	mov	b,r5
	push	ar2
	push	ar1
	lcall	_ComputeCrc
;	iso.c:215: SendPacket(PICC, 0, TX_BUF, GetRxCount(HOST)+apduOffset+2);
	lcall	_GetTxBuf
	mov	r6,dpl
	mov	r7,dph
	pop	ar1
	pop	ar2
	mov	dpl,#0x00
	push	ar7
	push	ar6
	push	ar2
	push	ar1
	lcall	_GetRxCount
	mov	a,dpl
	mov	b,dph
	pop	ar1
	pop	ar2
	pop	ar6
	pop	ar7
	add	a,r1
	mov	r4,a
	mov	a,r2
	addc	a,b
	mov	r5,a
	mov	a,#0x02
	add	a,r4
	mov	_SendPacket_PARM_4,a
	clr	a
	addc	a,r5
	mov	(_SendPacket_PARM_4 + 1),a
	mov	_SendPacket_PARM_2,#0x00
	mov	_SendPacket_PARM_3,r6
	mov	(_SendPacket_PARM_3 + 1),r7
	mov	dpl,#0x01
	push	ar2
	push	ar1
	lcall	_SendPacket
;	iso.c:216: ResetRx(HOST);            
	mov	dpl,#0x00
	lcall	_ResetRx
	pop	ar1
	pop	ar2
;	iso.c:219: while(!PacketAvailable(PICC));
00108$:
	mov	dpl,#0x01
	push	ar2
	push	ar1
	lcall	_PacketAvailable
	mov	a,dpl
	pop	ar1
	pop	ar2
	jz	00108$
;	iso.c:220: if(IS_NAK(piccRx[0])) { 
	mov	dpl,_piccRx
	mov	dph,(_piccRx + 1)
	movx	a,@dptr
	mov	r7,a
	anl	ar7,#0xF0
	cjne	r7,#0xB0,00114$
;	iso.c:221: SendDebug(D_NAK_RECEIVED);
	mov	dpl,#0x0D
;	iso.c:222: return;
	ljmp	_SendDebug
00114$:
;	iso.c:223: } else if(IS_ACK(piccRx[0])) {
	mov	dpl,_piccRx
	mov	dph,(_piccRx + 1)
	movx	a,@dptr
	mov	r7,a
	anl	ar7,#0xF0
	cjne	r7,#0xA0,00115$
;	iso.c:224: SendDebug(D_ACK_RECEIVED);
	mov	dpl,#0x0C
	push	ar2
	push	ar1
	lcall	_SendDebug
	pop	ar1
	pop	ar2
00115$:
;	iso.c:226: ResetRx(PICC); 
	mov	dpl,#0x01
	push	ar2
	push	ar1
	lcall	_ResetRx
	pop	ar1
	pop	ar2
;	iso.c:227: blockNumber ^= 1;
	xrl	_blockNumber,#0x01
	ljmp	00122$
;------------------------------------------------------------
;Allocation info for local variables in function 'ProcessRBlock'
;------------------------------------------------------------
;	iso.c:240: static void ProcessRBlock() {
;	-----------------------------------------
;	 function ProcessRBlock
;	-----------------------------------------
_ProcessRBlock:
;	iso.c:241: if(piccRx[0] & R_NAK) {
	mov	dpl,_piccRx
	mov	dph,(_piccRx + 1)
	movx	a,@dptr
	mov	r7,a
	jnb	acc.4,00106$
;	iso.c:242: SendDebug(D_NAK_RECEIVED);
	mov	dpl,#0x0D
	lcall	_SendDebug
;	iso.c:244: if((piccRx[0] & 1) == blockNumber) {
	mov	dpl,_piccRx
	mov	dph,(_piccRx + 1)
	movx	a,@dptr
	anl	a,#0x01
	mov	r7,a
	cjne	a,_blockNumber,00104$
;	iso.c:245: if(iBlockReceived == 0) blockNumber ^= 1;
	mov	a,_iBlockReceived
	jnz	00104$
	xrl	_blockNumber,#0x01
00104$:
;	iso.c:252: TX_BUF[0] = 0xA3;
	lcall	_GetTxBuf
	mov	a,#0xA3
	movx	@dptr,a
;	iso.c:253: ComputeCrc(TX_BUF, 1);
	lcall	_GetTxBuf
	mov	r6,dpl
	mov	r7,dph
	mov	r5,#0x00
	mov	_ComputeCrc_PARM_2,#0x01
	mov	(_ComputeCrc_PARM_2 + 1),#0x00
	mov	dpl,r6
	mov	dph,r7
	mov	b,r5
	lcall	_ComputeCrc
;	iso.c:254: SendPacket(PICC, 0, TX_BUF, 3);
	lcall	_GetTxBuf
	mov	_SendPacket_PARM_3,dpl
	mov	(_SendPacket_PARM_3 + 1),dph
	mov	_SendPacket_PARM_2,#0x00
	mov	_SendPacket_PARM_4,#0x03
	mov	(_SendPacket_PARM_4 + 1),#0x00
	mov	dpl,#0x01
	lcall	_SendPacket
	sjmp	00107$
00106$:
;	iso.c:256: SendDebug(D_ACK_RECEIVED);
	mov	dpl,#0x0C
	lcall	_SendDebug
00107$:
;	iso.c:258: ResetRx(PICC);
	mov	dpl,#0x01
	ljmp	_ResetRx
;------------------------------------------------------------
;Allocation info for local variables in function 'ProcessSBlock'
;------------------------------------------------------------
;	iso.c:261: static void ProcessSBlock() { 
;	-----------------------------------------
;	 function ProcessSBlock
;	-----------------------------------------
_ProcessSBlock:
;	iso.c:263: switch(piccRx[0]) {
	mov	dpl,_piccRx
	mov	dph,(_piccRx + 1)
	movx	a,@dptr
	mov	r7,a
	cjne	r7,#0xC2,00114$
	sjmp	00102$
00114$:
	cjne	r7,#0xCA,00105$
;	iso.c:265: if(piccRx[1] == cid) {
	mov	dpl,_piccRx
	mov	dph,(_piccRx + 1)
	inc	dptr
	movx	a,@dptr
	mov	r7,a
	cjne	a,_cid,00105$
;	iso.c:266: case CMD_DESELECT:
00102$:
;	iso.c:267: SendDebug(D_ISO_DESELECT);        
	mov	dpl,#0x0E
	lcall	_SendDebug
;	iso.c:268: SendDeselectResp();            
	lcall	_SendDeselectResp
;	iso.c:269: iBlockReceived = 0;
	mov	_iBlockReceived,#0x00
;	iso.c:272: }
00105$:
;	iso.c:273: ResetRx(PICC);
	mov	dpl,#0x01
	ljmp	_ResetRx
;------------------------------------------------------------
;Allocation info for local variables in function 'SendDeselectResp'
;------------------------------------------------------------
;	iso.c:276: static void SendDeselectResp(void) {
;	-----------------------------------------
;	 function SendDeselectResp
;	-----------------------------------------
_SendDeselectResp:
;	iso.c:277: memcpy(TX_BUF,piccRx,3);
	lcall	_GetTxBuf
	mov	r6,dpl
	mov	r7,dph
	mov	r5,#0x00
	mov	_memcpy_PARM_2,_piccRx
	mov	(_memcpy_PARM_2 + 1),(_piccRx + 1)
	mov	(_memcpy_PARM_2 + 2),#0x00
	mov	_memcpy_PARM_3,#0x03
	mov	(_memcpy_PARM_3 + 1),#0x00
	mov	dpl,r6
	mov	dph,r7
	mov	b,r5
	lcall	_memcpy
;	iso.c:278: SendPacket(PICC, 0, piccRx, 3);
	mov	_SendPacket_PARM_2,#0x00
	mov	_SendPacket_PARM_3,_piccRx
	mov	(_SendPacket_PARM_3 + 1),(_piccRx + 1)
	mov	_SendPacket_PARM_4,#0x03
	mov	(_SendPacket_PARM_4 + 1),#0x00
	mov	dpl,#0x01
	ljmp	_SendPacket
	.area CSEG    (CODE)
	.area CONST   (CODE)
_fsdTable:
	.byte #0x10,#0x00	; 16
	.byte #0x18,#0x00	; 24
	.byte #0x20,#0x00	; 32
	.byte #0x28,#0x00	; 40
	.byte #0x30,#0x00	; 48
	.byte #0x40,#0x00	; 64
	.byte #0x60,#0x00	; 96
	.byte #0x80,#0x00	; 128
	.byte #0x00,#0x01	; 256
_ats:
	.db #0x77	; 119	'w'
	.db #0x80	; 128
	.db #0x70	; 112	'p'
	.db #0x00	; 0
_historical:
	.db #0x45	; 69	'E'
	.db #0x50	; 80	'P'
	.db #0x41	; 65	'A'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x61	; 97	'a'
	.db #0x27	; 39
	.db #0x38	; 56	'8'
	.db #0x94	; 148
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
