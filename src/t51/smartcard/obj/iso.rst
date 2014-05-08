                              1 ;--------------------------------------------------------
                              2 ; File Created by SDCC : free open source ANSI-C Compiler
                              3 ; Version 3.3.0 #8604 (Sep  2 2013) (Linux)
                              4 ; This file was generated Thu May  8 18:45:16 2014
                              5 ;--------------------------------------------------------
                              6 	.module iso
                              7 	.optsdcc -mmcs51 --model-small
                              8 	
                              9 ;--------------------------------------------------------
                             10 ; Public variables in this module
                             11 ;--------------------------------------------------------
                             12 	.globl _memcpy
                             13 	.globl _ComputeCrc
                             14 	.globl _SendDebug
                             15 	.globl _PacketAvailable
                             16 	.globl _GetRxCount
                             17 	.globl _ResetRx
                             18 	.globl _GetTxBuf
                             19 	.globl _GetRx
                             20 	.globl _SendPacket
                             21 	.globl _TF2
                             22 	.globl _EXF2
                             23 	.globl _RCLK
                             24 	.globl _TCLK
                             25 	.globl _EXEN2
                             26 	.globl _TR2
                             27 	.globl _C_T2
                             28 	.globl _CP_RL2
                             29 	.globl _T2CON_7
                             30 	.globl _T2CON_6
                             31 	.globl _T2CON_5
                             32 	.globl _T2CON_4
                             33 	.globl _T2CON_3
                             34 	.globl _T2CON_2
                             35 	.globl _T2CON_1
                             36 	.globl _T2CON_0
                             37 	.globl _PT2
                             38 	.globl _ET2
                             39 	.globl _CY
                             40 	.globl _AC
                             41 	.globl _F0
                             42 	.globl _RS1
                             43 	.globl _RS0
                             44 	.globl _OV
                             45 	.globl _F1
                             46 	.globl _P
                             47 	.globl _PS
                             48 	.globl _PT1
                             49 	.globl _PX1
                             50 	.globl _PT0
                             51 	.globl _PX0
                             52 	.globl _RD
                             53 	.globl _WR
                             54 	.globl _T1
                             55 	.globl _T0
                             56 	.globl _INT1
                             57 	.globl _INT0
                             58 	.globl _TXD
                             59 	.globl _RXD
                             60 	.globl _P3_7
                             61 	.globl _P3_6
                             62 	.globl _P3_5
                             63 	.globl _P3_4
                             64 	.globl _P3_3
                             65 	.globl _P3_2
                             66 	.globl _P3_1
                             67 	.globl _P3_0
                             68 	.globl _EA
                             69 	.globl _ES
                             70 	.globl _ET1
                             71 	.globl _EX1
                             72 	.globl _ET0
                             73 	.globl _EX0
                             74 	.globl _P2_7
                             75 	.globl _P2_6
                             76 	.globl _P2_5
                             77 	.globl _P2_4
                             78 	.globl _P2_3
                             79 	.globl _P2_2
                             80 	.globl _P2_1
                             81 	.globl _P2_0
                             82 	.globl _SM0
                             83 	.globl _SM1
                             84 	.globl _SM2
                             85 	.globl _REN
                             86 	.globl _TB8
                             87 	.globl _RB8
                             88 	.globl _TI
                             89 	.globl _RI
                             90 	.globl _P1_7
                             91 	.globl _P1_6
                             92 	.globl _P1_5
                             93 	.globl _P1_4
                             94 	.globl _P1_3
                             95 	.globl _P1_2
                             96 	.globl _P1_1
                             97 	.globl _P1_0
                             98 	.globl _TF1
                             99 	.globl _TR1
                            100 	.globl _TF0
                            101 	.globl _TR0
                            102 	.globl _IE1
                            103 	.globl _IT1
                            104 	.globl _IE0
                            105 	.globl _IT0
                            106 	.globl _P0_7
                            107 	.globl _P0_6
                            108 	.globl _P0_5
                            109 	.globl _P0_4
                            110 	.globl _P0_3
                            111 	.globl _P0_2
                            112 	.globl _P0_1
                            113 	.globl _P0_0
                            114 	.globl _TH2
                            115 	.globl _TL2
                            116 	.globl _RCAP2H
                            117 	.globl _RCAP2L
                            118 	.globl _T2CON
                            119 	.globl _B
                            120 	.globl _ACC
                            121 	.globl _PSW
                            122 	.globl _IP
                            123 	.globl _P3
                            124 	.globl _IE
                            125 	.globl _P2
                            126 	.globl _SBUF
                            127 	.globl _SCON
                            128 	.globl _P1
                            129 	.globl _TH1
                            130 	.globl _TH0
                            131 	.globl _TL1
                            132 	.globl _TL0
                            133 	.globl _TMOD
                            134 	.globl _TCON
                            135 	.globl _PCON
                            136 	.globl _DPH
                            137 	.globl _DPL
                            138 	.globl _SP
                            139 	.globl _P0
                            140 	.globl _apduBuf
                            141 	.globl _piccRx
                            142 	.globl _hostRx
                            143 	.globl _IsoInit
                            144 	.globl _IsoProcessPcd
                            145 ;--------------------------------------------------------
                            146 ; special function registers
                            147 ;--------------------------------------------------------
                            148 	.area RSEG    (ABS,DATA)
   0000                     149 	.org 0x0000
                     0080   150 _P0	=	0x0080
                     0081   151 _SP	=	0x0081
                     0082   152 _DPL	=	0x0082
                     0083   153 _DPH	=	0x0083
                     0087   154 _PCON	=	0x0087
                     0088   155 _TCON	=	0x0088
                     0089   156 _TMOD	=	0x0089
                     008A   157 _TL0	=	0x008a
                     008B   158 _TL1	=	0x008b
                     008C   159 _TH0	=	0x008c
                     008D   160 _TH1	=	0x008d
                     0090   161 _P1	=	0x0090
                     0098   162 _SCON	=	0x0098
                     0099   163 _SBUF	=	0x0099
                     00A0   164 _P2	=	0x00a0
                     00A8   165 _IE	=	0x00a8
                     00B0   166 _P3	=	0x00b0
                     00B8   167 _IP	=	0x00b8
                     00D0   168 _PSW	=	0x00d0
                     00E0   169 _ACC	=	0x00e0
                     00F0   170 _B	=	0x00f0
                     00C8   171 _T2CON	=	0x00c8
                     00CA   172 _RCAP2L	=	0x00ca
                     00CB   173 _RCAP2H	=	0x00cb
                     00CC   174 _TL2	=	0x00cc
                     00CD   175 _TH2	=	0x00cd
                            176 ;--------------------------------------------------------
                            177 ; special function bits
                            178 ;--------------------------------------------------------
                            179 	.area RSEG    (ABS,DATA)
   0000                     180 	.org 0x0000
                     0080   181 _P0_0	=	0x0080
                     0081   182 _P0_1	=	0x0081
                     0082   183 _P0_2	=	0x0082
                     0083   184 _P0_3	=	0x0083
                     0084   185 _P0_4	=	0x0084
                     0085   186 _P0_5	=	0x0085
                     0086   187 _P0_6	=	0x0086
                     0087   188 _P0_7	=	0x0087
                     0088   189 _IT0	=	0x0088
                     0089   190 _IE0	=	0x0089
                     008A   191 _IT1	=	0x008a
                     008B   192 _IE1	=	0x008b
                     008C   193 _TR0	=	0x008c
                     008D   194 _TF0	=	0x008d
                     008E   195 _TR1	=	0x008e
                     008F   196 _TF1	=	0x008f
                     0090   197 _P1_0	=	0x0090
                     0091   198 _P1_1	=	0x0091
                     0092   199 _P1_2	=	0x0092
                     0093   200 _P1_3	=	0x0093
                     0094   201 _P1_4	=	0x0094
                     0095   202 _P1_5	=	0x0095
                     0096   203 _P1_6	=	0x0096
                     0097   204 _P1_7	=	0x0097
                     0098   205 _RI	=	0x0098
                     0099   206 _TI	=	0x0099
                     009A   207 _RB8	=	0x009a
                     009B   208 _TB8	=	0x009b
                     009C   209 _REN	=	0x009c
                     009D   210 _SM2	=	0x009d
                     009E   211 _SM1	=	0x009e
                     009F   212 _SM0	=	0x009f
                     00A0   213 _P2_0	=	0x00a0
                     00A1   214 _P2_1	=	0x00a1
                     00A2   215 _P2_2	=	0x00a2
                     00A3   216 _P2_3	=	0x00a3
                     00A4   217 _P2_4	=	0x00a4
                     00A5   218 _P2_5	=	0x00a5
                     00A6   219 _P2_6	=	0x00a6
                     00A7   220 _P2_7	=	0x00a7
                     00A8   221 _EX0	=	0x00a8
                     00A9   222 _ET0	=	0x00a9
                     00AA   223 _EX1	=	0x00aa
                     00AB   224 _ET1	=	0x00ab
                     00AC   225 _ES	=	0x00ac
                     00AF   226 _EA	=	0x00af
                     00B0   227 _P3_0	=	0x00b0
                     00B1   228 _P3_1	=	0x00b1
                     00B2   229 _P3_2	=	0x00b2
                     00B3   230 _P3_3	=	0x00b3
                     00B4   231 _P3_4	=	0x00b4
                     00B5   232 _P3_5	=	0x00b5
                     00B6   233 _P3_6	=	0x00b6
                     00B7   234 _P3_7	=	0x00b7
                     00B0   235 _RXD	=	0x00b0
                     00B1   236 _TXD	=	0x00b1
                     00B2   237 _INT0	=	0x00b2
                     00B3   238 _INT1	=	0x00b3
                     00B4   239 _T0	=	0x00b4
                     00B5   240 _T1	=	0x00b5
                     00B6   241 _WR	=	0x00b6
                     00B7   242 _RD	=	0x00b7
                     00B8   243 _PX0	=	0x00b8
                     00B9   244 _PT0	=	0x00b9
                     00BA   245 _PX1	=	0x00ba
                     00BB   246 _PT1	=	0x00bb
                     00BC   247 _PS	=	0x00bc
                     00D0   248 _P	=	0x00d0
                     00D1   249 _F1	=	0x00d1
                     00D2   250 _OV	=	0x00d2
                     00D3   251 _RS0	=	0x00d3
                     00D4   252 _RS1	=	0x00d4
                     00D5   253 _F0	=	0x00d5
                     00D6   254 _AC	=	0x00d6
                     00D7   255 _CY	=	0x00d7
                     00AD   256 _ET2	=	0x00ad
                     00BD   257 _PT2	=	0x00bd
                     00C8   258 _T2CON_0	=	0x00c8
                     00C9   259 _T2CON_1	=	0x00c9
                     00CA   260 _T2CON_2	=	0x00ca
                     00CB   261 _T2CON_3	=	0x00cb
                     00CC   262 _T2CON_4	=	0x00cc
                     00CD   263 _T2CON_5	=	0x00cd
                     00CE   264 _T2CON_6	=	0x00ce
                     00CF   265 _T2CON_7	=	0x00cf
                     00C8   266 _CP_RL2	=	0x00c8
                     00C9   267 _C_T2	=	0x00c9
                     00CA   268 _TR2	=	0x00ca
                     00CB   269 _EXEN2	=	0x00cb
                     00CC   270 _TCLK	=	0x00cc
                     00CD   271 _RCLK	=	0x00cd
                     00CE   272 _EXF2	=	0x00ce
                     00CF   273 _TF2	=	0x00cf
                            274 ;--------------------------------------------------------
                            275 ; overlayable register banks
                            276 ;--------------------------------------------------------
                            277 	.area REG_BANK_0	(REL,OVR,DATA)
   0000                     278 	.ds 8
                            279 ;--------------------------------------------------------
                            280 ; internal ram data
                            281 ;--------------------------------------------------------
                            282 	.area DSEG    (DATA)
   000A                     283 _fsd:
   000A                     284 	.ds 1
   000B                     285 _cid:
   000B                     286 	.ds 1
   000C                     287 _blockNumber:
   000C                     288 	.ds 1
   000D                     289 _lastTxLen:
   000D                     290 	.ds 1
   000E                     291 _iBlockReceived:
   000E                     292 	.ds 1
   000F                     293 _hostRx::
   000F                     294 	.ds 2
   0011                     295 _piccRx::
   0011                     296 	.ds 2
   0013                     297 _ProcessIBlock_apduOffset_1_54:
   0013                     298 	.ds 1
   0014                     299 _ProcessIBlock_sWtx_1_54:
   0014                     300 	.ds 5
   0019                     301 _ProcessIBlock_sloc0_1_0:
   0019                     302 	.ds 3
                            303 ;--------------------------------------------------------
                            304 ; overlayable items in internal ram 
                            305 ;--------------------------------------------------------
                            306 	.area	OSEG    (OVR,DATA)
                            307 ;--------------------------------------------------------
                            308 ; indirectly addressable internal ram data
                            309 ;--------------------------------------------------------
                            310 	.area ISEG    (DATA)
                            311 ;--------------------------------------------------------
                            312 ; absolute internal ram data
                            313 ;--------------------------------------------------------
                            314 	.area IABS    (ABS,DATA)
                            315 	.area IABS    (ABS,DATA)
                            316 ;--------------------------------------------------------
                            317 ; bit data
                            318 ;--------------------------------------------------------
                            319 	.area BSEG    (BIT)
                            320 ;--------------------------------------------------------
                            321 ; paged external ram data
                            322 ;--------------------------------------------------------
                            323 	.area PSEG    (PAG,XDATA)
                            324 ;--------------------------------------------------------
                            325 ; external ram data
                            326 ;--------------------------------------------------------
                            327 	.area XSEG    (XDATA)
   0000                     328 _apduBuf::
   0000                     329 	.ds 256
                            330 ;--------------------------------------------------------
                            331 ; absolute external ram data
                            332 ;--------------------------------------------------------
                            333 	.area XABS    (ABS,XDATA)
                            334 ;--------------------------------------------------------
                            335 ; external initialized ram data
                            336 ;--------------------------------------------------------
                            337 	.area XISEG   (XDATA)
                            338 	.area HOME    (CODE)
                            339 	.area GSINIT0 (CODE)
                            340 	.area GSINIT1 (CODE)
                            341 	.area GSINIT2 (CODE)
                            342 	.area GSINIT3 (CODE)
                            343 	.area GSINIT4 (CODE)
                            344 	.area GSINIT5 (CODE)
                            345 	.area GSINIT  (CODE)
                            346 	.area GSFINAL (CODE)
                            347 	.area CSEG    (CODE)
                            348 ;--------------------------------------------------------
                            349 ; global & static initialisations
                            350 ;--------------------------------------------------------
                            351 	.area HOME    (CODE)
                            352 	.area GSINIT  (CODE)
                            353 	.area GSFINAL (CODE)
                            354 	.area GSINIT  (CODE)
                            355 ;	iso.c:51: static uint8_t blockNumber = 1;
   005F 75 0C 01      [24]  356 	mov	_blockNumber,#0x01
                            357 ;	iso.c:52: static uint8_t lastTxLen = 0;
   0062 75 0D 00      [24]  358 	mov	_lastTxLen,#0x00
                            359 ;--------------------------------------------------------
                            360 ; Home
                            361 ;--------------------------------------------------------
                            362 	.area HOME    (CODE)
                            363 	.area HOME    (CODE)
                            364 ;--------------------------------------------------------
                            365 ; code
                            366 ;--------------------------------------------------------
                            367 	.area CSEG    (CODE)
                            368 ;------------------------------------------------------------
                            369 ;Allocation info for local variables in function 'ResetWtx'
                            370 ;------------------------------------------------------------
                            371 ;wtx                       Allocated to registers r5 r6 r7 
                            372 ;------------------------------------------------------------
                            373 ;	iso.c:70: static void ResetWtx(WtxContext * wtx) {
                            374 ;	-----------------------------------------
                            375 ;	 function ResetWtx
                            376 ;	-----------------------------------------
   0264                     377 _ResetWtx:
                     0007   378 	ar7 = 0x07
                     0006   379 	ar6 = 0x06
                     0005   380 	ar5 = 0x05
                     0004   381 	ar4 = 0x04
                     0003   382 	ar3 = 0x03
                     0002   383 	ar2 = 0x02
                     0001   384 	ar1 = 0x01
                     0000   385 	ar0 = 0x00
                            386 ;	iso.c:71: wtx->spinCount = SWTX_INTERVAL;
   0264 74 B0         [12]  387 	mov	a,#0xB0
   0266 12 0B F4      [24]  388 	lcall	__gptrput
   0269 A3            [24]  389 	inc	dptr
   026A 74 04         [12]  390 	mov	a,#0x04
   026C 12 0B F4      [24]  391 	lcall	__gptrput
   026F A3            [24]  392 	inc	dptr
   0270 E4            [12]  393 	clr	a
   0271 12 0B F4      [24]  394 	lcall	__gptrput
   0274 A3            [24]  395 	inc	dptr
   0275 E4            [12]  396 	clr	a
   0276 02 0B F4      [24]  397 	ljmp	__gptrput
                            398 ;------------------------------------------------------------
                            399 ;Allocation info for local variables in function 'SendSwtx'
                            400 ;------------------------------------------------------------
                            401 ;	iso.c:74: static void SendSwtx(void) {
                            402 ;	-----------------------------------------
                            403 ;	 function SendSwtx
                            404 ;	-----------------------------------------
   0279                     405 _SendSwtx:
                            406 ;	iso.c:75: TX_BUF[0] = WTX_REQUEST;
   0279 12 0A 4F      [24]  407 	lcall	_GetTxBuf
   027C 74 F2         [12]  408 	mov	a,#0xF2
   027E F0            [24]  409 	movx	@dptr,a
                            410 ;	iso.c:76: TX_BUF[1] = 10;
   027F 12 0A 4F      [24]  411 	lcall	_GetTxBuf
   0282 E5 82         [12]  412 	mov	a,dpl
   0284 85 83 F0      [24]  413 	mov	b,dph
   0287 24 01         [12]  414 	add	a,#0x01
   0289 F5 82         [12]  415 	mov	dpl,a
   028B E4            [12]  416 	clr	a
   028C 35 F0         [12]  417 	addc	a,b
   028E F5 83         [12]  418 	mov	dph,a
   0290 74 0A         [12]  419 	mov	a,#0x0A
   0292 F0            [24]  420 	movx	@dptr,a
                            421 ;	iso.c:77: ComputeCrc(TX_BUF, 2);
   0293 12 0A 4F      [24]  422 	lcall	_GetTxBuf
   0296 AE 82         [24]  423 	mov	r6,dpl
   0298 AF 83         [24]  424 	mov	r7,dph
   029A 7D 00         [12]  425 	mov	r5,#0x00
   029C 75 1C 02      [24]  426 	mov	_ComputeCrc_PARM_2,#0x02
   029F 75 1D 00      [24]  427 	mov	(_ComputeCrc_PARM_2 + 1),#0x00
   02A2 8E 82         [24]  428 	mov	dpl,r6
   02A4 8F 83         [24]  429 	mov	dph,r7
   02A6 8D F0         [24]  430 	mov	b,r5
   02A8 12 09 C4      [24]  431 	lcall	_ComputeCrc
                            432 ;	iso.c:78: SendPacket(PICC, 0, TX_BUF, 4);
   02AB 12 0A 4F      [24]  433 	lcall	_GetTxBuf
   02AE 85 82 22      [24]  434 	mov	_SendPacket_PARM_3,dpl
   02B1 85 83 23      [24]  435 	mov	(_SendPacket_PARM_3 + 1),dph
   02B4 75 21 00      [24]  436 	mov	_SendPacket_PARM_2,#0x00
   02B7 75 24 04      [24]  437 	mov	_SendPacket_PARM_4,#0x04
   02BA 75 25 00      [24]  438 	mov	(_SendPacket_PARM_4 + 1),#0x00
   02BD 75 82 01      [24]  439 	mov	dpl,#0x01
   02C0 02 0A C5      [24]  440 	ljmp	_SendPacket
                            441 ;------------------------------------------------------------
                            442 ;Allocation info for local variables in function 'HandleWtx'
                            443 ;------------------------------------------------------------
                            444 ;wtx                       Allocated to registers r5 r6 r7 
                            445 ;------------------------------------------------------------
                            446 ;	iso.c:82: static int8_t HandleWtx(WtxContext * wtx) {
                            447 ;	-----------------------------------------
                            448 ;	 function HandleWtx
                            449 ;	-----------------------------------------
   02C3                     450 _HandleWtx:
                            451 ;	iso.c:84: if(wtx->spinCount == 0 && !wtx->missingAcks) {
   02C3 AD 82         [24]  452 	mov	r5,dpl
   02C5 AE 83         [24]  453 	mov	r6,dph
   02C7 AF F0         [24]  454 	mov	r7,b
   02C9 12 0C 0F      [24]  455 	lcall	__gptrget
   02CC F9            [12]  456 	mov	r1,a
   02CD A3            [24]  457 	inc	dptr
   02CE 12 0C 0F      [24]  458 	lcall	__gptrget
   02D1 FA            [12]  459 	mov	r2,a
   02D2 A3            [24]  460 	inc	dptr
   02D3 12 0C 0F      [24]  461 	lcall	__gptrget
   02D6 FB            [12]  462 	mov	r3,a
   02D7 A3            [24]  463 	inc	dptr
   02D8 12 0C 0F      [24]  464 	lcall	__gptrget
   02DB FC            [12]  465 	mov	r4,a
   02DC E9            [12]  466 	mov	a,r1
   02DD 4A            [12]  467 	orl	a,r2
   02DE 4B            [12]  468 	orl	a,r3
   02DF 4C            [12]  469 	orl	a,r4
   02E0 70 5F         [24]  470 	jnz	00102$
   02E2 74 04         [12]  471 	mov	a,#0x04
   02E4 2D            [12]  472 	add	a,r5
   02E5 FA            [12]  473 	mov	r2,a
   02E6 E4            [12]  474 	clr	a
   02E7 3E            [12]  475 	addc	a,r6
   02E8 FB            [12]  476 	mov	r3,a
   02E9 8F 04         [24]  477 	mov	ar4,r7
   02EB 8A 82         [24]  478 	mov	dpl,r2
   02ED 8B 83         [24]  479 	mov	dph,r3
   02EF 8C F0         [24]  480 	mov	b,r4
   02F1 12 0C 0F      [24]  481 	lcall	__gptrget
   02F4 70 4B         [24]  482 	jnz	00102$
                            483 ;	iso.c:85: SendSwtx();
   02F6 C0 07         [24]  484 	push	ar7
   02F8 C0 06         [24]  485 	push	ar6
   02FA C0 05         [24]  486 	push	ar5
   02FC C0 04         [24]  487 	push	ar4
   02FE C0 03         [24]  488 	push	ar3
   0300 C0 02         [24]  489 	push	ar2
   0302 12 02 79      [24]  490 	lcall	_SendSwtx
   0305 D0 02         [24]  491 	pop	ar2
   0307 D0 03         [24]  492 	pop	ar3
   0309 D0 04         [24]  493 	pop	ar4
   030B D0 05         [24]  494 	pop	ar5
   030D D0 06         [24]  495 	pop	ar6
   030F D0 07         [24]  496 	pop	ar7
                            497 ;	iso.c:86: ++(wtx->missingAcks);
   0311 8A 82         [24]  498 	mov	dpl,r2
   0313 8B 83         [24]  499 	mov	dph,r3
   0315 8C F0         [24]  500 	mov	b,r4
   0317 12 0C 0F      [24]  501 	lcall	__gptrget
   031A F9            [12]  502 	mov	r1,a
   031B 09            [12]  503 	inc	r1
   031C 8A 82         [24]  504 	mov	dpl,r2
   031E 8B 83         [24]  505 	mov	dph,r3
   0320 8C F0         [24]  506 	mov	b,r4
   0322 E9            [12]  507 	mov	a,r1
   0323 12 0B F4      [24]  508 	lcall	__gptrput
                            509 ;	iso.c:87: wtx->spinCount = SWTX_INTERVAL;
   0326 8D 82         [24]  510 	mov	dpl,r5
   0328 8E 83         [24]  511 	mov	dph,r6
   032A 8F F0         [24]  512 	mov	b,r7
   032C 74 B0         [12]  513 	mov	a,#0xB0
   032E 12 0B F4      [24]  514 	lcall	__gptrput
   0331 A3            [24]  515 	inc	dptr
   0332 74 04         [12]  516 	mov	a,#0x04
   0334 12 0B F4      [24]  517 	lcall	__gptrput
   0337 A3            [24]  518 	inc	dptr
   0338 E4            [12]  519 	clr	a
   0339 12 0B F4      [24]  520 	lcall	__gptrput
   033C A3            [24]  521 	inc	dptr
   033D E4            [12]  522 	clr	a
   033E 12 0B F4      [24]  523 	lcall	__gptrput
   0341                     524 00102$:
                            525 ;	iso.c:89: --(wtx->spinCount);
   0341 8D 82         [24]  526 	mov	dpl,r5
   0343 8E 83         [24]  527 	mov	dph,r6
   0345 8F F0         [24]  528 	mov	b,r7
   0347 12 0C 0F      [24]  529 	lcall	__gptrget
   034A F9            [12]  530 	mov	r1,a
   034B A3            [24]  531 	inc	dptr
   034C 12 0C 0F      [24]  532 	lcall	__gptrget
   034F FA            [12]  533 	mov	r2,a
   0350 A3            [24]  534 	inc	dptr
   0351 12 0C 0F      [24]  535 	lcall	__gptrget
   0354 FB            [12]  536 	mov	r3,a
   0355 A3            [24]  537 	inc	dptr
   0356 12 0C 0F      [24]  538 	lcall	__gptrget
   0359 FC            [12]  539 	mov	r4,a
   035A 19            [12]  540 	dec	r1
   035B B9 FF 09      [24]  541 	cjne	r1,#0xFF,00124$
   035E 1A            [12]  542 	dec	r2
   035F BA FF 05      [24]  543 	cjne	r2,#0xFF,00124$
   0362 1B            [12]  544 	dec	r3
   0363 BB FF 01      [24]  545 	cjne	r3,#0xFF,00124$
   0366 1C            [12]  546 	dec	r4
   0367                     547 00124$:
   0367 8D 82         [24]  548 	mov	dpl,r5
   0369 8E 83         [24]  549 	mov	dph,r6
   036B 8F F0         [24]  550 	mov	b,r7
   036D E9            [12]  551 	mov	a,r1
   036E 12 0B F4      [24]  552 	lcall	__gptrput
   0371 A3            [24]  553 	inc	dptr
   0372 EA            [12]  554 	mov	a,r2
   0373 12 0B F4      [24]  555 	lcall	__gptrput
   0376 A3            [24]  556 	inc	dptr
   0377 EB            [12]  557 	mov	a,r3
   0378 12 0B F4      [24]  558 	lcall	__gptrput
   037B A3            [24]  559 	inc	dptr
   037C EC            [12]  560 	mov	a,r4
   037D 12 0B F4      [24]  561 	lcall	__gptrput
                            562 ;	iso.c:91: if(PacketAvailable(PICC)) {
   0380 75 82 01      [24]  563 	mov	dpl,#0x01
   0383 C0 07         [24]  564 	push	ar7
   0385 C0 06         [24]  565 	push	ar6
   0387 C0 05         [24]  566 	push	ar5
   0389 12 0A 9E      [24]  567 	lcall	_PacketAvailable
   038C E5 82         [12]  568 	mov	a,dpl
   038E D0 05         [24]  569 	pop	ar5
   0390 D0 06         [24]  570 	pop	ar6
   0392 D0 07         [24]  571 	pop	ar7
   0394 60 47         [24]  572 	jz	00107$
                            573 ;	iso.c:92: if(piccRx[0] != WTX_RESPONSE) {
   0396 85 11 82      [24]  574 	mov	dpl,_piccRx
   0399 85 12 83      [24]  575 	mov	dph,(_piccRx + 1)
   039C E0            [24]  576 	movx	a,@dptr
   039D FC            [12]  577 	mov	r4,a
   039E BC F2 02      [24]  578 	cjne	r4,#0xF2,00126$
   03A1 80 04         [24]  579 	sjmp	00105$
   03A3                     580 00126$:
                            581 ;	iso.c:93: return -1;
   03A3 75 82 FF      [24]  582 	mov	dpl,#0xFF
   03A6 22            [24]  583 	ret
   03A7                     584 00105$:
                            585 ;	iso.c:95: --(wtx->missingAcks);
   03A7 74 04         [12]  586 	mov	a,#0x04
   03A9 2D            [12]  587 	add	a,r5
   03AA FA            [12]  588 	mov	r2,a
   03AB E4            [12]  589 	clr	a
   03AC 3E            [12]  590 	addc	a,r6
   03AD FB            [12]  591 	mov	r3,a
   03AE 8F 04         [24]  592 	mov	ar4,r7
   03B0 8A 82         [24]  593 	mov	dpl,r2
   03B2 8B 83         [24]  594 	mov	dph,r3
   03B4 8C F0         [24]  595 	mov	b,r4
   03B6 12 0C 0F      [24]  596 	lcall	__gptrget
   03B9 F9            [12]  597 	mov	r1,a
   03BA 19            [12]  598 	dec	r1
   03BB 8A 82         [24]  599 	mov	dpl,r2
   03BD 8B 83         [24]  600 	mov	dph,r3
   03BF 8C F0         [24]  601 	mov	b,r4
   03C1 E9            [12]  602 	mov	a,r1
   03C2 12 0B F4      [24]  603 	lcall	__gptrput
                            604 ;	iso.c:96: SendDebug(D_WTX_ACK);
   03C5 75 82 0F      [24]  605 	mov	dpl,#0x0F
   03C8 C0 07         [24]  606 	push	ar7
   03CA C0 06         [24]  607 	push	ar6
   03CC C0 05         [24]  608 	push	ar5
   03CE 12 0B 41      [24]  609 	lcall	_SendDebug
                            610 ;	iso.c:98: ResetRx(PICC);
   03D1 75 82 01      [24]  611 	mov	dpl,#0x01
   03D4 12 0A 53      [24]  612 	lcall	_ResetRx
   03D7 D0 05         [24]  613 	pop	ar5
   03D9 D0 06         [24]  614 	pop	ar6
   03DB D0 07         [24]  615 	pop	ar7
   03DD                     616 00107$:
                            617 ;	iso.c:100: return wtx->missingAcks;
   03DD 74 04         [12]  618 	mov	a,#0x04
   03DF 2D            [12]  619 	add	a,r5
   03E0 FD            [12]  620 	mov	r5,a
   03E1 E4            [12]  621 	clr	a
   03E2 3E            [12]  622 	addc	a,r6
   03E3 FE            [12]  623 	mov	r6,a
   03E4 8D 82         [24]  624 	mov	dpl,r5
   03E6 8E 83         [24]  625 	mov	dph,r6
   03E8 8F F0         [24]  626 	mov	b,r7
   03EA 12 0C 0F      [24]  627 	lcall	__gptrget
   03ED F5 82         [12]  628 	mov	dpl,a
   03EF 22            [24]  629 	ret
                            630 ;------------------------------------------------------------
                            631 ;Allocation info for local variables in function 'IsoInit'
                            632 ;------------------------------------------------------------
                            633 ;	iso.c:106: void IsoInit() {
                            634 ;	-----------------------------------------
                            635 ;	 function IsoInit
                            636 ;	-----------------------------------------
   03F0                     637 _IsoInit:
                            638 ;	iso.c:107: piccRx = GetRx(PICC);
   03F0 75 82 01      [24]  639 	mov	dpl,#0x01
   03F3 12 0A 37      [24]  640 	lcall	_GetRx
   03F6 85 82 11      [24]  641 	mov	_piccRx,dpl
   03F9 85 83 12      [24]  642 	mov	(_piccRx + 1),dph
                            643 ;	iso.c:108: hostRx = GetRx(HOST);
   03FC 75 82 00      [24]  644 	mov	dpl,#0x00
   03FF 12 0A 37      [24]  645 	lcall	_GetRx
   0402 85 82 0F      [24]  646 	mov	_hostRx,dpl
   0405 85 83 10      [24]  647 	mov	(_hostRx + 1),dph
                            648 ;	iso.c:109: iBlockReceived = 0;
   0408 75 0E 00      [24]  649 	mov	_iBlockReceived,#0x00
   040B 22            [24]  650 	ret
                            651 ;------------------------------------------------------------
                            652 ;Allocation info for local variables in function 'IsoProcessPcd'
                            653 ;------------------------------------------------------------
                            654 ;rxLen                     Allocated to registers 
                            655 ;------------------------------------------------------------
                            656 ;	iso.c:112: void IsoProcessPcd(void) {
                            657 ;	-----------------------------------------
                            658 ;	 function IsoProcessPcd
                            659 ;	-----------------------------------------
   040C                     660 _IsoProcessPcd:
                            661 ;	iso.c:113: uint8_t rxLen = GetRxCount(PICC);
   040C 75 82 01      [24]  662 	mov	dpl,#0x01
   040F 12 0A 76      [24]  663 	lcall	_GetRxCount
                            664 ;	iso.c:117: switch(piccRx[0] & BLOCK_MASK) {
   0412 85 11 82      [24]  665 	mov	dpl,_piccRx
   0415 85 12 83      [24]  666 	mov	dph,(_piccRx + 1)
   0418 E0            [24]  667 	movx	a,@dptr
   0419 FF            [12]  668 	mov	r7,a
   041A 53 07 E0      [24]  669 	anl	ar7,#0xE0
   041D BF 00 02      [24]  670 	cjne	r7,#0x00,00122$
   0420 80 0A         [24]  671 	sjmp	00101$
   0422                     672 00122$:
   0422 BF A0 02      [24]  673 	cjne	r7,#0xA0,00123$
   0425 80 08         [24]  674 	sjmp	00102$
   0427                     675 00123$:
                            676 ;	iso.c:118: case I_BLOCK:
   0427 BF C0 0B      [24]  677 	cjne	r7,#0xC0,00104$
   042A 80 06         [24]  678 	sjmp	00103$
   042C                     679 00101$:
                            680 ;	iso.c:119: ProcessIBlock();
                            681 ;	iso.c:120: break;
                            682 ;	iso.c:122: case R_BLOCK:
   042C 02 05 69      [24]  683 	ljmp	_ProcessIBlock
   042F                     684 00102$:
                            685 ;	iso.c:123: ProcessRBlock();
                            686 ;	iso.c:124: break;
                            687 ;	iso.c:126: case S_BLOCK:
   042F 02 08 82      [24]  688 	ljmp	_ProcessRBlock
   0432                     689 00103$:
                            690 ;	iso.c:127: ProcessSBlock();
                            691 ;	iso.c:128: break;
                            692 ;	iso.c:130: default:
   0432 02 08 EB      [24]  693 	ljmp	_ProcessSBlock
   0435                     694 00104$:
                            695 ;	iso.c:131: switch(piccRx[0]) {
   0435 85 11 82      [24]  696 	mov	dpl,_piccRx
   0438 85 12 83      [24]  697 	mov	dph,(_piccRx + 1)
   043B E0            [24]  698 	movx	a,@dptr
   043C FF            [12]  699 	mov	r7,a
   043D BF E0 2D      [24]  700 	cjne	r7,#0xE0,00106$
                            701 ;	iso.c:133: blockNumber = 1;
   0440 75 0C 01      [24]  702 	mov	_blockNumber,#0x01
                            703 ;	iso.c:134: fsd = DECODE_FSDI(piccRx[1] >> 4);
   0443 85 11 82      [24]  704 	mov	dpl,_piccRx
   0446 85 12 83      [24]  705 	mov	dph,(_piccRx + 1)
   0449 A3            [24]  706 	inc	dptr
   044A E0            [24]  707 	movx	a,@dptr
   044B FF            [12]  708 	mov	r7,a
   044C C4            [12]  709 	swap	a
   044D 54 0F         [12]  710 	anl	a,#0x0F
   044F 75 F0 02      [24]  711 	mov	b,#0x02
   0452 A4            [48]  712 	mul	ab
   0453 24 2F         [12]  713 	add	a,#_fsdTable
   0455 F5 82         [12]  714 	mov	dpl,a
   0457 74 0C         [12]  715 	mov	a,#(_fsdTable >> 8)
   0459 35 F0         [12]  716 	addc	a,b
   045B F5 83         [12]  717 	mov	dph,a
   045D E4            [12]  718 	clr	a
   045E 93            [24]  719 	movc	a,@a+dptr
   045F FD            [12]  720 	mov	r5,a
   0460 A3            [24]  721 	inc	dptr
   0461 E4            [12]  722 	clr	a
   0462 93            [24]  723 	movc	a,@a+dptr
   0463 8D 0A         [24]  724 	mov	_fsd,r5
                            725 ;	iso.c:135: cid = piccRx[1] & 0x0F;
   0465 74 0F         [12]  726 	mov	a,#0x0F
   0467 5F            [12]  727 	anl	a,r7
   0468 F5 0B         [12]  728 	mov	_cid,a
                            729 ;	iso.c:136: SendAts();
   046A 12 04 73      [24]  730 	lcall	_SendAts
                            731 ;	iso.c:138: }
   046D                     732 00106$:
                            733 ;	iso.c:139: ResetRx(PICC);
   046D 75 82 01      [24]  734 	mov	dpl,#0x01
                            735 ;	iso.c:141: }
   0470 02 0A 53      [24]  736 	ljmp	_ResetRx
                            737 ;------------------------------------------------------------
                            738 ;Allocation info for local variables in function 'SendAts'
                            739 ;------------------------------------------------------------
                            740 ;__00010001                Allocated to registers r6 r7 
                            741 ;__00010002                Allocated to registers r6 r7 
                            742 ;------------------------------------------------------------
                            743 ;	iso.c:149: static void SendAts(void) {
                            744 ;	-----------------------------------------
                            745 ;	 function SendAts
                            746 ;	-----------------------------------------
   0473                     747 _SendAts:
                            748 ;	iso.c:150: TX_BUF[0] = 1;
   0473 12 0A 4F      [24]  749 	lcall	_GetTxBuf
   0476 74 01         [12]  750 	mov	a,#0x01
   0478 F0            [24]  751 	movx	@dptr,a
                            752 ;	iso.c:151: memcpy(TX_BUF+TX_BUF[0], ats, sizeof(ats));
   0479 12 0A 4F      [24]  753 	lcall	_GetTxBuf
   047C AE 82         [24]  754 	mov	r6,dpl
   047E AF 83         [24]  755 	mov	r7,dph
   0480 C0 07         [24]  756 	push	ar7
   0482 C0 06         [24]  757 	push	ar6
   0484 12 0A 4F      [24]  758 	lcall	_GetTxBuf
   0487 D0 06         [24]  759 	pop	ar6
   0489 D0 07         [24]  760 	pop	ar7
   048B E0            [24]  761 	movx	a,@dptr
   048C 2E            [12]  762 	add	a,r6
   048D FE            [12]  763 	mov	r6,a
   048E E4            [12]  764 	clr	a
   048F 3F            [12]  765 	addc	a,r7
   0490 FF            [12]  766 	mov	r7,a
   0491 7D 00         [12]  767 	mov	r5,#0x00
   0493 75 21 41      [24]  768 	mov	_memcpy_PARM_2,#_ats
   0496 75 22 0C      [24]  769 	mov	(_memcpy_PARM_2 + 1),#(_ats >> 8)
   0499 75 23 80      [24]  770 	mov	(_memcpy_PARM_2 + 2),#0x80
   049C 75 24 04      [24]  771 	mov	_memcpy_PARM_3,#0x04
   049F 75 25 00      [24]  772 	mov	(_memcpy_PARM_3 + 1),#0x00
   04A2 8E 82         [24]  773 	mov	dpl,r6
   04A4 8F 83         [24]  774 	mov	dph,r7
   04A6 8D F0         [24]  775 	mov	b,r5
   04A8 12 0B 9F      [24]  776 	lcall	_memcpy
                            777 ;	iso.c:152: TX_BUF[3] = 0xa0; // override default fwi
   04AB 12 0A 4F      [24]  778 	lcall	_GetTxBuf
   04AE E5 82         [12]  779 	mov	a,dpl
   04B0 85 83 F0      [24]  780 	mov	b,dph
   04B3 24 03         [12]  781 	add	a,#0x03
   04B5 F5 82         [12]  782 	mov	dpl,a
   04B7 E4            [12]  783 	clr	a
   04B8 35 F0         [12]  784 	addc	a,b
   04BA F5 83         [12]  785 	mov	dph,a
   04BC 74 A0         [12]  786 	mov	a,#0xA0
   04BE F0            [24]  787 	movx	@dptr,a
                            788 ;	iso.c:153: TX_BUF[0] += sizeof(ats);
   04BF 12 0A 4F      [24]  789 	lcall	_GetTxBuf
   04C2 AE 82         [24]  790 	mov	r6,dpl
   04C4 AF 83         [24]  791 	mov  r7,dph
   04C6 E0            [24]  792 	movx	a,@dptr
   04C7 24 04         [12]  793 	add	a,#0x04
   04C9 8E 82         [24]  794 	mov	dpl,r6
   04CB 8F 83         [24]  795 	mov	dph,r7
   04CD F0            [24]  796 	movx	@dptr,a
                            797 ;	iso.c:154: memcpy(TX_BUF+TX_BUF[0], historical, sizeof(historical));
   04CE 12 0A 4F      [24]  798 	lcall	_GetTxBuf
   04D1 AE 82         [24]  799 	mov	r6,dpl
   04D3 AF 83         [24]  800 	mov	r7,dph
   04D5 C0 07         [24]  801 	push	ar7
   04D7 C0 06         [24]  802 	push	ar6
   04D9 12 0A 4F      [24]  803 	lcall	_GetTxBuf
   04DC D0 06         [24]  804 	pop	ar6
   04DE D0 07         [24]  805 	pop	ar7
   04E0 E0            [24]  806 	movx	a,@dptr
   04E1 2E            [12]  807 	add	a,r6
   04E2 FE            [12]  808 	mov	r6,a
   04E3 E4            [12]  809 	clr	a
   04E4 3F            [12]  810 	addc	a,r7
   04E5 FF            [12]  811 	mov	r7,a
   04E6 7D 00         [12]  812 	mov	r5,#0x00
   04E8 75 21 45      [24]  813 	mov	_memcpy_PARM_2,#_historical
   04EB 75 22 0C      [24]  814 	mov	(_memcpy_PARM_2 + 1),#(_historical >> 8)
   04EE 75 23 80      [24]  815 	mov	(_memcpy_PARM_2 + 2),#0x80
   04F1 75 24 0F      [24]  816 	mov	_memcpy_PARM_3,#0x0F
   04F4 75 25 00      [24]  817 	mov	(_memcpy_PARM_3 + 1),#0x00
   04F7 8E 82         [24]  818 	mov	dpl,r6
   04F9 8F 83         [24]  819 	mov	dph,r7
   04FB 8D F0         [24]  820 	mov	b,r5
   04FD 12 0B 9F      [24]  821 	lcall	_memcpy
                            822 ;	iso.c:155: TX_BUF[0] += sizeof(historical);
   0500 12 0A 4F      [24]  823 	lcall	_GetTxBuf
   0503 AE 82         [24]  824 	mov	r6,dpl
   0505 AF 83         [24]  825 	mov  r7,dph
   0507 E0            [24]  826 	movx	a,@dptr
   0508 24 0F         [12]  827 	add	a,#0x0F
   050A 8E 82         [24]  828 	mov	dpl,r6
   050C 8F 83         [24]  829 	mov	dph,r7
   050E F0            [24]  830 	movx	@dptr,a
                            831 ;	iso.c:156: ComputeCrc(TX_BUF, TX_BUF[0]);
   050F 12 0A 4F      [24]  832 	lcall	_GetTxBuf
   0512 AE 82         [24]  833 	mov	r6,dpl
   0514 AF 83         [24]  834 	mov	r7,dph
   0516 7D 00         [12]  835 	mov	r5,#0x00
   0518 C0 07         [24]  836 	push	ar7
   051A C0 06         [24]  837 	push	ar6
   051C C0 05         [24]  838 	push	ar5
   051E 12 0A 4F      [24]  839 	lcall	_GetTxBuf
   0521 D0 05         [24]  840 	pop	ar5
   0523 D0 06         [24]  841 	pop	ar6
   0525 D0 07         [24]  842 	pop	ar7
   0527 E0            [24]  843 	movx	a,@dptr
   0528 FC            [12]  844 	mov	r4,a
   0529 8C 1C         [24]  845 	mov	_ComputeCrc_PARM_2,r4
   052B 75 1D 00      [24]  846 	mov	(_ComputeCrc_PARM_2 + 1),#0x00
   052E 8E 82         [24]  847 	mov	dpl,r6
   0530 8F 83         [24]  848 	mov	dph,r7
   0532 8D F0         [24]  849 	mov	b,r5
   0534 12 09 C4      [24]  850 	lcall	_ComputeCrc
                            851 ;	iso.c:157: SendPacket(PICC, 0, TX_BUF, TX_BUF[0]+2);
   0537 12 0A 4F      [24]  852 	lcall	_GetTxBuf
   053A AE 82         [24]  853 	mov	r6,dpl
   053C AF 83         [24]  854 	mov	r7,dph
   053E C0 07         [24]  855 	push	ar7
   0540 C0 06         [24]  856 	push	ar6
   0542 12 0A 4F      [24]  857 	lcall	_GetTxBuf
   0545 D0 06         [24]  858 	pop	ar6
   0547 D0 07         [24]  859 	pop	ar7
   0549 E0            [24]  860 	movx	a,@dptr
   054A FD            [12]  861 	mov	r5,a
   054B 7C 00         [12]  862 	mov	r4,#0x00
   054D 74 02         [12]  863 	mov	a,#0x02
   054F 2D            [12]  864 	add	a,r5
   0550 F5 24         [12]  865 	mov	_SendPacket_PARM_4,a
   0552 E4            [12]  866 	clr	a
   0553 3C            [12]  867 	addc	a,r4
   0554 F5 25         [12]  868 	mov	(_SendPacket_PARM_4 + 1),a
   0556 75 21 00      [24]  869 	mov	_SendPacket_PARM_2,#0x00
   0559 8E 22         [24]  870 	mov	_SendPacket_PARM_3,r6
   055B 8F 23         [24]  871 	mov	(_SendPacket_PARM_3 + 1),r7
   055D 75 82 01      [24]  872 	mov	dpl,#0x01
   0560 12 0A C5      [24]  873 	lcall	_SendPacket
                            874 ;	iso.c:159: SendDebug(D_ISO_L4_ACTIVATED); 
   0563 75 82 09      [24]  875 	mov	dpl,#0x09
   0566 02 0B 41      [24]  876 	ljmp	_SendDebug
                            877 ;------------------------------------------------------------
                            878 ;Allocation info for local variables in function 'ProcessIBlock'
                            879 ;------------------------------------------------------------
                            880 ;apduOffset                Allocated with name '_ProcessIBlock_apduOffset_1_54'
                            881 ;needSwtxAck               Allocated to registers 
                            882 ;responseComplete          Allocated to registers 
                            883 ;pcb                       Allocated to registers r6 
                            884 ;cid                       Allocated to registers 
                            885 ;sWtx                      Allocated with name '_ProcessIBlock_sWtx_1_54'
                            886 ;sloc0                     Allocated with name '_ProcessIBlock_sloc0_1_0'
                            887 ;------------------------------------------------------------
                            888 ;	iso.c:162: static void ProcessIBlock() {    
                            889 ;	-----------------------------------------
                            890 ;	 function ProcessIBlock
                            891 ;	-----------------------------------------
   0569                     892 _ProcessIBlock:
                            893 ;	iso.c:163: uint8_t apduOffset = 1;
   0569 75 13 01      [24]  894 	mov	_ProcessIBlock_apduOffset_1_54,#0x01
                            895 ;	iso.c:166: uint8_t pcb = piccRx[0];
   056C 85 11 82      [24]  896 	mov	dpl,_piccRx
   056F 85 12 83      [24]  897 	mov	dph,(_piccRx + 1)
   0572 E0            [24]  898 	movx	a,@dptr
   0573 FE            [12]  899 	mov	r6,a
                            900 ;	iso.c:169: iBlockReceived = 1;
   0574 75 0E 01      [24]  901 	mov	_iBlockReceived,#0x01
                            902 ;	iso.c:170: blockNumber ^= 1;
   0577 63 0C 01      [24]  903 	xrl	_blockNumber,#0x01
                            904 ;	iso.c:175: if(pcb & NAD_FOLLOWING) ++apduOffset;
   057A EE            [12]  905 	mov	a,r6
   057B 30 E2 03      [24]  906 	jnb	acc.2,00102$
   057E 75 13 02      [24]  907 	mov	_ProcessIBlock_apduOffset_1_54,#0x02
   0581                     908 00102$:
                            909 ;	iso.c:176: ResetRx(HOST);
   0581 75 82 00      [24]  910 	mov	dpl,#0x00
   0584 12 0A 53      [24]  911 	lcall	_ResetRx
                            912 ;	iso.c:179: SendPacket(HOST, ID_APDU_DOWN, piccRx+apduOffset, GetRxCount(PICC)-apduOffset-2);
   0587 E5 13         [12]  913 	mov	a,_ProcessIBlock_apduOffset_1_54
   0589 25 11         [12]  914 	add	a,_piccRx
   058B FD            [12]  915 	mov	r5,a
   058C E4            [12]  916 	clr	a
   058D 35 12         [12]  917 	addc	a,(_piccRx + 1)
   058F FE            [12]  918 	mov	r6,a
   0590 75 82 01      [24]  919 	mov	dpl,#0x01
   0593 C0 06         [24]  920 	push	ar6
   0595 C0 05         [24]  921 	push	ar5
   0597 12 0A 76      [24]  922 	lcall	_GetRxCount
   059A AB 82         [24]  923 	mov	r3,dpl
   059C AC 83         [24]  924 	mov	r4,dph
   059E D0 05         [24]  925 	pop	ar5
   05A0 D0 06         [24]  926 	pop	ar6
   05A2 A9 13         [24]  927 	mov	r1,_ProcessIBlock_apduOffset_1_54
   05A4 7A 00         [12]  928 	mov	r2,#0x00
   05A6 EB            [12]  929 	mov	a,r3
   05A7 C3            [12]  930 	clr	c
   05A8 99            [12]  931 	subb	a,r1
   05A9 FB            [12]  932 	mov	r3,a
   05AA EC            [12]  933 	mov	a,r4
   05AB 9A            [12]  934 	subb	a,r2
   05AC FC            [12]  935 	mov	r4,a
   05AD EB            [12]  936 	mov	a,r3
   05AE 24 FE         [12]  937 	add	a,#0xFE
   05B0 F5 24         [12]  938 	mov	_SendPacket_PARM_4,a
   05B2 EC            [12]  939 	mov	a,r4
   05B3 34 FF         [12]  940 	addc	a,#0xFF
   05B5 F5 25         [12]  941 	mov	(_SendPacket_PARM_4 + 1),a
   05B7 75 21 21      [24]  942 	mov	_SendPacket_PARM_2,#0x21
   05BA 8D 22         [24]  943 	mov	_SendPacket_PARM_3,r5
   05BC 8E 23         [24]  944 	mov	(_SendPacket_PARM_3 + 1),r6
   05BE 75 82 00      [24]  945 	mov	dpl,#0x00
   05C1 C0 02         [24]  946 	push	ar2
   05C3 C0 01         [24]  947 	push	ar1
   05C5 12 0A C5      [24]  948 	lcall	_SendPacket
                            949 ;	iso.c:181: ResetRx(PICC);
   05C8 75 82 01      [24]  950 	mov	dpl,#0x01
   05CB 12 0A 53      [24]  951 	lcall	_ResetRx
                            952 ;	iso.c:182: ResetWtx(&sWtx);
   05CE 90 00 14      [24]  953 	mov	dptr,#_ProcessIBlock_sWtx_1_54
   05D1 75 F0 40      [24]  954 	mov	b,#0x40
   05D4 12 02 64      [24]  955 	lcall	_ResetWtx
                            956 ;	iso.c:184: SendSwtx();
   05D7 12 02 79      [24]  957 	lcall	_SendSwtx
   05DA D0 01         [24]  958 	pop	ar1
   05DC D0 02         [24]  959 	pop	ar2
                            960 ;	iso.c:185: while(!PacketAvailable(PICC));
   05DE                     961 00103$:
   05DE 75 82 01      [24]  962 	mov	dpl,#0x01
   05E1 C0 02         [24]  963 	push	ar2
   05E3 C0 01         [24]  964 	push	ar1
   05E5 12 0A 9E      [24]  965 	lcall	_PacketAvailable
   05E8 E5 82         [12]  966 	mov	a,dpl
   05EA D0 01         [24]  967 	pop	ar1
   05EC D0 02         [24]  968 	pop	ar2
   05EE 60 EE         [24]  969 	jz	00103$
                            970 ;	iso.c:187: if(piccRx[0] != WTX_RESPONSE) {
   05F0 85 11 82      [24]  971 	mov	dpl,_piccRx
   05F3 85 12 83      [24]  972 	mov	dph,(_piccRx + 1)
   05F6 E0            [24]  973 	movx	a,@dptr
   05F7 FE            [12]  974 	mov	r6,a
   05F8 BE F2 02      [24]  975 	cjne	r6,#0xF2,00161$
   05FB 80 01         [24]  976 	sjmp	00107$
   05FD                     977 00161$:
                            978 ;	iso.c:188: return;
   05FD 22            [24]  979 	ret
   05FE                     980 00107$:
                            981 ;	iso.c:190: SendDebug(D_WTX_ACK);
   05FE 75 82 0F      [24]  982 	mov	dpl,#0x0F
   0601 C0 02         [24]  983 	push	ar2
   0603 C0 01         [24]  984 	push	ar1
   0605 12 0B 41      [24]  985 	lcall	_SendDebug
                            986 ;	iso.c:191: ResetRx(PICC);
   0608 75 82 01      [24]  987 	mov	dpl,#0x01
   060B 12 0A 53      [24]  988 	lcall	_ResetRx
   060E D0 01         [24]  989 	pop	ar1
   0610 D0 02         [24]  990 	pop	ar2
                            991 ;	iso.c:194: while(1) {
   0612                     992 00122$:
                            993 ;	iso.c:202: if(PacketAvailable(HOST)) {  // host sent (last part of) response
   0612 75 82 00      [24]  994 	mov	dpl,#0x00
   0615 C0 02         [24]  995 	push	ar2
   0617 C0 01         [24]  996 	push	ar1
   0619 12 0A 9E      [24]  997 	lcall	_PacketAvailable
   061C E5 82         [12]  998 	mov	a,dpl
   061E D0 01         [24]  999 	pop	ar1
   0620 D0 02         [24] 1000 	pop	ar2
   0622 70 03         [24] 1001 	jnz	00162$
   0624 02 07 18      [24] 1002 	ljmp	00119$
   0627                    1003 00162$:
                           1004 ;	iso.c:203: SendDebug(D_GEN_0);
   0627 75 82 10      [24] 1005 	mov	dpl,#0x10
   062A C0 02         [24] 1006 	push	ar2
   062C C0 01         [24] 1007 	push	ar1
   062E 12 0B 41      [24] 1008 	lcall	_SendDebug
                           1009 ;	iso.c:204: TX_BUF[0] = 0x02 | blockNumber;                      // PCB
   0631 12 0A 4F      [24] 1010 	lcall	_GetTxBuf
   0634 74 02         [12] 1011 	mov	a,#0x02
   0636 45 0C         [12] 1012 	orl	a,_blockNumber
   0638 F0            [24] 1013 	movx	@dptr,a
                           1014 ;	iso.c:205: memcpy(TX_BUF+apduOffset, hostRx, GetRxCount(HOST)); // APDU data
   0639 12 0A 4F      [24] 1015 	lcall	_GetTxBuf
   063C E5 82         [12] 1016 	mov	a,dpl
   063E 85 83 F0      [24] 1017 	mov	b,dph
   0641 D0 01         [24] 1018 	pop	ar1
   0643 D0 02         [24] 1019 	pop	ar2
   0645 25 13         [12] 1020 	add	a,_ProcessIBlock_apduOffset_1_54
   0647 FD            [12] 1021 	mov	r5,a
   0648 E4            [12] 1022 	clr	a
   0649 35 F0         [12] 1023 	addc	a,b
   064B FE            [12] 1024 	mov	r6,a
   064C 8D 19         [24] 1025 	mov	_ProcessIBlock_sloc0_1_0,r5
   064E 8E 1A         [24] 1026 	mov	(_ProcessIBlock_sloc0_1_0 + 1),r6
   0650 75 1B 00      [24] 1027 	mov	(_ProcessIBlock_sloc0_1_0 + 2),#0x00
   0653 A8 0F         [24] 1028 	mov	r0,_hostRx
   0655 AB 10         [24] 1029 	mov	r3,(_hostRx + 1)
   0657 7E 00         [12] 1030 	mov	r6,#0x00
   0659 75 82 00      [24] 1031 	mov	dpl,#0x00
   065C C0 06         [24] 1032 	push	ar6
   065E C0 03         [24] 1033 	push	ar3
   0660 C0 02         [24] 1034 	push	ar2
   0662 C0 01         [24] 1035 	push	ar1
   0664 C0 00         [24] 1036 	push	ar0
   0666 12 0A 76      [24] 1037 	lcall	_GetRxCount
   0669 85 82 24      [24] 1038 	mov	_memcpy_PARM_3,dpl
   066C 85 83 25      [24] 1039 	mov	(_memcpy_PARM_3 + 1),dph
   066F D0 00         [24] 1040 	pop	ar0
   0671 D0 01         [24] 1041 	pop	ar1
   0673 D0 02         [24] 1042 	pop	ar2
   0675 D0 03         [24] 1043 	pop	ar3
   0677 D0 06         [24] 1044 	pop	ar6
   0679 88 21         [24] 1045 	mov	_memcpy_PARM_2,r0
   067B 8B 22         [24] 1046 	mov	(_memcpy_PARM_2 + 1),r3
   067D 8E 23         [24] 1047 	mov	(_memcpy_PARM_2 + 2),r6
   067F 85 19 82      [24] 1048 	mov	dpl,_ProcessIBlock_sloc0_1_0
   0682 85 1A 83      [24] 1049 	mov	dph,(_ProcessIBlock_sloc0_1_0 + 1)
   0685 85 1B F0      [24] 1050 	mov	b,(_ProcessIBlock_sloc0_1_0 + 2)
   0688 C0 02         [24] 1051 	push	ar2
   068A C0 01         [24] 1052 	push	ar1
   068C 12 0B 9F      [24] 1053 	lcall	_memcpy
                           1054 ;	iso.c:206: ComputeCrc(TX_BUF, GetRxCount(HOST)+apduOffset);  // CRC
   068F 12 0A 4F      [24] 1055 	lcall	_GetTxBuf
   0692 AD 82         [24] 1056 	mov	r5,dpl
   0694 AE 83         [24] 1057 	mov	r6,dph
   0696 D0 01         [24] 1058 	pop	ar1
   0698 D0 02         [24] 1059 	pop	ar2
   069A 7C 00         [12] 1060 	mov	r4,#0x00
   069C 75 82 00      [24] 1061 	mov	dpl,#0x00
   069F C0 06         [24] 1062 	push	ar6
   06A1 C0 05         [24] 1063 	push	ar5
   06A3 C0 04         [24] 1064 	push	ar4
   06A5 C0 02         [24] 1065 	push	ar2
   06A7 C0 01         [24] 1066 	push	ar1
   06A9 12 0A 76      [24] 1067 	lcall	_GetRxCount
   06AC E5 82         [12] 1068 	mov	a,dpl
   06AE 85 83 F0      [24] 1069 	mov	b,dph
   06B1 D0 01         [24] 1070 	pop	ar1
   06B3 D0 02         [24] 1071 	pop	ar2
   06B5 D0 04         [24] 1072 	pop	ar4
   06B7 D0 05         [24] 1073 	pop	ar5
   06B9 D0 06         [24] 1074 	pop	ar6
   06BB 29            [12] 1075 	add	a,r1
   06BC F5 1C         [12] 1076 	mov	_ComputeCrc_PARM_2,a
   06BE EA            [12] 1077 	mov	a,r2
   06BF 35 F0         [12] 1078 	addc	a,b
   06C1 F5 1D         [12] 1079 	mov	(_ComputeCrc_PARM_2 + 1),a
   06C3 8D 82         [24] 1080 	mov	dpl,r5
   06C5 8E 83         [24] 1081 	mov	dph,r6
   06C7 8C F0         [24] 1082 	mov	b,r4
   06C9 C0 02         [24] 1083 	push	ar2
   06CB C0 01         [24] 1084 	push	ar1
   06CD 12 09 C4      [24] 1085 	lcall	_ComputeCrc
                           1086 ;	iso.c:208: SendPacket(PICC, 0, TX_BUF, GetRxCount(HOST)+apduOffset+2);
   06D0 12 0A 4F      [24] 1087 	lcall	_GetTxBuf
   06D3 AD 82         [24] 1088 	mov	r5,dpl
   06D5 AE 83         [24] 1089 	mov	r6,dph
   06D7 D0 01         [24] 1090 	pop	ar1
   06D9 D0 02         [24] 1091 	pop	ar2
   06DB 75 82 00      [24] 1092 	mov	dpl,#0x00
   06DE C0 06         [24] 1093 	push	ar6
   06E0 C0 05         [24] 1094 	push	ar5
   06E2 C0 02         [24] 1095 	push	ar2
   06E4 C0 01         [24] 1096 	push	ar1
   06E6 12 0A 76      [24] 1097 	lcall	_GetRxCount
   06E9 E5 82         [12] 1098 	mov	a,dpl
   06EB 85 83 F0      [24] 1099 	mov	b,dph
   06EE D0 01         [24] 1100 	pop	ar1
   06F0 D0 02         [24] 1101 	pop	ar2
   06F2 D0 05         [24] 1102 	pop	ar5
   06F4 D0 06         [24] 1103 	pop	ar6
   06F6 29            [12] 1104 	add	a,r1
   06F7 FB            [12] 1105 	mov	r3,a
   06F8 EA            [12] 1106 	mov	a,r2
   06F9 35 F0         [12] 1107 	addc	a,b
   06FB FC            [12] 1108 	mov	r4,a
   06FC 74 02         [12] 1109 	mov	a,#0x02
   06FE 2B            [12] 1110 	add	a,r3
   06FF F5 24         [12] 1111 	mov	_SendPacket_PARM_4,a
   0701 E4            [12] 1112 	clr	a
   0702 3C            [12] 1113 	addc	a,r4
   0703 F5 25         [12] 1114 	mov	(_SendPacket_PARM_4 + 1),a
   0705 75 21 00      [24] 1115 	mov	_SendPacket_PARM_2,#0x00
   0708 8D 22         [24] 1116 	mov	_SendPacket_PARM_3,r5
   070A 8E 23         [24] 1117 	mov	(_SendPacket_PARM_3 + 1),r6
   070C 75 82 01      [24] 1118 	mov	dpl,#0x01
   070F 12 0A C5      [24] 1119 	lcall	_SendPacket
                           1120 ;	iso.c:209: ResetRx(HOST);
   0712 75 82 00      [24] 1121 	mov	dpl,#0x00
                           1122 ;	iso.c:210: return;
   0715 02 0A 53      [24] 1123 	ljmp	_ResetRx
   0718                    1124 00119$:
                           1125 ;	iso.c:211: } else if(GetRxCount(HOST) == (BUFSIZE-1))  { // host sent part of response
   0718 75 82 00      [24] 1126 	mov	dpl,#0x00
   071B C0 02         [24] 1127 	push	ar2
   071D C0 01         [24] 1128 	push	ar1
   071F 12 0A 76      [24] 1129 	lcall	_GetRxCount
   0722 AD 82         [24] 1130 	mov	r5,dpl
   0724 AE 83         [24] 1131 	mov	r6,dph
   0726 D0 01         [24] 1132 	pop	ar1
   0728 D0 02         [24] 1133 	pop	ar2
   072A BD FF 05      [24] 1134 	cjne	r5,#0xFF,00163$
   072D BE 00 02      [24] 1135 	cjne	r6,#0x00,00163$
   0730 80 03         [24] 1136 	sjmp	00164$
   0732                    1137 00163$:
   0732 02 06 12      [24] 1138 	ljmp	00122$
   0735                    1139 00164$:
                           1140 ;	iso.c:212: TX_BUF[0] = 0x12 | blockNumber; // PCB w/ chaining bit
   0735 C0 02         [24] 1141 	push	ar2
   0737 C0 01         [24] 1142 	push	ar1
   0739 12 0A 4F      [24] 1143 	lcall	_GetTxBuf
   073C 74 12         [12] 1144 	mov	a,#0x12
   073E 45 0C         [12] 1145 	orl	a,_blockNumber
   0740 F0            [24] 1146 	movx	@dptr,a
                           1147 ;	iso.c:213: memcpy(TX_BUF+apduOffset, hostRx, GetRxCount(HOST)); // APDU data
   0741 12 0A 4F      [24] 1148 	lcall	_GetTxBuf
   0744 E5 82         [12] 1149 	mov	a,dpl
   0746 85 83 F0      [24] 1150 	mov	b,dph
   0749 D0 01         [24] 1151 	pop	ar1
   074B D0 02         [24] 1152 	pop	ar2
   074D 25 13         [12] 1153 	add	a,_ProcessIBlock_apduOffset_1_54
   074F FD            [12] 1154 	mov	r5,a
   0750 E4            [12] 1155 	clr	a
   0751 35 F0         [12] 1156 	addc	a,b
   0753 FE            [12] 1157 	mov	r6,a
   0754 7C 00         [12] 1158 	mov	r4,#0x00
   0756 A8 0F         [24] 1159 	mov	r0,_hostRx
   0758 AB 10         [24] 1160 	mov	r3,(_hostRx + 1)
   075A 7F 00         [12] 1161 	mov	r7,#0x00
   075C 75 82 00      [24] 1162 	mov	dpl,#0x00
   075F C0 07         [24] 1163 	push	ar7
   0761 C0 06         [24] 1164 	push	ar6
   0763 C0 05         [24] 1165 	push	ar5
   0765 C0 04         [24] 1166 	push	ar4
   0767 C0 03         [24] 1167 	push	ar3
   0769 C0 02         [24] 1168 	push	ar2
   076B C0 01         [24] 1169 	push	ar1
   076D C0 00         [24] 1170 	push	ar0
   076F 12 0A 76      [24] 1171 	lcall	_GetRxCount
   0772 85 82 24      [24] 1172 	mov	_memcpy_PARM_3,dpl
   0775 85 83 25      [24] 1173 	mov	(_memcpy_PARM_3 + 1),dph
   0778 D0 00         [24] 1174 	pop	ar0
   077A D0 01         [24] 1175 	pop	ar1
   077C D0 02         [24] 1176 	pop	ar2
   077E D0 03         [24] 1177 	pop	ar3
   0780 D0 04         [24] 1178 	pop	ar4
   0782 D0 05         [24] 1179 	pop	ar5
   0784 D0 06         [24] 1180 	pop	ar6
   0786 D0 07         [24] 1181 	pop	ar7
   0788 88 21         [24] 1182 	mov	_memcpy_PARM_2,r0
   078A 8B 22         [24] 1183 	mov	(_memcpy_PARM_2 + 1),r3
   078C 8F 23         [24] 1184 	mov	(_memcpy_PARM_2 + 2),r7
   078E 8D 82         [24] 1185 	mov	dpl,r5
   0790 8E 83         [24] 1186 	mov	dph,r6
   0792 8C F0         [24] 1187 	mov	b,r4
   0794 C0 02         [24] 1188 	push	ar2
   0796 C0 01         [24] 1189 	push	ar1
   0798 12 0B 9F      [24] 1190 	lcall	_memcpy
                           1191 ;	iso.c:214: ComputeCrc(TX_BUF, GetRxCount(HOST)+apduOffset);  // CRC
   079B 12 0A 4F      [24] 1192 	lcall	_GetTxBuf
   079E AE 82         [24] 1193 	mov	r6,dpl
   07A0 AF 83         [24] 1194 	mov	r7,dph
   07A2 D0 01         [24] 1195 	pop	ar1
   07A4 D0 02         [24] 1196 	pop	ar2
   07A6 7D 00         [12] 1197 	mov	r5,#0x00
   07A8 75 82 00      [24] 1198 	mov	dpl,#0x00
   07AB C0 07         [24] 1199 	push	ar7
   07AD C0 06         [24] 1200 	push	ar6
   07AF C0 05         [24] 1201 	push	ar5
   07B1 C0 02         [24] 1202 	push	ar2
   07B3 C0 01         [24] 1203 	push	ar1
   07B5 12 0A 76      [24] 1204 	lcall	_GetRxCount
   07B8 E5 82         [12] 1205 	mov	a,dpl
   07BA 85 83 F0      [24] 1206 	mov	b,dph
   07BD D0 01         [24] 1207 	pop	ar1
   07BF D0 02         [24] 1208 	pop	ar2
   07C1 D0 05         [24] 1209 	pop	ar5
   07C3 D0 06         [24] 1210 	pop	ar6
   07C5 D0 07         [24] 1211 	pop	ar7
   07C7 29            [12] 1212 	add	a,r1
   07C8 F5 1C         [12] 1213 	mov	_ComputeCrc_PARM_2,a
   07CA EA            [12] 1214 	mov	a,r2
   07CB 35 F0         [12] 1215 	addc	a,b
   07CD F5 1D         [12] 1216 	mov	(_ComputeCrc_PARM_2 + 1),a
   07CF 8E 82         [24] 1217 	mov	dpl,r6
   07D1 8F 83         [24] 1218 	mov	dph,r7
   07D3 8D F0         [24] 1219 	mov	b,r5
   07D5 C0 02         [24] 1220 	push	ar2
   07D7 C0 01         [24] 1221 	push	ar1
   07D9 12 09 C4      [24] 1222 	lcall	_ComputeCrc
                           1223 ;	iso.c:215: SendPacket(PICC, 0, TX_BUF, GetRxCount(HOST)+apduOffset+2);
   07DC 12 0A 4F      [24] 1224 	lcall	_GetTxBuf
   07DF AE 82         [24] 1225 	mov	r6,dpl
   07E1 AF 83         [24] 1226 	mov	r7,dph
   07E3 D0 01         [24] 1227 	pop	ar1
   07E5 D0 02         [24] 1228 	pop	ar2
   07E7 75 82 00      [24] 1229 	mov	dpl,#0x00
   07EA C0 07         [24] 1230 	push	ar7
   07EC C0 06         [24] 1231 	push	ar6
   07EE C0 02         [24] 1232 	push	ar2
   07F0 C0 01         [24] 1233 	push	ar1
   07F2 12 0A 76      [24] 1234 	lcall	_GetRxCount
   07F5 E5 82         [12] 1235 	mov	a,dpl
   07F7 85 83 F0      [24] 1236 	mov	b,dph
   07FA D0 01         [24] 1237 	pop	ar1
   07FC D0 02         [24] 1238 	pop	ar2
   07FE D0 06         [24] 1239 	pop	ar6
   0800 D0 07         [24] 1240 	pop	ar7
   0802 29            [12] 1241 	add	a,r1
   0803 FC            [12] 1242 	mov	r4,a
   0804 EA            [12] 1243 	mov	a,r2
   0805 35 F0         [12] 1244 	addc	a,b
   0807 FD            [12] 1245 	mov	r5,a
   0808 74 02         [12] 1246 	mov	a,#0x02
   080A 2C            [12] 1247 	add	a,r4
   080B F5 24         [12] 1248 	mov	_SendPacket_PARM_4,a
   080D E4            [12] 1249 	clr	a
   080E 3D            [12] 1250 	addc	a,r5
   080F F5 25         [12] 1251 	mov	(_SendPacket_PARM_4 + 1),a
   0811 75 21 00      [24] 1252 	mov	_SendPacket_PARM_2,#0x00
   0814 8E 22         [24] 1253 	mov	_SendPacket_PARM_3,r6
   0816 8F 23         [24] 1254 	mov	(_SendPacket_PARM_3 + 1),r7
   0818 75 82 01      [24] 1255 	mov	dpl,#0x01
   081B C0 02         [24] 1256 	push	ar2
   081D C0 01         [24] 1257 	push	ar1
   081F 12 0A C5      [24] 1258 	lcall	_SendPacket
                           1259 ;	iso.c:216: ResetRx(HOST);            
   0822 75 82 00      [24] 1260 	mov	dpl,#0x00
   0825 12 0A 53      [24] 1261 	lcall	_ResetRx
   0828 D0 01         [24] 1262 	pop	ar1
   082A D0 02         [24] 1263 	pop	ar2
                           1264 ;	iso.c:219: while(!PacketAvailable(PICC));
   082C                    1265 00108$:
   082C 75 82 01      [24] 1266 	mov	dpl,#0x01
   082F C0 02         [24] 1267 	push	ar2
   0831 C0 01         [24] 1268 	push	ar1
   0833 12 0A 9E      [24] 1269 	lcall	_PacketAvailable
   0836 E5 82         [12] 1270 	mov	a,dpl
   0838 D0 01         [24] 1271 	pop	ar1
   083A D0 02         [24] 1272 	pop	ar2
   083C 60 EE         [24] 1273 	jz	00108$
                           1274 ;	iso.c:220: if(IS_NAK(piccRx[0])) { 
   083E 85 11 82      [24] 1275 	mov	dpl,_piccRx
   0841 85 12 83      [24] 1276 	mov	dph,(_piccRx + 1)
   0844 E0            [24] 1277 	movx	a,@dptr
   0845 FF            [12] 1278 	mov	r7,a
   0846 53 07 F0      [24] 1279 	anl	ar7,#0xF0
   0849 BF B0 06      [24] 1280 	cjne	r7,#0xB0,00114$
                           1281 ;	iso.c:221: SendDebug(D_NAK_RECEIVED);
   084C 75 82 0D      [24] 1282 	mov	dpl,#0x0D
                           1283 ;	iso.c:222: return;
   084F 02 0B 41      [24] 1284 	ljmp	_SendDebug
   0852                    1285 00114$:
                           1286 ;	iso.c:223: } else if(IS_ACK(piccRx[0])) {
   0852 85 11 82      [24] 1287 	mov	dpl,_piccRx
   0855 85 12 83      [24] 1288 	mov	dph,(_piccRx + 1)
   0858 E0            [24] 1289 	movx	a,@dptr
   0859 FF            [12] 1290 	mov	r7,a
   085A 53 07 F0      [24] 1291 	anl	ar7,#0xF0
   085D BF A0 0E      [24] 1292 	cjne	r7,#0xA0,00115$
                           1293 ;	iso.c:224: SendDebug(D_ACK_RECEIVED);
   0860 75 82 0C      [24] 1294 	mov	dpl,#0x0C
   0863 C0 02         [24] 1295 	push	ar2
   0865 C0 01         [24] 1296 	push	ar1
   0867 12 0B 41      [24] 1297 	lcall	_SendDebug
   086A D0 01         [24] 1298 	pop	ar1
   086C D0 02         [24] 1299 	pop	ar2
   086E                    1300 00115$:
                           1301 ;	iso.c:226: ResetRx(PICC); 
   086E 75 82 01      [24] 1302 	mov	dpl,#0x01
   0871 C0 02         [24] 1303 	push	ar2
   0873 C0 01         [24] 1304 	push	ar1
   0875 12 0A 53      [24] 1305 	lcall	_ResetRx
   0878 D0 01         [24] 1306 	pop	ar1
   087A D0 02         [24] 1307 	pop	ar2
                           1308 ;	iso.c:227: blockNumber ^= 1;
   087C 63 0C 01      [24] 1309 	xrl	_blockNumber,#0x01
   087F 02 06 12      [24] 1310 	ljmp	00122$
                           1311 ;------------------------------------------------------------
                           1312 ;Allocation info for local variables in function 'ProcessRBlock'
                           1313 ;------------------------------------------------------------
                           1314 ;	iso.c:240: static void ProcessRBlock() {
                           1315 ;	-----------------------------------------
                           1316 ;	 function ProcessRBlock
                           1317 ;	-----------------------------------------
   0882                    1318 _ProcessRBlock:
                           1319 ;	iso.c:241: if(piccRx[0] & R_NAK) {
   0882 85 11 82      [24] 1320 	mov	dpl,_piccRx
   0885 85 12 83      [24] 1321 	mov	dph,(_piccRx + 1)
   0888 E0            [24] 1322 	movx	a,@dptr
   0889 FF            [12] 1323 	mov	r7,a
   088A 30 E4 52      [24] 1324 	jnb	acc.4,00106$
                           1325 ;	iso.c:242: SendDebug(D_NAK_RECEIVED);
   088D 75 82 0D      [24] 1326 	mov	dpl,#0x0D
   0890 12 0B 41      [24] 1327 	lcall	_SendDebug
                           1328 ;	iso.c:244: if((piccRx[0] & 1) == blockNumber) {
   0893 85 11 82      [24] 1329 	mov	dpl,_piccRx
   0896 85 12 83      [24] 1330 	mov	dph,(_piccRx + 1)
   0899 E0            [24] 1331 	movx	a,@dptr
   089A 54 01         [12] 1332 	anl	a,#0x01
   089C FF            [12] 1333 	mov	r7,a
   089D B5 0C 07      [24] 1334 	cjne	a,_blockNumber,00104$
                           1335 ;	iso.c:245: if(iBlockReceived == 0) blockNumber ^= 1;
   08A0 E5 0E         [12] 1336 	mov	a,_iBlockReceived
   08A2 70 03         [24] 1337 	jnz	00104$
   08A4 63 0C 01      [24] 1338 	xrl	_blockNumber,#0x01
   08A7                    1339 00104$:
                           1340 ;	iso.c:252: TX_BUF[0] = 0xA3;
   08A7 12 0A 4F      [24] 1341 	lcall	_GetTxBuf
   08AA 74 A3         [12] 1342 	mov	a,#0xA3
   08AC F0            [24] 1343 	movx	@dptr,a
                           1344 ;	iso.c:253: ComputeCrc(TX_BUF, 1);
   08AD 12 0A 4F      [24] 1345 	lcall	_GetTxBuf
   08B0 AE 82         [24] 1346 	mov	r6,dpl
   08B2 AF 83         [24] 1347 	mov	r7,dph
   08B4 7D 00         [12] 1348 	mov	r5,#0x00
   08B6 75 1C 01      [24] 1349 	mov	_ComputeCrc_PARM_2,#0x01
   08B9 75 1D 00      [24] 1350 	mov	(_ComputeCrc_PARM_2 + 1),#0x00
   08BC 8E 82         [24] 1351 	mov	dpl,r6
   08BE 8F 83         [24] 1352 	mov	dph,r7
   08C0 8D F0         [24] 1353 	mov	b,r5
   08C2 12 09 C4      [24] 1354 	lcall	_ComputeCrc
                           1355 ;	iso.c:254: SendPacket(PICC, 0, TX_BUF, 3);
   08C5 12 0A 4F      [24] 1356 	lcall	_GetTxBuf
   08C8 85 82 22      [24] 1357 	mov	_SendPacket_PARM_3,dpl
   08CB 85 83 23      [24] 1358 	mov	(_SendPacket_PARM_3 + 1),dph
   08CE 75 21 00      [24] 1359 	mov	_SendPacket_PARM_2,#0x00
   08D1 75 24 03      [24] 1360 	mov	_SendPacket_PARM_4,#0x03
   08D4 75 25 00      [24] 1361 	mov	(_SendPacket_PARM_4 + 1),#0x00
   08D7 75 82 01      [24] 1362 	mov	dpl,#0x01
   08DA 12 0A C5      [24] 1363 	lcall	_SendPacket
   08DD 80 06         [24] 1364 	sjmp	00107$
   08DF                    1365 00106$:
                           1366 ;	iso.c:256: SendDebug(D_ACK_RECEIVED);
   08DF 75 82 0C      [24] 1367 	mov	dpl,#0x0C
   08E2 12 0B 41      [24] 1368 	lcall	_SendDebug
   08E5                    1369 00107$:
                           1370 ;	iso.c:258: ResetRx(PICC);
   08E5 75 82 01      [24] 1371 	mov	dpl,#0x01
   08E8 02 0A 53      [24] 1372 	ljmp	_ResetRx
                           1373 ;------------------------------------------------------------
                           1374 ;Allocation info for local variables in function 'ProcessSBlock'
                           1375 ;------------------------------------------------------------
                           1376 ;	iso.c:261: static void ProcessSBlock() { 
                           1377 ;	-----------------------------------------
                           1378 ;	 function ProcessSBlock
                           1379 ;	-----------------------------------------
   08EB                    1380 _ProcessSBlock:
                           1381 ;	iso.c:263: switch(piccRx[0]) {
   08EB 85 11 82      [24] 1382 	mov	dpl,_piccRx
   08EE 85 12 83      [24] 1383 	mov	dph,(_piccRx + 1)
   08F1 E0            [24] 1384 	movx	a,@dptr
   08F2 FF            [12] 1385 	mov	r7,a
   08F3 BF C2 02      [24] 1386 	cjne	r7,#0xC2,00114$
   08F6 80 0F         [24] 1387 	sjmp	00102$
   08F8                    1388 00114$:
   08F8 BF CA 18      [24] 1389 	cjne	r7,#0xCA,00105$
                           1390 ;	iso.c:265: if(piccRx[1] == cid) {
   08FB 85 11 82      [24] 1391 	mov	dpl,_piccRx
   08FE 85 12 83      [24] 1392 	mov	dph,(_piccRx + 1)
   0901 A3            [24] 1393 	inc	dptr
   0902 E0            [24] 1394 	movx	a,@dptr
   0903 FF            [12] 1395 	mov	r7,a
   0904 B5 0B 0C      [24] 1396 	cjne	a,_cid,00105$
                           1397 ;	iso.c:266: case CMD_DESELECT:
   0907                    1398 00102$:
                           1399 ;	iso.c:267: SendDebug(D_ISO_DESELECT);        
   0907 75 82 0E      [24] 1400 	mov	dpl,#0x0E
   090A 12 0B 41      [24] 1401 	lcall	_SendDebug
                           1402 ;	iso.c:268: SendDeselectResp();            
   090D 12 09 19      [24] 1403 	lcall	_SendDeselectResp
                           1404 ;	iso.c:269: iBlockReceived = 0;
   0910 75 0E 00      [24] 1405 	mov	_iBlockReceived,#0x00
                           1406 ;	iso.c:272: }
   0913                    1407 00105$:
                           1408 ;	iso.c:273: ResetRx(PICC);
   0913 75 82 01      [24] 1409 	mov	dpl,#0x01
   0916 02 0A 53      [24] 1410 	ljmp	_ResetRx
                           1411 ;------------------------------------------------------------
                           1412 ;Allocation info for local variables in function 'SendDeselectResp'
                           1413 ;------------------------------------------------------------
                           1414 ;	iso.c:276: static void SendDeselectResp(void) {
                           1415 ;	-----------------------------------------
                           1416 ;	 function SendDeselectResp
                           1417 ;	-----------------------------------------
   0919                    1418 _SendDeselectResp:
                           1419 ;	iso.c:277: memcpy(TX_BUF,piccRx,3);
   0919 12 0A 4F      [24] 1420 	lcall	_GetTxBuf
   091C AE 82         [24] 1421 	mov	r6,dpl
   091E AF 83         [24] 1422 	mov	r7,dph
   0920 7D 00         [12] 1423 	mov	r5,#0x00
   0922 85 11 21      [24] 1424 	mov	_memcpy_PARM_2,_piccRx
   0925 85 12 22      [24] 1425 	mov	(_memcpy_PARM_2 + 1),(_piccRx + 1)
   0928 75 23 00      [24] 1426 	mov	(_memcpy_PARM_2 + 2),#0x00
   092B 75 24 03      [24] 1427 	mov	_memcpy_PARM_3,#0x03
   092E 75 25 00      [24] 1428 	mov	(_memcpy_PARM_3 + 1),#0x00
   0931 8E 82         [24] 1429 	mov	dpl,r6
   0933 8F 83         [24] 1430 	mov	dph,r7
   0935 8D F0         [24] 1431 	mov	b,r5
   0937 12 0B 9F      [24] 1432 	lcall	_memcpy
                           1433 ;	iso.c:278: SendPacket(PICC, 0, piccRx, 3);
   093A 75 21 00      [24] 1434 	mov	_SendPacket_PARM_2,#0x00
   093D 85 11 22      [24] 1435 	mov	_SendPacket_PARM_3,_piccRx
   0940 85 12 23      [24] 1436 	mov	(_SendPacket_PARM_3 + 1),(_piccRx + 1)
   0943 75 24 03      [24] 1437 	mov	_SendPacket_PARM_4,#0x03
   0946 75 25 00      [24] 1438 	mov	(_SendPacket_PARM_4 + 1),#0x00
   0949 75 82 01      [24] 1439 	mov	dpl,#0x01
   094C 02 0A C5      [24] 1440 	ljmp	_SendPacket
                           1441 	.area CSEG    (CODE)
                           1442 	.area CONST   (CODE)
   0C2F                    1443 _fsdTable:
   0C2F 10 00              1444 	.byte #0x10,#0x00	; 16
   0C31 18 00              1445 	.byte #0x18,#0x00	; 24
   0C33 20 00              1446 	.byte #0x20,#0x00	; 32
   0C35 28 00              1447 	.byte #0x28,#0x00	; 40
   0C37 30 00              1448 	.byte #0x30,#0x00	; 48
   0C39 40 00              1449 	.byte #0x40,#0x00	; 64
   0C3B 60 00              1450 	.byte #0x60,#0x00	; 96
   0C3D 80 00              1451 	.byte #0x80,#0x00	; 128
   0C3F 00 01              1452 	.byte #0x00,#0x01	; 256
   0C41                    1453 _ats:
   0C41 77                 1454 	.db #0x77	; 119	'w'
   0C42 80                 1455 	.db #0x80	; 128
   0C43 70                 1456 	.db #0x70	; 112	'p'
   0C44 00                 1457 	.db #0x00	; 0
   0C45                    1458 _historical:
   0C45 45                 1459 	.db #0x45	; 69	'E'
   0C46 50                 1460 	.db #0x50	; 80	'P'
   0C47 41                 1461 	.db #0x41	; 65	'A'
   0C48 00                 1462 	.db #0x00	; 0
   0C49 00                 1463 	.db #0x00	; 0
   0C4A 00                 1464 	.db #0x00	; 0
   0C4B 00                 1465 	.db #0x00	; 0
   0C4C 61                 1466 	.db #0x61	; 97	'a'
   0C4D 27                 1467 	.db #0x27	; 39
   0C4E 38                 1468 	.db #0x38	; 56	'8'
   0C4F 94                 1469 	.db #0x94	; 148
   0C50 00                 1470 	.db #0x00	; 0
   0C51 00                 1471 	.db #0x00	; 0
   0C52 00                 1472 	.db #0x00	; 0
   0C53 00                 1473 	.db #0x00	; 0
                           1474 	.area XINIT   (CODE)
                           1475 	.area CABS    (ABS,CODE)
