;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.3.0 #8604 (Sep  2 2013) (Linux)
; This file was generated Thu May  8 18:45:15 2014
;--------------------------------------------------------
	.module main
	.optsdcc -mmcs51 --model-small
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _DelayMs
	.globl _Delay
	.globl _IsoInit
	.globl _IsoProcessPcd
	.globl _SendDebug
	.globl _PacketAvailable
	.globl _GetRxCount
	.globl _ResetRx
	.globl _GetTxBuf
	.globl _GetRx
	.globl _SendPacket
	.globl _IfInit
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
	.globl _EchoMode
	.globl _EchoCountMode
	.globl _SmartcardMode
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
_DelayMs_n_1_19:
	.ds 2
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	.area	OSEG    (OVR,DATA)
_Delay_d_1_17:
	.ds 2
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG	(DATA)
__start__stack:
	.ds	1

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
; interrupt vector 
;--------------------------------------------------------
	.area HOME    (CODE)
__interrupt_vect:
	ljmp	__sdcc_gsinit_startup
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME    (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area GSINIT  (CODE)
	.globl __sdcc_gsinit_startup
	.globl __sdcc_program_startup
	.globl __start__stack
	.globl __mcs51_genXINIT
	.globl __mcs51_genXRAMCLEAR
	.globl __mcs51_genRAMCLEAR
	.area GSFINAL (CODE)
	ljmp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME    (CODE)
	.area HOME    (CODE)
__sdcc_program_startup:
	ljmp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CSEG    (CODE)
;------------------------------------------------------------
;Allocation info for local variables in function 'Delay'
;------------------------------------------------------------
;t                         Allocated to registers 
;d                         Allocated with name '_Delay_d_1_17'
;------------------------------------------------------------
;	main.c:10: void Delay(uint16_t const t) {
;	-----------------------------------------
;	 function Delay
;	-----------------------------------------
_Delay:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
	mov	_Delay_d_1_17,dpl
	mov	(_Delay_d_1_17 + 1),dph
;	main.c:12: while(--d);
00101$:
	dec	_Delay_d_1_17
	mov	a,#0xFF
	cjne	a,_Delay_d_1_17,00109$
	dec	(_Delay_d_1_17 + 1)
00109$:
	mov	a,_Delay_d_1_17
	orl	a,(_Delay_d_1_17 + 1)
	jnz	00101$
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'DelayMs'
;------------------------------------------------------------
;ms                        Allocated to registers 
;n                         Allocated with name '_DelayMs_n_1_19'
;------------------------------------------------------------
;	main.c:15: void DelayMs(uint16_t const ms) {
;	-----------------------------------------
;	 function DelayMs
;	-----------------------------------------
_DelayMs:
	mov	_DelayMs_n_1_19,dpl
	mov	(_DelayMs_n_1_19 + 1),dph
;	main.c:17: while(--n) Delay(1820);
00101$:
	dec	_DelayMs_n_1_19
	mov	a,#0xFF
	cjne	a,_DelayMs_n_1_19,00112$
	dec	(_DelayMs_n_1_19 + 1)
00112$:
	mov	a,_DelayMs_n_1_19
	orl	a,(_DelayMs_n_1_19 + 1)
	jz	00104$
	mov	dptr,#0x071C
	lcall	_Delay
	sjmp	00101$
00104$:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;mode                      Allocated to registers r7 
;------------------------------------------------------------
;	main.c:32: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	main.c:34: uint8_t mode = INVALID_MODE;
	mov	r7,#0xFF
;	main.c:35: P0 = 0x00;
	mov	_P0,#0x00
;	main.c:37: IfInit();
	push	ar7
	lcall	_IfInit
	pop	ar7
;	main.c:39: while(mode == INVALID_MODE) {
00107$:
	cjne	r7,#0xFF,00137$
	sjmp	00138$
00137$:
	ljmp	00109$
00138$:
;	main.c:40: while(!PacketAvailable(HOST));
00101$:
	mov	dpl,#0x00
	push	ar7
	lcall	_PacketAvailable
	mov	a,dpl
	pop	ar7
	jz	00101$
;	main.c:41: if(GetRxCount(HOST) == 1) {
	mov	dpl,#0x00
	push	ar7
	lcall	_GetRxCount
	mov	r5,dpl
	mov	r6,dph
	pop	ar7
	cjne	r5,#0x01,00105$
	cjne	r6,#0x00,00105$
;	main.c:42: mode = *GetRx(HOST);
	mov	dpl,#0x00
	lcall	_GetRx
	movx	a,@dptr
	mov	r7,a
;	main.c:43: TX_BUF[0] = RESP_OK;
	push	ar7
	lcall	_GetTxBuf
	clr	a
	movx	@dptr,a
;	main.c:44: TX_BUF[1] = mode;
	lcall	_GetTxBuf
	mov	a,dpl
	mov	b,dph
	pop	ar7
	add	a,#0x01
	mov	dpl,a
	clr	a
	addc	a,b
	mov	dph,a
	mov	a,r7
	movx	@dptr,a
;	main.c:45: SendPacket(HOST, ID_CTRL, TX_BUF, 2);
	push	ar7
	lcall	_GetTxBuf
	mov	_SendPacket_PARM_3,dpl
	mov	(_SendPacket_PARM_3 + 1),dph
	mov	_SendPacket_PARM_2,#0x61
	mov	_SendPacket_PARM_4,#0x02
	mov	(_SendPacket_PARM_4 + 1),#0x00
	mov	dpl,#0x00
	lcall	_SendPacket
	pop	ar7
	sjmp	00106$
00105$:
;	main.c:47: TX_BUF[0] = RESP_ERROR;
	push	ar7
	lcall	_GetTxBuf
	mov	a,#0x01
	movx	@dptr,a
;	main.c:48: SendPacket(HOST, ID_CTRL, TX_BUF, 1);
	lcall	_GetTxBuf
	mov	_SendPacket_PARM_3,dpl
	mov	(_SendPacket_PARM_3 + 1),dph
	mov	_SendPacket_PARM_2,#0x61
	mov	_SendPacket_PARM_4,#0x01
	mov	(_SendPacket_PARM_4 + 1),#0x00
	mov	dpl,#0x00
	lcall	_SendPacket
	pop	ar7
00106$:
;	main.c:50: ResetRx(HOST);
	mov	dpl,#0x00
	push	ar7
	lcall	_ResetRx
	pop	ar7
	ljmp	00107$
00109$:
;	main.c:53: switch(mode) {
	cjne	r7,#0x00,00142$
	sjmp	00110$
00142$:
	cjne	r7,#0x01,00143$
	sjmp	00111$
00143$:
;	main.c:54: case ECHO_MODE:
	cjne	r7,#0x02,00114$
	sjmp	00112$
00110$:
;	main.c:55: EchoMode();
;	main.c:56: break;
;	main.c:57: case ECHO_COUNT_MODE:
	ljmp	_EchoMode
00111$:
;	main.c:58: EchoCountMode();
;	main.c:59: break;
;	main.c:60: case SMARTCARD_MODE:
	ljmp	_EchoCountMode
00112$:
;	main.c:61: SmartcardMode();
;	main.c:63: }
	ljmp	_SmartcardMode
00114$:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'EchoMode'
;------------------------------------------------------------
;x                         Allocated to registers r6 
;------------------------------------------------------------
;	main.c:67: void EchoMode() {
;	-----------------------------------------
;	 function EchoMode
;	-----------------------------------------
_EchoMode:
;	main.c:70: while(!PacketAvailable(HOST));
00101$:
	mov	dpl,#0x00
	lcall	_PacketAvailable
	mov	a,dpl
	jz	00101$
;	main.c:71: x = GetRxCount(HOST);
	mov	dpl,#0x00
	lcall	_GetRxCount
	mov	r6,dpl
;	main.c:72: SendPacket(HOST, ID_DEBUG, GetRx(HOST), x);
	mov	dpl,#0x00
	push	ar6
	lcall	_GetRx
	mov	_SendPacket_PARM_3,dpl
	mov	(_SendPacket_PARM_3 + 1),dph
	pop	ar6
	mov	_SendPacket_PARM_4,r6
	mov	(_SendPacket_PARM_4 + 1),#0x00
	mov	_SendPacket_PARM_2,#0xE1
	mov	dpl,#0x00
	lcall	_SendPacket
;	main.c:73: ResetRx(HOST);            
	mov	dpl,#0x00
	lcall	_ResetRx
	sjmp	00101$
;------------------------------------------------------------
;Allocation info for local variables in function 'EchoCountMode'
;------------------------------------------------------------
;s                         Allocated to registers r6 r7 
;------------------------------------------------------------
;	main.c:77: void EchoCountMode() {
;	-----------------------------------------
;	 function EchoCountMode
;	-----------------------------------------
_EchoCountMode:
;	main.c:79: while(1) {
00107$:
;	main.c:80: s = 0;
	mov	r6,#0x00
	mov	r7,#0x00
;	main.c:81: while(!PacketAvailable(HOST)) {
00103$:
	mov	dpl,#0x00
	push	ar7
	push	ar6
	lcall	_PacketAvailable
	mov	a,dpl
	pop	ar6
	pop	ar7
;	main.c:82: if(GetRxCount(HOST) == BUFSIZE-1) {
	jnz	00105$
	mov	dpl,a
	push	ar7
	push	ar6
	lcall	_GetRxCount
	mov	r4,dpl
	mov	r5,dph
	pop	ar6
	pop	ar7
	cjne	r4,#0xFF,00103$
	cjne	r5,#0x00,00103$
;	main.c:83: s += GetRxCount(HOST);
	mov	dpl,#0x00
	push	ar7
	push	ar6
	lcall	_GetRxCount
	mov	r4,dpl
	mov	r5,dph
	pop	ar6
	pop	ar7
	mov	a,r4
	add	a,r6
	mov	r6,a
	mov	a,r5
	addc	a,r7
	mov	r7,a
;	main.c:84: ResetRx(HOST);
	mov	dpl,#0x00
	push	ar7
	push	ar6
	lcall	_ResetRx
	pop	ar6
	pop	ar7
	sjmp	00103$
00105$:
;	main.c:88: s += GetRxCount(HOST);
	mov	dpl,#0x00
	push	ar7
	push	ar6
	lcall	_GetRxCount
	mov	r4,dpl
	mov	r5,dph
	pop	ar6
	pop	ar7
	mov	a,r4
	add	a,r6
	mov	r6,a
	mov	a,r5
	addc	a,r7
	mov	r7,a
;	main.c:89: TX_BUF[0] = (s >> 8) & 0xFF;
	push	ar7
	push	ar6
	lcall	_GetTxBuf
	pop	ar6
	pop	ar7
	mov	ar5,r7
	mov	a,r5
	movx	@dptr,a
;	main.c:90: TX_BUF[1] = s & 0xFF;
	push	ar7
	push	ar6
	lcall	_GetTxBuf
	mov	a,dpl
	mov	b,dph
	pop	ar6
	pop	ar7
	add	a,#0x01
	mov	dpl,a
	clr	a
	addc	a,b
	mov	dph,a
	mov	a,r6
	movx	@dptr,a
;	main.c:91: SendPacket(HOST, ID_DEBUG, TX_BUF, 2); 
	lcall	_GetTxBuf
	mov	_SendPacket_PARM_3,dpl
	mov	(_SendPacket_PARM_3 + 1),dph
	mov	_SendPacket_PARM_2,#0xE1
	mov	_SendPacket_PARM_4,#0x02
	mov	(_SendPacket_PARM_4 + 1),#0x00
	mov	dpl,#0x00
	lcall	_SendPacket
;	main.c:92: ResetRx(HOST);            
	mov	dpl,#0x00
	lcall	_ResetRx
	ljmp	00107$
;------------------------------------------------------------
;Allocation info for local variables in function 'SmartcardMode'
;------------------------------------------------------------
;	main.c:97: void SmartcardMode() {
;	-----------------------------------------
;	 function SmartcardMode
;	-----------------------------------------
_SmartcardMode:
;	main.c:98: IsoInit();
	lcall	_IsoInit
;	main.c:100: while(1) {
00104$:
;	main.c:101: if(PacketAvailable(PICC)) {
	mov	dpl,#0x01
	lcall	_PacketAvailable
	mov	a,dpl
	jz	00104$
;	main.c:102: IsoProcessPcd();
	lcall	_IsoProcessPcd
;	main.c:104: SendDebug(D_PACKET_PROCESSED);
	mov	dpl,#0x0B
	lcall	_SendDebug
	sjmp	00104$
	.area CSEG    (CODE)
	.area CONST   (CODE)
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
