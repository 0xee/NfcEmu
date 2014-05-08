;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.3.0 #8604 (Sep  2 2013) (Linux)
; This file was generated Thu May  8 18:45:16 2014
;--------------------------------------------------------
	.module crc_a
	.optsdcc -mmcs51 --model-small
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _UpdateCrc_PARM_2
	.globl _ComputeCrc_PARM_2
	.globl _UpdateCrc
	.globl _ComputeCrc
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	.area REG_BANK_0	(REL,OVR,DATA)
	.ds 8
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	.area DSEG    (DATA)
_ComputeCrc_PARM_2:
	.ds 2
_ComputeCrc_chBlock_1_6:
	.ds 1
_ComputeCrc_wCrc_1_6:
	.ds 2
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	.area	OSEG    (OVR,DATA)
_UpdateCrc_PARM_2:
	.ds 3
_UpdateCrc_sloc0_1_0:
	.ds 2
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
; global & static initialisations
;--------------------------------------------------------
	.area HOME    (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area GSINIT  (CODE)
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
;Allocation info for local variables in function 'UpdateCrc'
;------------------------------------------------------------
;lpwCrc                    Allocated with name '_UpdateCrc_PARM_2'
;ch                        Allocated to registers r7 
;sloc0                     Allocated with name '_UpdateCrc_sloc0_1_0'
;------------------------------------------------------------
;	crc_a.c:12: uint16_t UpdateCrc(unsigned char ch, uint16_t *lpwCrc)
;	-----------------------------------------
;	 function UpdateCrc
;	-----------------------------------------
_UpdateCrc:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
	mov	r7,dpl
;	crc_a.c:14: ch = (ch^(unsigned char)((*lpwCrc) & 0x00FF));
	mov	r4,_UpdateCrc_PARM_2
	mov	r5,(_UpdateCrc_PARM_2 + 1)
	mov	r6,(_UpdateCrc_PARM_2 + 2)
	mov	dpl,r4
	mov	dph,r5
	mov	b,r6
	lcall	__gptrget
	mov	r2,a
	inc	dptr
	lcall	__gptrget
	mov	r3,a
	mov	ar0,r2
	mov	a,r0
	xrl	ar7,a
;	crc_a.c:15: ch = (ch^(ch<<4));
	mov	a,r7
	swap	a
	anl	a,#0xF0
	xrl	ar7,a
;	crc_a.c:16: *lpwCrc = (*lpwCrc >> 8)^((uint16_t)ch << 8)^((uint16_t)ch<<3)^((uint16_t)ch>>4);
	mov	_UpdateCrc_sloc0_1_0,r3
	mov	(_UpdateCrc_sloc0_1_0 + 1),#0x00
	mov	ar1,r7
	mov	r7,#0x00
	mov	ar3,r1
	clr	a
	xrl	_UpdateCrc_sloc0_1_0,a
	mov	a,r3
	xrl	(_UpdateCrc_sloc0_1_0 + 1),a
	mov	ar2,r1
	mov	a,r7
	swap	a
	rr	a
	anl	a,#0xF8
	xch	a,r2
	swap	a
	rr	a
	xch	a,r2
	xrl	a,r2
	xch	a,r2
	anl	a,#0xF8
	xch	a,r2
	xrl	a,r2
	mov	r3,a
	mov	a,_UpdateCrc_sloc0_1_0
	xrl	ar2,a
	mov	a,(_UpdateCrc_sloc0_1_0 + 1)
	xrl	ar3,a
	mov	a,r7
	swap	a
	xch	a,r1
	swap	a
	anl	a,#0x0F
	xrl	a,r1
	xch	a,r1
	anl	a,#0x0F
	xch	a,r1
	xrl	a,r1
	xch	a,r1
	mov	r7,a
	mov	a,r1
	xrl	ar2,a
	mov	a,r7
	xrl	ar3,a
	mov	dpl,r4
	mov	dph,r5
	mov	b,r6
	mov	a,r2
	lcall	__gptrput
	inc	dptr
	mov	a,r3
	lcall	__gptrput
;	crc_a.c:17: return(*lpwCrc);
	mov	dpl,r2
	mov	dph,r3
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'ComputeCrc'
;------------------------------------------------------------
;Length                    Allocated with name '_ComputeCrc_PARM_2'
;Data                      Allocated to registers r5 r6 r7 
;chBlock                   Allocated with name '_ComputeCrc_chBlock_1_6'
;wCrc                      Allocated with name '_ComputeCrc_wCrc_1_6'
;------------------------------------------------------------
;	crc_a.c:20: void ComputeCrc(char *Data, int Length) {
;	-----------------------------------------
;	 function ComputeCrc
;	-----------------------------------------
_ComputeCrc:
	mov	r5,dpl
	mov	r6,dph
	mov	r7,b
;	crc_a.c:23: wCrc = 0x6363; /* ITU-V.41 */
	mov	_ComputeCrc_wCrc_1_6,#0x63
	mov	(_ComputeCrc_wCrc_1_6 + 1),#0x63
;	crc_a.c:24: do {
	mov	ar2,r5
	mov	ar3,r6
	mov	ar4,r7
	mov	r0,_ComputeCrc_PARM_2
	mov	r1,(_ComputeCrc_PARM_2 + 1)
00101$:
;	crc_a.c:25: chBlock = *Data++;
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	lcall	__gptrget
	mov	_ComputeCrc_chBlock_1_6,a
	inc	dptr
	mov	r2,dpl
	mov	r3,dph
;	crc_a.c:26: UpdateCrc(chBlock, &wCrc);
	mov	_UpdateCrc_PARM_2,#_ComputeCrc_wCrc_1_6
	mov	(_UpdateCrc_PARM_2 + 1),#0x00
	mov	(_UpdateCrc_PARM_2 + 2),#0x40
	mov	dpl,_ComputeCrc_chBlock_1_6
	push	ar4
	push	ar3
	push	ar2
	push	ar1
	push	ar0
	lcall	_UpdateCrc
	pop	ar0
	pop	ar1
	pop	ar2
	pop	ar3
	pop	ar4
;	crc_a.c:27: } while (--Length);
	dec	r0
	cjne	r0,#0xFF,00113$
	dec	r1
00113$:
	mov	a,r0
	orl	a,r1
;	crc_a.c:29: *Data++ = (BYTE) (wCrc & 0xFF);
	jnz	00101$
	mov	r0,_ComputeCrc_wCrc_1_6
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r0
	lcall	__gptrput
	mov	a,#0x01
	add	a,r2
	mov	r5,a
	clr	a
	addc	a,r3
	mov	r6,a
	mov	ar7,r4
;	crc_a.c:30: *Data++ = (BYTE) ((wCrc >> 8) & 0xFF);
	mov	r4,(_ComputeCrc_wCrc_1_6 + 1)
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	mov	a,r4
;	crc_a.c:31: return;
	ljmp	__gptrput
	.area CSEG    (CODE)
	.area CONST   (CODE)
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
