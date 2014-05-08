                              1 ;--------------------------------------------------------
                              2 ; File Created by SDCC : free open source ANSI-C Compiler
                              3 ; Version 3.3.0 #8604 (Sep  2 2013) (Linux)
                              4 ; This file was generated Thu May  8 18:45:16 2014
                              5 ;--------------------------------------------------------
                              6 	.module T51Interface
                              7 	.optsdcc -mmcs51 --model-small
                              8 	
                              9 ;--------------------------------------------------------
                             10 ; Public variables in this module
                             11 ;--------------------------------------------------------
                             12 	.globl _SendPacket_PARM_4
                             13 	.globl _SendPacket_PARM_3
                             14 	.globl _SendPacket_PARM_2
                             15 	.globl _pPorts
                             16 	.globl _TF2
                             17 	.globl _EXF2
                             18 	.globl _RCLK
                             19 	.globl _TCLK
                             20 	.globl _EXEN2
                             21 	.globl _TR2
                             22 	.globl _C_T2
                             23 	.globl _CP_RL2
                             24 	.globl _T2CON_7
                             25 	.globl _T2CON_6
                             26 	.globl _T2CON_5
                             27 	.globl _T2CON_4
                             28 	.globl _T2CON_3
                             29 	.globl _T2CON_2
                             30 	.globl _T2CON_1
                             31 	.globl _T2CON_0
                             32 	.globl _PT2
                             33 	.globl _ET2
                             34 	.globl _CY
                             35 	.globl _AC
                             36 	.globl _F0
                             37 	.globl _RS1
                             38 	.globl _RS0
                             39 	.globl _OV
                             40 	.globl _F1
                             41 	.globl _P
                             42 	.globl _PS
                             43 	.globl _PT1
                             44 	.globl _PX1
                             45 	.globl _PT0
                             46 	.globl _PX0
                             47 	.globl _RD
                             48 	.globl _WR
                             49 	.globl _T1
                             50 	.globl _T0
                             51 	.globl _INT1
                             52 	.globl _INT0
                             53 	.globl _TXD
                             54 	.globl _RXD
                             55 	.globl _P3_7
                             56 	.globl _P3_6
                             57 	.globl _P3_5
                             58 	.globl _P3_4
                             59 	.globl _P3_3
                             60 	.globl _P3_2
                             61 	.globl _P3_1
                             62 	.globl _P3_0
                             63 	.globl _EA
                             64 	.globl _ES
                             65 	.globl _ET1
                             66 	.globl _EX1
                             67 	.globl _ET0
                             68 	.globl _EX0
                             69 	.globl _P2_7
                             70 	.globl _P2_6
                             71 	.globl _P2_5
                             72 	.globl _P2_4
                             73 	.globl _P2_3
                             74 	.globl _P2_2
                             75 	.globl _P2_1
                             76 	.globl _P2_0
                             77 	.globl _SM0
                             78 	.globl _SM1
                             79 	.globl _SM2
                             80 	.globl _REN
                             81 	.globl _TB8
                             82 	.globl _RB8
                             83 	.globl _TI
                             84 	.globl _RI
                             85 	.globl _P1_7
                             86 	.globl _P1_6
                             87 	.globl _P1_5
                             88 	.globl _P1_4
                             89 	.globl _P1_3
                             90 	.globl _P1_2
                             91 	.globl _P1_1
                             92 	.globl _P1_0
                             93 	.globl _TF1
                             94 	.globl _TR1
                             95 	.globl _TF0
                             96 	.globl _TR0
                             97 	.globl _IE1
                             98 	.globl _IT1
                             99 	.globl _IE0
                            100 	.globl _IT0
                            101 	.globl _P0_7
                            102 	.globl _P0_6
                            103 	.globl _P0_5
                            104 	.globl _P0_4
                            105 	.globl _P0_3
                            106 	.globl _P0_2
                            107 	.globl _P0_1
                            108 	.globl _P0_0
                            109 	.globl _TH2
                            110 	.globl _TL2
                            111 	.globl _RCAP2H
                            112 	.globl _RCAP2L
                            113 	.globl _T2CON
                            114 	.globl _B
                            115 	.globl _ACC
                            116 	.globl _PSW
                            117 	.globl _IP
                            118 	.globl _P3
                            119 	.globl _IE
                            120 	.globl _P2
                            121 	.globl _SBUF
                            122 	.globl _SCON
                            123 	.globl _P1
                            124 	.globl _TH1
                            125 	.globl _TH0
                            126 	.globl _TL1
                            127 	.globl _TL0
                            128 	.globl _TMOD
                            129 	.globl _TCON
                            130 	.globl _PCON
                            131 	.globl _DPH
                            132 	.globl _DPL
                            133 	.globl _SP
                            134 	.globl _P0
                            135 	.globl _txBuf
                            136 	.globl _GetRx
                            137 	.globl _GetTxBuf
                            138 	.globl _ResetRx
                            139 	.globl _GetRxCount
                            140 	.globl _PacketAvailable
                            141 	.globl _SendPacket
                            142 	.globl _SendDebug
                            143 	.globl _IfInit
                            144 ;--------------------------------------------------------
                            145 ; special function registers
                            146 ;--------------------------------------------------------
                            147 	.area RSEG    (ABS,DATA)
   0000                     148 	.org 0x0000
                     0080   149 _P0	=	0x0080
                     0081   150 _SP	=	0x0081
                     0082   151 _DPL	=	0x0082
                     0083   152 _DPH	=	0x0083
                     0087   153 _PCON	=	0x0087
                     0088   154 _TCON	=	0x0088
                     0089   155 _TMOD	=	0x0089
                     008A   156 _TL0	=	0x008a
                     008B   157 _TL1	=	0x008b
                     008C   158 _TH0	=	0x008c
                     008D   159 _TH1	=	0x008d
                     0090   160 _P1	=	0x0090
                     0098   161 _SCON	=	0x0098
                     0099   162 _SBUF	=	0x0099
                     00A0   163 _P2	=	0x00a0
                     00A8   164 _IE	=	0x00a8
                     00B0   165 _P3	=	0x00b0
                     00B8   166 _IP	=	0x00b8
                     00D0   167 _PSW	=	0x00d0
                     00E0   168 _ACC	=	0x00e0
                     00F0   169 _B	=	0x00f0
                     00C8   170 _T2CON	=	0x00c8
                     00CA   171 _RCAP2L	=	0x00ca
                     00CB   172 _RCAP2H	=	0x00cb
                     00CC   173 _TL2	=	0x00cc
                     00CD   174 _TH2	=	0x00cd
                            175 ;--------------------------------------------------------
                            176 ; special function bits
                            177 ;--------------------------------------------------------
                            178 	.area RSEG    (ABS,DATA)
   0000                     179 	.org 0x0000
                     0080   180 _P0_0	=	0x0080
                     0081   181 _P0_1	=	0x0081
                     0082   182 _P0_2	=	0x0082
                     0083   183 _P0_3	=	0x0083
                     0084   184 _P0_4	=	0x0084
                     0085   185 _P0_5	=	0x0085
                     0086   186 _P0_6	=	0x0086
                     0087   187 _P0_7	=	0x0087
                     0088   188 _IT0	=	0x0088
                     0089   189 _IE0	=	0x0089
                     008A   190 _IT1	=	0x008a
                     008B   191 _IE1	=	0x008b
                     008C   192 _TR0	=	0x008c
                     008D   193 _TF0	=	0x008d
                     008E   194 _TR1	=	0x008e
                     008F   195 _TF1	=	0x008f
                     0090   196 _P1_0	=	0x0090
                     0091   197 _P1_1	=	0x0091
                     0092   198 _P1_2	=	0x0092
                     0093   199 _P1_3	=	0x0093
                     0094   200 _P1_4	=	0x0094
                     0095   201 _P1_5	=	0x0095
                     0096   202 _P1_6	=	0x0096
                     0097   203 _P1_7	=	0x0097
                     0098   204 _RI	=	0x0098
                     0099   205 _TI	=	0x0099
                     009A   206 _RB8	=	0x009a
                     009B   207 _TB8	=	0x009b
                     009C   208 _REN	=	0x009c
                     009D   209 _SM2	=	0x009d
                     009E   210 _SM1	=	0x009e
                     009F   211 _SM0	=	0x009f
                     00A0   212 _P2_0	=	0x00a0
                     00A1   213 _P2_1	=	0x00a1
                     00A2   214 _P2_2	=	0x00a2
                     00A3   215 _P2_3	=	0x00a3
                     00A4   216 _P2_4	=	0x00a4
                     00A5   217 _P2_5	=	0x00a5
                     00A6   218 _P2_6	=	0x00a6
                     00A7   219 _P2_7	=	0x00a7
                     00A8   220 _EX0	=	0x00a8
                     00A9   221 _ET0	=	0x00a9
                     00AA   222 _EX1	=	0x00aa
                     00AB   223 _ET1	=	0x00ab
                     00AC   224 _ES	=	0x00ac
                     00AF   225 _EA	=	0x00af
                     00B0   226 _P3_0	=	0x00b0
                     00B1   227 _P3_1	=	0x00b1
                     00B2   228 _P3_2	=	0x00b2
                     00B3   229 _P3_3	=	0x00b3
                     00B4   230 _P3_4	=	0x00b4
                     00B5   231 _P3_5	=	0x00b5
                     00B6   232 _P3_6	=	0x00b6
                     00B7   233 _P3_7	=	0x00b7
                     00B0   234 _RXD	=	0x00b0
                     00B1   235 _TXD	=	0x00b1
                     00B2   236 _INT0	=	0x00b2
                     00B3   237 _INT1	=	0x00b3
                     00B4   238 _T0	=	0x00b4
                     00B5   239 _T1	=	0x00b5
                     00B6   240 _WR	=	0x00b6
                     00B7   241 _RD	=	0x00b7
                     00B8   242 _PX0	=	0x00b8
                     00B9   243 _PT0	=	0x00b9
                     00BA   244 _PX1	=	0x00ba
                     00BB   245 _PT1	=	0x00bb
                     00BC   246 _PS	=	0x00bc
                     00D0   247 _P	=	0x00d0
                     00D1   248 _F1	=	0x00d1
                     00D2   249 _OV	=	0x00d2
                     00D3   250 _RS0	=	0x00d3
                     00D4   251 _RS1	=	0x00d4
                     00D5   252 _F0	=	0x00d5
                     00D6   253 _AC	=	0x00d6
                     00D7   254 _CY	=	0x00d7
                     00AD   255 _ET2	=	0x00ad
                     00BD   256 _PT2	=	0x00bd
                     00C8   257 _T2CON_0	=	0x00c8
                     00C9   258 _T2CON_1	=	0x00c9
                     00CA   259 _T2CON_2	=	0x00ca
                     00CB   260 _T2CON_3	=	0x00cb
                     00CC   261 _T2CON_4	=	0x00cc
                     00CD   262 _T2CON_5	=	0x00cd
                     00CE   263 _T2CON_6	=	0x00ce
                     00CF   264 _T2CON_7	=	0x00cf
                     00C8   265 _CP_RL2	=	0x00c8
                     00C9   266 _C_T2	=	0x00c9
                     00CA   267 _TR2	=	0x00ca
                     00CB   268 _EXEN2	=	0x00cb
                     00CC   269 _TCLK	=	0x00cc
                     00CD   270 _RCLK	=	0x00cd
                     00CE   271 _EXF2	=	0x00ce
                     00CF   272 _TF2	=	0x00cf
                            273 ;--------------------------------------------------------
                            274 ; overlayable register banks
                            275 ;--------------------------------------------------------
                            276 	.area REG_BANK_0	(REL,OVR,DATA)
   0000                     277 	.ds 8
                            278 ;--------------------------------------------------------
                            279 ; internal ram data
                            280 ;--------------------------------------------------------
                            281 	.area DSEG    (DATA)
                            282 ;--------------------------------------------------------
                            283 ; overlayable items in internal ram 
                            284 ;--------------------------------------------------------
                            285 	.area	OSEG    (OVR,DATA)
                            286 	.area	OSEG    (OVR,DATA)
                            287 	.area	OSEG    (OVR,DATA)
                            288 	.area	OSEG    (OVR,DATA)
                            289 	.area	OSEG    (OVR,DATA)
   0021                     290 _SendPacket_PARM_2:
   0021                     291 	.ds 1
   0022                     292 _SendPacket_PARM_3:
   0022                     293 	.ds 2
   0024                     294 _SendPacket_PARM_4:
   0024                     295 	.ds 2
                            296 	.area	OSEG    (OVR,DATA)
                            297 ;--------------------------------------------------------
                            298 ; indirectly addressable internal ram data
                            299 ;--------------------------------------------------------
                            300 	.area ISEG    (DATA)
                            301 ;--------------------------------------------------------
                            302 ; absolute internal ram data
                            303 ;--------------------------------------------------------
                            304 	.area IABS    (ABS,DATA)
                            305 	.area IABS    (ABS,DATA)
                            306 ;--------------------------------------------------------
                            307 ; bit data
                            308 ;--------------------------------------------------------
                            309 	.area BSEG    (BIT)
                            310 ;--------------------------------------------------------
                            311 ; paged external ram data
                            312 ;--------------------------------------------------------
                            313 	.area PSEG    (PAG,XDATA)
                            314 ;--------------------------------------------------------
                            315 ; external ram data
                            316 ;--------------------------------------------------------
                            317 	.area XSEG    (XDATA)
   0100                     318 _txBuf::
   0100                     319 	.ds 256
                            320 ;--------------------------------------------------------
                            321 ; absolute external ram data
                            322 ;--------------------------------------------------------
                            323 	.area XABS    (ABS,XDATA)
                            324 ;--------------------------------------------------------
                            325 ; external initialized ram data
                            326 ;--------------------------------------------------------
                            327 	.area XISEG   (XDATA)
                            328 	.area HOME    (CODE)
                            329 	.area GSINIT0 (CODE)
                            330 	.area GSINIT1 (CODE)
                            331 	.area GSINIT2 (CODE)
                            332 	.area GSINIT3 (CODE)
                            333 	.area GSINIT4 (CODE)
                            334 	.area GSINIT5 (CODE)
                            335 	.area GSINIT  (CODE)
                            336 	.area GSFINAL (CODE)
                            337 	.area CSEG    (CODE)
                            338 ;--------------------------------------------------------
                            339 ; global & static initialisations
                            340 ;--------------------------------------------------------
                            341 	.area HOME    (CODE)
                            342 	.area GSINIT  (CODE)
                            343 	.area GSFINAL (CODE)
                            344 	.area GSINIT  (CODE)
                            345 ;--------------------------------------------------------
                            346 ; Home
                            347 ;--------------------------------------------------------
                            348 	.area HOME    (CODE)
                            349 	.area HOME    (CODE)
                            350 ;--------------------------------------------------------
                            351 ; code
                            352 ;--------------------------------------------------------
                            353 	.area CSEG    (CODE)
                            354 ;------------------------------------------------------------
                            355 ;Allocation info for local variables in function 'GetRx'
                            356 ;------------------------------------------------------------
                            357 ;port                      Allocated to registers r7 
                            358 ;------------------------------------------------------------
                            359 ;	../common/T51Interface.c:41: rx_t GetRx(uint8_t const port) {
                            360 ;	-----------------------------------------
                            361 ;	 function GetRx
                            362 ;	-----------------------------------------
   0A37                     363 _GetRx:
                     0007   364 	ar7 = 0x07
                     0006   365 	ar6 = 0x06
                     0005   366 	ar5 = 0x05
                     0004   367 	ar4 = 0x04
                     0003   368 	ar3 = 0x03
                     0002   369 	ar2 = 0x02
                     0001   370 	ar1 = 0x01
                     0000   371 	ar0 = 0x00
   0A37 AF 82         [24]  372 	mov	r7,dpl
                            373 ;	../common/T51Interface.c:42: return ((rx_t)PortById(port)->rx);
   0A39 90 0C 54      [24]  374 	mov	dptr,#_pPorts
   0A3C E4            [12]  375 	clr	a
   0A3D 93            [24]  376 	movc	a,@a+dptr
   0A3E FD            [12]  377 	mov	r5,a
   0A3F 74 01         [12]  378 	mov	a,#0x01
   0A41 93            [24]  379 	movc	a,@a+dptr
   0A42 FE            [12]  380 	mov	r6,a
   0A43 EF            [12]  381 	mov	a,r7
   0A44 2F            [12]  382 	add	a,r7
   0A45 FC            [12]  383 	mov	r4,a
   0A46 E4            [12]  384 	clr	a
   0A47 2D            [12]  385 	add	a,r5
   0A48 F5 82         [12]  386 	mov	dpl,a
   0A4A EC            [12]  387 	mov	a,r4
   0A4B 3E            [12]  388 	addc	a,r6
   0A4C F5 83         [12]  389 	mov	dph,a
   0A4E 22            [24]  390 	ret
                            391 ;------------------------------------------------------------
                            392 ;Allocation info for local variables in function 'GetTxBuf'
                            393 ;------------------------------------------------------------
                            394 ;	../common/T51Interface.c:45: tx_t GetTxBuf() {
                            395 ;	-----------------------------------------
                            396 ;	 function GetTxBuf
                            397 ;	-----------------------------------------
   0A4F                     398 _GetTxBuf:
                            399 ;	../common/T51Interface.c:46: return (tx_t)txBuf;
   0A4F 90 01 00      [24]  400 	mov	dptr,#_txBuf
   0A52 22            [24]  401 	ret
                            402 ;------------------------------------------------------------
                            403 ;Allocation info for local variables in function 'ResetRx'
                            404 ;------------------------------------------------------------
                            405 ;port                      Allocated to registers r7 
                            406 ;------------------------------------------------------------
                            407 ;	../common/T51Interface.c:48: void ResetRx(uint8_t const port) {
                            408 ;	-----------------------------------------
                            409 ;	 function ResetRx
                            410 ;	-----------------------------------------
   0A53                     411 _ResetRx:
   0A53 AF 82         [24]  412 	mov	r7,dpl
                            413 ;	../common/T51Interface.c:49: PortById(port)->control = RX_RESET_MASK; 
   0A55 90 0C 54      [24]  414 	mov	dptr,#_pPorts
   0A58 E4            [12]  415 	clr	a
   0A59 93            [24]  416 	movc	a,@a+dptr
   0A5A FD            [12]  417 	mov	r5,a
   0A5B 74 01         [12]  418 	mov	a,#0x01
   0A5D 93            [24]  419 	movc	a,@a+dptr
   0A5E FE            [12]  420 	mov	r6,a
   0A5F EF            [12]  421 	mov	a,r7
   0A60 2F            [12]  422 	add	a,r7
   0A61 FC            [12]  423 	mov	r4,a
   0A62 E4            [12]  424 	clr	a
   0A63 2D            [12]  425 	add	a,r5
   0A64 FD            [12]  426 	mov	r5,a
   0A65 EC            [12]  427 	mov	a,r4
   0A66 3E            [12]  428 	addc	a,r6
   0A67 FE            [12]  429 	mov	r6,a
   0A68 74 01         [12]  430 	mov	a,#0x01
   0A6A 2D            [12]  431 	add	a,r5
   0A6B F5 82         [12]  432 	mov	dpl,a
   0A6D 74 01         [12]  433 	mov	a,#0x01
   0A6F 3E            [12]  434 	addc	a,r6
   0A70 F5 83         [12]  435 	mov	dph,a
   0A72 74 02         [12]  436 	mov	a,#0x02
   0A74 F0            [24]  437 	movx	@dptr,a
   0A75 22            [24]  438 	ret
                            439 ;------------------------------------------------------------
                            440 ;Allocation info for local variables in function 'GetRxCount'
                            441 ;------------------------------------------------------------
                            442 ;port                      Allocated to registers r7 
                            443 ;------------------------------------------------------------
                            444 ;	../common/T51Interface.c:52: uint16_t GetRxCount(uint8_t const port) {
                            445 ;	-----------------------------------------
                            446 ;	 function GetRxCount
                            447 ;	-----------------------------------------
   0A76                     448 _GetRxCount:
   0A76 AF 82         [24]  449 	mov	r7,dpl
                            450 ;	../common/T51Interface.c:53: return PortById(port)->rxCount;
   0A78 90 0C 54      [24]  451 	mov	dptr,#_pPorts
   0A7B E4            [12]  452 	clr	a
   0A7C 93            [24]  453 	movc	a,@a+dptr
   0A7D FD            [12]  454 	mov	r5,a
   0A7E 74 01         [12]  455 	mov	a,#0x01
   0A80 93            [24]  456 	movc	a,@a+dptr
   0A81 FE            [12]  457 	mov	r6,a
   0A82 EF            [12]  458 	mov	a,r7
   0A83 2F            [12]  459 	add	a,r7
   0A84 FC            [12]  460 	mov	r4,a
   0A85 E4            [12]  461 	clr	a
   0A86 2D            [12]  462 	add	a,r5
   0A87 FD            [12]  463 	mov	r5,a
   0A88 EC            [12]  464 	mov	a,r4
   0A89 3E            [12]  465 	addc	a,r6
   0A8A FE            [12]  466 	mov	r6,a
   0A8B 74 02         [12]  467 	mov	a,#0x02
   0A8D 2D            [12]  468 	add	a,r5
   0A8E F5 82         [12]  469 	mov	dpl,a
   0A90 74 01         [12]  470 	mov	a,#0x01
   0A92 3E            [12]  471 	addc	a,r6
   0A93 F5 83         [12]  472 	mov	dph,a
   0A95 E0            [24]  473 	movx	a,@dptr
   0A96 FF            [12]  474 	mov	r7,a
   0A97 7E 00         [12]  475 	mov	r6,#0x00
   0A99 8F 82         [24]  476 	mov	dpl,r7
   0A9B 8E 83         [24]  477 	mov	dph,r6
   0A9D 22            [24]  478 	ret
                            479 ;------------------------------------------------------------
                            480 ;Allocation info for local variables in function 'PacketAvailable'
                            481 ;------------------------------------------------------------
                            482 ;port                      Allocated to registers r7 
                            483 ;------------------------------------------------------------
                            484 ;	../common/T51Interface.c:57: uint8_t PacketAvailable(uint8_t const port) {
                            485 ;	-----------------------------------------
                            486 ;	 function PacketAvailable
                            487 ;	-----------------------------------------
   0A9E                     488 _PacketAvailable:
   0A9E AF 82         [24]  489 	mov	r7,dpl
                            490 ;	../common/T51Interface.c:58: return ((PortById(port)->control) & EOF_MASK);
   0AA0 90 0C 54      [24]  491 	mov	dptr,#_pPorts
   0AA3 E4            [12]  492 	clr	a
   0AA4 93            [24]  493 	movc	a,@a+dptr
   0AA5 FD            [12]  494 	mov	r5,a
   0AA6 74 01         [12]  495 	mov	a,#0x01
   0AA8 93            [24]  496 	movc	a,@a+dptr
   0AA9 FE            [12]  497 	mov	r6,a
   0AAA EF            [12]  498 	mov	a,r7
   0AAB 2F            [12]  499 	add	a,r7
   0AAC FC            [12]  500 	mov	r4,a
   0AAD E4            [12]  501 	clr	a
   0AAE 2D            [12]  502 	add	a,r5
   0AAF FD            [12]  503 	mov	r5,a
   0AB0 EC            [12]  504 	mov	a,r4
   0AB1 3E            [12]  505 	addc	a,r6
   0AB2 FE            [12]  506 	mov	r6,a
   0AB3 74 01         [12]  507 	mov	a,#0x01
   0AB5 2D            [12]  508 	add	a,r5
   0AB6 F5 82         [12]  509 	mov	dpl,a
   0AB8 74 01         [12]  510 	mov	a,#0x01
   0ABA 3E            [12]  511 	addc	a,r6
   0ABB F5 83         [12]  512 	mov	dph,a
   0ABD E0            [24]  513 	movx	a,@dptr
   0ABE FF            [12]  514 	mov	r7,a
   0ABF 74 01         [12]  515 	mov	a,#0x01
   0AC1 5F            [12]  516 	anl	a,r7
   0AC2 F5 82         [12]  517 	mov	dpl,a
   0AC4 22            [24]  518 	ret
                            519 ;------------------------------------------------------------
                            520 ;Allocation info for local variables in function 'SendPacket'
                            521 ;------------------------------------------------------------
                            522 ;id                        Allocated with name '_SendPacket_PARM_2'
                            523 ;buf                       Allocated with name '_SendPacket_PARM_3'
                            524 ;len                       Allocated with name '_SendPacket_PARM_4'
                            525 ;port                      Allocated to registers r7 
                            526 ;i                         Allocated to registers r3 
                            527 ;------------------------------------------------------------
                            528 ;	../common/T51Interface.c:62: void SendPacket(uint8_t const port, uint8_t const id,
                            529 ;	-----------------------------------------
                            530 ;	 function SendPacket
                            531 ;	-----------------------------------------
   0AC5                     532 _SendPacket:
   0AC5 AF 82         [24]  533 	mov	r7,dpl
                            534 ;	../common/T51Interface.c:67: if(!len) return;
   0AC7 E5 24         [12]  535 	mov	a,_SendPacket_PARM_4
   0AC9 45 25         [12]  536 	orl	a,(_SendPacket_PARM_4 + 1)
   0ACB 70 01         [24]  537 	jnz	00103$
                            538 ;	../common/T51Interface.c:69: SetId(port, id);
   0ACD 22            [24]  539 	ret
   0ACE                     540 00103$:
   0ACE 90 0C 54      [24]  541 	mov	dptr,#_pPorts
   0AD1 E4            [12]  542 	clr	a
   0AD2 93            [24]  543 	movc	a,@a+dptr
   0AD3 FD            [12]  544 	mov	r5,a
   0AD4 74 01         [12]  545 	mov	a,#0x01
   0AD6 93            [24]  546 	movc	a,@a+dptr
   0AD7 FE            [12]  547 	mov	r6,a
   0AD8 EF            [12]  548 	mov	a,r7
   0AD9 2F            [12]  549 	add	a,r7
   0ADA FC            [12]  550 	mov	r4,a
   0ADB E4            [12]  551 	clr	a
   0ADC 2D            [12]  552 	add	a,r5
   0ADD FF            [12]  553 	mov	r7,a
   0ADE EC            [12]  554 	mov	a,r4
   0ADF 3E            [12]  555 	addc	a,r6
   0AE0 FE            [12]  556 	mov	r6,a
   0AE1 74 03         [12]  557 	mov	a,#0x03
   0AE3 2F            [12]  558 	add	a,r7
   0AE4 F5 82         [12]  559 	mov	dpl,a
   0AE6 74 01         [12]  560 	mov	a,#0x01
   0AE8 3E            [12]  561 	addc	a,r6
   0AE9 F5 83         [12]  562 	mov	dph,a
   0AEB E5 21         [12]  563 	mov	a,_SendPacket_PARM_2
   0AED F0            [24]  564 	movx	@dptr,a
                            565 ;	../common/T51Interface.c:70: for(i = 0; i < len-1; ++i) {                            
   0AEE E5 24         [12]  566 	mov	a,_SendPacket_PARM_4
   0AF0 24 FF         [12]  567 	add	a,#0xFF
   0AF2 FC            [12]  568 	mov	r4,a
   0AF3 E5 25         [12]  569 	mov	a,(_SendPacket_PARM_4 + 1)
   0AF5 34 FF         [12]  570 	addc	a,#0xFF
   0AF7 FD            [12]  571 	mov	r5,a
   0AF8 7B 00         [12]  572 	mov	r3,#0x00
   0AFA                     573 00117$:
   0AFA 8B 01         [24]  574 	mov	ar1,r3
   0AFC 7A 00         [12]  575 	mov	r2,#0x00
   0AFE C3            [12]  576 	clr	c
   0AFF E9            [12]  577 	mov	a,r1
   0B00 9C            [12]  578 	subb	a,r4
   0B01 EA            [12]  579 	mov	a,r2
   0B02 9D            [12]  580 	subb	a,r5
   0B03 50 1A         [24]  581 	jnc	00110$
                            582 ;	../common/T51Interface.c:71: Send(port, buf[i]);                                   
   0B05 8F 01         [24]  583 	mov	ar1,r7
   0B07 74 01         [12]  584 	mov	a,#0x01
   0B09 2E            [12]  585 	add	a,r6
   0B0A FA            [12]  586 	mov	r2,a
   0B0B EB            [12]  587 	mov	a,r3
   0B0C 25 22         [12]  588 	add	a,_SendPacket_PARM_3
   0B0E F5 82         [12]  589 	mov	dpl,a
   0B10 E4            [12]  590 	clr	a
   0B11 35 23         [12]  591 	addc	a,(_SendPacket_PARM_3 + 1)
   0B13 F5 83         [12]  592 	mov	dph,a
   0B15 E0            [24]  593 	movx	a,@dptr
   0B16 F8            [12]  594 	mov	r0,a
   0B17 89 82         [24]  595 	mov	dpl,r1
   0B19 8A 83         [24]  596 	mov	dph,r2
   0B1B F0            [24]  597 	movx	@dptr,a
                            598 ;	../common/T51Interface.c:70: for(i = 0; i < len-1; ++i) {                            
   0B1C 0B            [12]  599 	inc	r3
                            600 ;	../common/T51Interface.c:73: SetEof(port);
   0B1D 80 DB         [24]  601 	sjmp	00117$
   0B1F                     602 00110$:
   0B1F 74 01         [12]  603 	mov	a,#0x01
   0B21 2F            [12]  604 	add	a,r7
   0B22 F5 82         [12]  605 	mov	dpl,a
   0B24 74 01         [12]  606 	mov	a,#0x01
   0B26 3E            [12]  607 	addc	a,r6
   0B27 F5 83         [12]  608 	mov	dph,a
   0B29 74 01         [12]  609 	mov	a,#0x01
   0B2B F0            [24]  610 	movx	@dptr,a
                            611 ;	../common/T51Interface.c:74: Send(port, buf[i]);                                    
   0B2C 74 01         [12]  612 	mov	a,#0x01
   0B2E 2E            [12]  613 	add	a,r6
   0B2F FE            [12]  614 	mov	r6,a
   0B30 EB            [12]  615 	mov	a,r3
   0B31 25 22         [12]  616 	add	a,_SendPacket_PARM_3
   0B33 F5 82         [12]  617 	mov	dpl,a
   0B35 E4            [12]  618 	clr	a
   0B36 35 23         [12]  619 	addc	a,(_SendPacket_PARM_3 + 1)
   0B38 F5 83         [12]  620 	mov	dph,a
   0B3A E0            [24]  621 	movx	a,@dptr
   0B3B 8F 82         [24]  622 	mov	dpl,r7
   0B3D 8E 83         [24]  623 	mov	dph,r6
   0B3F F0            [24]  624 	movx	@dptr,a
   0B40 22            [24]  625 	ret
                            626 ;------------------------------------------------------------
                            627 ;Allocation info for local variables in function 'SendDebug'
                            628 ;------------------------------------------------------------
                            629 ;code                      Allocated to registers r7 
                            630 ;------------------------------------------------------------
                            631 ;	../common/T51Interface.c:77: void SendDebug(uint8_t const code) {
                            632 ;	-----------------------------------------
                            633 ;	 function SendDebug
                            634 ;	-----------------------------------------
   0B41                     635 _SendDebug:
   0B41 AF 82         [24]  636 	mov	r7,dpl
                            637 ;	../common/T51Interface.c:78: SetId(HOST, ID_DEBUG);    
   0B43 90 0C 54      [24]  638 	mov	dptr,#_pPorts
   0B46 E4            [12]  639 	clr	a
   0B47 93            [24]  640 	movc	a,@a+dptr
   0B48 FD            [12]  641 	mov	r5,a
   0B49 74 01         [12]  642 	mov	a,#0x01
   0B4B 93            [24]  643 	movc	a,@a+dptr
   0B4C FE            [12]  644 	mov	r6,a
   0B4D 74 03         [12]  645 	mov	a,#0x03
   0B4F 2D            [12]  646 	add	a,r5
   0B50 F5 82         [12]  647 	mov	dpl,a
   0B52 74 01         [12]  648 	mov	a,#0x01
   0B54 3E            [12]  649 	addc	a,r6
   0B55 F5 83         [12]  650 	mov	dph,a
   0B57 74 E1         [12]  651 	mov	a,#0xE1
   0B59 F0            [24]  652 	movx	@dptr,a
                            653 ;	../common/T51Interface.c:79: SetEof(HOST);
   0B5A 74 01         [12]  654 	mov	a,#0x01
   0B5C 2D            [12]  655 	add	a,r5
   0B5D F5 82         [12]  656 	mov	dpl,a
   0B5F 74 01         [12]  657 	mov	a,#0x01
   0B61 3E            [12]  658 	addc	a,r6
   0B62 F5 83         [12]  659 	mov	dph,a
   0B64 74 01         [12]  660 	mov	a,#0x01
   0B66 F0            [24]  661 	movx	@dptr,a
                            662 ;	../common/T51Interface.c:80: Send(HOST, code);
   0B67 8D 82         [24]  663 	mov	dpl,r5
   0B69 74 01         [12]  664 	mov	a,#0x01
   0B6B 2E            [12]  665 	add	a,r6
   0B6C F5 83         [12]  666 	mov	dph,a
   0B6E EF            [12]  667 	mov	a,r7
   0B6F F0            [24]  668 	movx	@dptr,a
   0B70 22            [24]  669 	ret
                            670 ;------------------------------------------------------------
                            671 ;Allocation info for local variables in function 'IfInit'
                            672 ;------------------------------------------------------------
                            673 ;i                         Allocated to registers r7 
                            674 ;------------------------------------------------------------
                            675 ;	../common/T51Interface.c:84: void IfInit(void) {
                            676 ;	-----------------------------------------
                            677 ;	 function IfInit
                            678 ;	-----------------------------------------
   0B71                     679 _IfInit:
                            680 ;	../common/T51Interface.c:86: for(i = 0; i < N_PORTS; ++i) {
   0B71 7F 00         [12]  681 	mov	r7,#0x00
   0B73                     682 00105$:
                            683 ;	../common/T51Interface.c:87: ResetRx(i);
   0B73 8F 82         [24]  684 	mov	dpl,r7
   0B75 C0 07         [24]  685 	push	ar7
   0B77 12 0A 53      [24]  686 	lcall	_ResetRx
   0B7A D0 07         [24]  687 	pop	ar7
                            688 ;	../common/T51Interface.c:86: for(i = 0; i < N_PORTS; ++i) {
   0B7C 0F            [12]  689 	inc	r7
   0B7D BF 02 00      [24]  690 	cjne	r7,#0x02,00116$
   0B80                     691 00116$:
   0B80 40 F1         [24]  692 	jc	00105$
                            693 ;	../common/T51Interface.c:89: SetId(HOST, ID_DEBUG);
   0B82 90 0C 54      [24]  694 	mov	dptr,#_pPorts
   0B85 E4            [12]  695 	clr	a
   0B86 93            [24]  696 	movc	a,@a+dptr
   0B87 FE            [12]  697 	mov	r6,a
   0B88 74 01         [12]  698 	mov	a,#0x01
   0B8A 93            [24]  699 	movc	a,@a+dptr
   0B8B FF            [12]  700 	mov	r7,a
   0B8C 74 03         [12]  701 	mov	a,#0x03
   0B8E 2E            [12]  702 	add	a,r6
   0B8F F5 82         [12]  703 	mov	dpl,a
   0B91 74 01         [12]  704 	mov	a,#0x01
   0B93 3F            [12]  705 	addc	a,r7
   0B94 F5 83         [12]  706 	mov	dph,a
   0B96 74 E1         [12]  707 	mov	a,#0xE1
   0B98 F0            [24]  708 	movx	@dptr,a
                            709 ;	../common/T51Interface.c:90: SendDebug(D_T51_READY);
   0B99 75 82 08      [24]  710 	mov	dpl,#0x08
   0B9C 02 0B 41      [24]  711 	ljmp	_SendDebug
                            712 	.area CSEG    (CODE)
                            713 	.area CONST   (CODE)
   0C54                     714 _pPorts:
   0C54 00 08               715 	.byte #0x00,#0x08
                            716 	.area XINIT   (CODE)
                            717 	.area CABS    (ABS,CODE)
