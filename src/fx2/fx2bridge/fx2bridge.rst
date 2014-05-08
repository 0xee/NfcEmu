                              1 ;--------------------------------------------------------
                              2 ; File Created by SDCC : free open source ANSI-C Compiler
                              3 ; Version 3.3.0 #8604 (Sep  2 2013) (Linux)
                              4 ; This file was generated Thu May  8 18:45:15 2014
                              5 ;--------------------------------------------------------
                              6 	.module fx2bridge
                              7 	.optsdcc -mmcs51 --model-small
                              8 	
                              9 ;--------------------------------------------------------
                             10 ; Public variables in this module
                             11 ;--------------------------------------------------------
                             12 	.globl _main
                             13 	.globl _ResetFifos
                             14 	.globl _EIPX6
                             15 	.globl _EIPX5
                             16 	.globl _EIPX4
                             17 	.globl _PI2C
                             18 	.globl _PUSB
                             19 	.globl _EIEX6
                             20 	.globl _EIEX5
                             21 	.globl _EIEX4
                             22 	.globl _EI2C
                             23 	.globl _EUSB
                             24 	.globl _SMOD1
                             25 	.globl _ERESI
                             26 	.globl _RESI
                             27 	.globl _INT6
                             28 	.globl _CY
                             29 	.globl _AC
                             30 	.globl _F0
                             31 	.globl _RS1
                             32 	.globl _RS0
                             33 	.globl _OV
                             34 	.globl _FL
                             35 	.globl _P
                             36 	.globl _TF2
                             37 	.globl _EXF2
                             38 	.globl _RCLK
                             39 	.globl _TCLK
                             40 	.globl _EXEN2
                             41 	.globl _TR2
                             42 	.globl _C_T2
                             43 	.globl _CP_RL2
                             44 	.globl _SM01
                             45 	.globl _SM11
                             46 	.globl _SM21
                             47 	.globl _REN1
                             48 	.globl _TB81
                             49 	.globl _RB81
                             50 	.globl _TI1
                             51 	.globl _RI1
                             52 	.globl _PS1
                             53 	.globl _PT2
                             54 	.globl _PS0
                             55 	.globl _PT1
                             56 	.globl _PX1
                             57 	.globl _PT0
                             58 	.globl _PX0
                             59 	.globl _PD7
                             60 	.globl _PD6
                             61 	.globl _PD5
                             62 	.globl _PD4
                             63 	.globl _PD3
                             64 	.globl _PD2
                             65 	.globl _PD1
                             66 	.globl _PD0
                             67 	.globl _EA
                             68 	.globl _ES1
                             69 	.globl _ET2
                             70 	.globl _ES0
                             71 	.globl _ET1
                             72 	.globl _EX1
                             73 	.globl _ET0
                             74 	.globl _EX0
                             75 	.globl _PC7
                             76 	.globl _PC6
                             77 	.globl _PC5
                             78 	.globl _PC4
                             79 	.globl _PC3
                             80 	.globl _PC2
                             81 	.globl _PC1
                             82 	.globl _PC0
                             83 	.globl _SM0
                             84 	.globl _SM1
                             85 	.globl _SM2
                             86 	.globl _REN
                             87 	.globl _TB8
                             88 	.globl _RB8
                             89 	.globl _TI
                             90 	.globl _RI
                             91 	.globl _PB7
                             92 	.globl _PB6
                             93 	.globl _PB5
                             94 	.globl _PB4
                             95 	.globl _PB3
                             96 	.globl _PB2
                             97 	.globl _PB1
                             98 	.globl _PB0
                             99 	.globl _TF1
                            100 	.globl _TR1
                            101 	.globl _TF0
                            102 	.globl _TR0
                            103 	.globl _IE1
                            104 	.globl _IT1
                            105 	.globl _IE0
                            106 	.globl _IT0
                            107 	.globl _PA7
                            108 	.globl _PA6
                            109 	.globl _PA5
                            110 	.globl _PA4
                            111 	.globl _PA3
                            112 	.globl _PA2
                            113 	.globl _PA1
                            114 	.globl _PA0
                            115 	.globl _EIP
                            116 	.globl _B
                            117 	.globl _EIE
                            118 	.globl _ACC
                            119 	.globl _EICON
                            120 	.globl _PSW
                            121 	.globl _TH2
                            122 	.globl _TL2
                            123 	.globl _RCAP2H
                            124 	.globl _RCAP2L
                            125 	.globl _T2CON
                            126 	.globl _SBUF1
                            127 	.globl _SCON1
                            128 	.globl _GPIFSGLDATLNOX
                            129 	.globl _GPIFSGLDATLX
                            130 	.globl _GPIFSGLDATH
                            131 	.globl _GPIFTRIG
                            132 	.globl _EP01STAT
                            133 	.globl _IP
                            134 	.globl _OEE
                            135 	.globl _OED
                            136 	.globl _OEC
                            137 	.globl _OEB
                            138 	.globl _OEA
                            139 	.globl _IOE
                            140 	.globl _IOD
                            141 	.globl _AUTOPTRSETUP
                            142 	.globl _EP68FIFOFLGS
                            143 	.globl _EP24FIFOFLGS
                            144 	.globl _EP2468STAT
                            145 	.globl _IE
                            146 	.globl _INT4CLR
                            147 	.globl _INT2CLR
                            148 	.globl _IOC
                            149 	.globl _AUTOPTRL2
                            150 	.globl _AUTOPTRH2
                            151 	.globl _AUTOPTRL1
                            152 	.globl _AUTOPTRH1
                            153 	.globl _SBUF0
                            154 	.globl _SCON0
                            155 	.globl __XPAGE
                            156 	.globl _EXIF
                            157 	.globl _IOB
                            158 	.globl _CKCON
                            159 	.globl _TH1
                            160 	.globl _TH0
                            161 	.globl _TL1
                            162 	.globl _TL0
                            163 	.globl _TMOD
                            164 	.globl _TCON
                            165 	.globl _PCON
                            166 	.globl _DPS
                            167 	.globl _DPH1
                            168 	.globl _DPL1
                            169 	.globl _DPH
                            170 	.globl _DPL
                            171 	.globl _SP
                            172 	.globl _IOA
                            173 	.globl _GPCR2
                            174 	.globl _ECC2B2
                            175 	.globl _ECC2B1
                            176 	.globl _ECC2B0
                            177 	.globl _ECC1B2
                            178 	.globl _ECC1B1
                            179 	.globl _ECC1B0
                            180 	.globl _ECCRESET
                            181 	.globl _ECCCFG
                            182 	.globl _EP8FIFOBUF
                            183 	.globl _EP6FIFOBUF
                            184 	.globl _EP4FIFOBUF
                            185 	.globl _EP2FIFOBUF
                            186 	.globl _EP1INBUF
                            187 	.globl _EP1OUTBUF
                            188 	.globl _EP0BUF
                            189 	.globl _UDMACRCQUAL
                            190 	.globl _UDMACRCL
                            191 	.globl _UDMACRCH
                            192 	.globl _GPIFHOLDAMOUNT
                            193 	.globl _FLOWSTBHPERIOD
                            194 	.globl _FLOWSTBEDGE
                            195 	.globl _FLOWSTB
                            196 	.globl _FLOWHOLDOFF
                            197 	.globl _FLOWEQ1CTL
                            198 	.globl _FLOWEQ0CTL
                            199 	.globl _FLOWLOGIC
                            200 	.globl _FLOWSTATE
                            201 	.globl _GPIFABORT
                            202 	.globl _GPIFREADYSTAT
                            203 	.globl _GPIFREADYCFG
                            204 	.globl _XGPIFSGLDATLNOX
                            205 	.globl _XGPIFSGLDATLX
                            206 	.globl _XGPIFSGLDATH
                            207 	.globl _EP8GPIFTRIG
                            208 	.globl _EP8GPIFPFSTOP
                            209 	.globl _EP8GPIFFLGSEL
                            210 	.globl _EP6GPIFTRIG
                            211 	.globl _EP6GPIFPFSTOP
                            212 	.globl _EP6GPIFFLGSEL
                            213 	.globl _EP4GPIFTRIG
                            214 	.globl _EP4GPIFPFSTOP
                            215 	.globl _EP4GPIFFLGSEL
                            216 	.globl _EP2GPIFTRIG
                            217 	.globl _EP2GPIFPFSTOP
                            218 	.globl _EP2GPIFFLGSEL
                            219 	.globl _GPIFTCB0
                            220 	.globl _GPIFTCB1
                            221 	.globl _GPIFTCB2
                            222 	.globl _GPIFTCB3
                            223 	.globl _GPIFADRL
                            224 	.globl _GPIFADRH
                            225 	.globl _GPIFCTLCFG
                            226 	.globl _GPIFIDLECTL
                            227 	.globl _GPIFIDLECS
                            228 	.globl _GPIFWFSELECT
                            229 	.globl _SETUPDAT
                            230 	.globl _SUDPTRCTL
                            231 	.globl _SUDPTRL
                            232 	.globl _SUDPTRH
                            233 	.globl _EP8FIFOBCL
                            234 	.globl _EP8FIFOBCH
                            235 	.globl _EP6FIFOBCL
                            236 	.globl _EP6FIFOBCH
                            237 	.globl _EP4FIFOBCL
                            238 	.globl _EP4FIFOBCH
                            239 	.globl _EP2FIFOBCL
                            240 	.globl _EP2FIFOBCH
                            241 	.globl _EP8FIFOFLGS
                            242 	.globl _EP6FIFOFLGS
                            243 	.globl _EP4FIFOFLGS
                            244 	.globl _EP2FIFOFLGS
                            245 	.globl _EP8CS
                            246 	.globl _EP6CS
                            247 	.globl _EP4CS
                            248 	.globl _EP2CS
                            249 	.globl _EP1INCS
                            250 	.globl _EP1OUTCS
                            251 	.globl _EP0CS
                            252 	.globl _EP8BCL
                            253 	.globl _EP8BCH
                            254 	.globl _EP6BCL
                            255 	.globl _EP6BCH
                            256 	.globl _EP4BCL
                            257 	.globl _EP4BCH
                            258 	.globl _EP2BCL
                            259 	.globl _EP2BCH
                            260 	.globl _EP1INBC
                            261 	.globl _EP1OUTBC
                            262 	.globl _EP0BCL
                            263 	.globl _EP0BCH
                            264 	.globl _FNADDR
                            265 	.globl _MICROFRAME
                            266 	.globl _USBFRAMEL
                            267 	.globl _USBFRAMEH
                            268 	.globl _TOGCTL
                            269 	.globl _WAKEUPCS
                            270 	.globl _SUSPEND
                            271 	.globl _USBCS
                            272 	.globl _XAUTODAT2
                            273 	.globl _XAUTODAT1
                            274 	.globl _I2CTL
                            275 	.globl _I2DAT
                            276 	.globl _I2CS
                            277 	.globl _PORTECFG
                            278 	.globl _PORTCCFG
                            279 	.globl _PORTACFG
                            280 	.globl _INTSETUP
                            281 	.globl _INT4IVEC
                            282 	.globl _INT2IVEC
                            283 	.globl _CLRERRCNT
                            284 	.globl _ERRCNTLIM
                            285 	.globl _USBERRIRQ
                            286 	.globl _USBERRIE
                            287 	.globl _GPIFIRQ
                            288 	.globl _GPIFIE
                            289 	.globl _EPIRQ
                            290 	.globl _EPIE
                            291 	.globl _USBIRQ
                            292 	.globl _USBIE
                            293 	.globl _NAKIRQ
                            294 	.globl _NAKIE
                            295 	.globl _IBNIRQ
                            296 	.globl _IBNIE
                            297 	.globl _EP8FIFOIRQ
                            298 	.globl _EP8FIFOIE
                            299 	.globl _EP6FIFOIRQ
                            300 	.globl _EP6FIFOIE
                            301 	.globl _EP4FIFOIRQ
                            302 	.globl _EP4FIFOIE
                            303 	.globl _EP2FIFOIRQ
                            304 	.globl _EP2FIFOIE
                            305 	.globl _OUTPKTEND
                            306 	.globl _INPKTEND
                            307 	.globl _EP8ISOINPKTS
                            308 	.globl _EP6ISOINPKTS
                            309 	.globl _EP4ISOINPKTS
                            310 	.globl _EP2ISOINPKTS
                            311 	.globl _EP8FIFOPFL
                            312 	.globl _EP8FIFOPFH
                            313 	.globl _EP6FIFOPFL
                            314 	.globl _EP6FIFOPFH
                            315 	.globl _EP4FIFOPFL
                            316 	.globl _EP4FIFOPFH
                            317 	.globl _EP2FIFOPFL
                            318 	.globl _EP2FIFOPFH
                            319 	.globl _EP8AUTOINLENL
                            320 	.globl _EP8AUTOINLENH
                            321 	.globl _EP6AUTOINLENL
                            322 	.globl _EP6AUTOINLENH
                            323 	.globl _EP4AUTOINLENL
                            324 	.globl _EP4AUTOINLENH
                            325 	.globl _EP2AUTOINLENL
                            326 	.globl _EP2AUTOINLENH
                            327 	.globl _EP8FIFOCFG
                            328 	.globl _EP6FIFOCFG
                            329 	.globl _EP4FIFOCFG
                            330 	.globl _EP2FIFOCFG
                            331 	.globl _EP8CFG
                            332 	.globl _EP6CFG
                            333 	.globl _EP4CFG
                            334 	.globl _EP2CFG
                            335 	.globl _EP1INCFG
                            336 	.globl _EP1OUTCFG
                            337 	.globl _REVCTL
                            338 	.globl _REVID
                            339 	.globl _FIFOPINPOLAR
                            340 	.globl _UART230
                            341 	.globl _BPADDRL
                            342 	.globl _BPADDRH
                            343 	.globl _BREAKPT
                            344 	.globl _FIFORESET
                            345 	.globl _PINFLAGSCD
                            346 	.globl _PINFLAGSAB
                            347 	.globl _IFCONFIG
                            348 	.globl _CPUCS
                            349 	.globl _RES_WAVEDATA_END
                            350 	.globl _GPIF_WAVE_DATA
                            351 ;--------------------------------------------------------
                            352 ; special function registers
                            353 ;--------------------------------------------------------
                            354 	.area RSEG    (ABS,DATA)
   0000                     355 	.org 0x0000
                     0080   356 _IOA	=	0x0080
                     0081   357 _SP	=	0x0081
                     0082   358 _DPL	=	0x0082
                     0083   359 _DPH	=	0x0083
                     0084   360 _DPL1	=	0x0084
                     0085   361 _DPH1	=	0x0085
                     0086   362 _DPS	=	0x0086
                     0087   363 _PCON	=	0x0087
                     0088   364 _TCON	=	0x0088
                     0089   365 _TMOD	=	0x0089
                     008A   366 _TL0	=	0x008a
                     008B   367 _TL1	=	0x008b
                     008C   368 _TH0	=	0x008c
                     008D   369 _TH1	=	0x008d
                     008E   370 _CKCON	=	0x008e
                     0090   371 _IOB	=	0x0090
                     0091   372 _EXIF	=	0x0091
                     0092   373 __XPAGE	=	0x0092
                     0098   374 _SCON0	=	0x0098
                     0099   375 _SBUF0	=	0x0099
                     009A   376 _AUTOPTRH1	=	0x009a
                     009B   377 _AUTOPTRL1	=	0x009b
                     009D   378 _AUTOPTRH2	=	0x009d
                     009E   379 _AUTOPTRL2	=	0x009e
                     00A0   380 _IOC	=	0x00a0
                     00A1   381 _INT2CLR	=	0x00a1
                     00A2   382 _INT4CLR	=	0x00a2
                     00A8   383 _IE	=	0x00a8
                     00AA   384 _EP2468STAT	=	0x00aa
                     00AB   385 _EP24FIFOFLGS	=	0x00ab
                     00AC   386 _EP68FIFOFLGS	=	0x00ac
                     00AF   387 _AUTOPTRSETUP	=	0x00af
                     00B0   388 _IOD	=	0x00b0
                     00B1   389 _IOE	=	0x00b1
                     00B2   390 _OEA	=	0x00b2
                     00B3   391 _OEB	=	0x00b3
                     00B4   392 _OEC	=	0x00b4
                     00B5   393 _OED	=	0x00b5
                     00B6   394 _OEE	=	0x00b6
                     00B8   395 _IP	=	0x00b8
                     00BA   396 _EP01STAT	=	0x00ba
                     00BB   397 _GPIFTRIG	=	0x00bb
                     00BD   398 _GPIFSGLDATH	=	0x00bd
                     00BE   399 _GPIFSGLDATLX	=	0x00be
                     00BF   400 _GPIFSGLDATLNOX	=	0x00bf
                     00C0   401 _SCON1	=	0x00c0
                     00C1   402 _SBUF1	=	0x00c1
                     00C8   403 _T2CON	=	0x00c8
                     00CA   404 _RCAP2L	=	0x00ca
                     00CB   405 _RCAP2H	=	0x00cb
                     00CC   406 _TL2	=	0x00cc
                     00CD   407 _TH2	=	0x00cd
                     00D0   408 _PSW	=	0x00d0
                     00D8   409 _EICON	=	0x00d8
                     00E0   410 _ACC	=	0x00e0
                     00E8   411 _EIE	=	0x00e8
                     00F0   412 _B	=	0x00f0
                     00F8   413 _EIP	=	0x00f8
                            414 ;--------------------------------------------------------
                            415 ; special function bits
                            416 ;--------------------------------------------------------
                            417 	.area RSEG    (ABS,DATA)
   0000                     418 	.org 0x0000
                     0080   419 _PA0	=	0x0080
                     0081   420 _PA1	=	0x0081
                     0082   421 _PA2	=	0x0082
                     0083   422 _PA3	=	0x0083
                     0084   423 _PA4	=	0x0084
                     0085   424 _PA5	=	0x0085
                     0086   425 _PA6	=	0x0086
                     0087   426 _PA7	=	0x0087
                     0088   427 _IT0	=	0x0088
                     0089   428 _IE0	=	0x0089
                     008A   429 _IT1	=	0x008a
                     008B   430 _IE1	=	0x008b
                     008C   431 _TR0	=	0x008c
                     008D   432 _TF0	=	0x008d
                     008E   433 _TR1	=	0x008e
                     008F   434 _TF1	=	0x008f
                     0090   435 _PB0	=	0x0090
                     0091   436 _PB1	=	0x0091
                     0092   437 _PB2	=	0x0092
                     0093   438 _PB3	=	0x0093
                     0094   439 _PB4	=	0x0094
                     0095   440 _PB5	=	0x0095
                     0096   441 _PB6	=	0x0096
                     0097   442 _PB7	=	0x0097
                     0098   443 _RI	=	0x0098
                     0099   444 _TI	=	0x0099
                     009A   445 _RB8	=	0x009a
                     009B   446 _TB8	=	0x009b
                     009C   447 _REN	=	0x009c
                     009D   448 _SM2	=	0x009d
                     009E   449 _SM1	=	0x009e
                     009F   450 _SM0	=	0x009f
                     00A0   451 _PC0	=	0x00a0
                     00A1   452 _PC1	=	0x00a1
                     00A2   453 _PC2	=	0x00a2
                     00A3   454 _PC3	=	0x00a3
                     00A4   455 _PC4	=	0x00a4
                     00A5   456 _PC5	=	0x00a5
                     00A6   457 _PC6	=	0x00a6
                     00A7   458 _PC7	=	0x00a7
                     00A8   459 _EX0	=	0x00a8
                     00A9   460 _ET0	=	0x00a9
                     00AA   461 _EX1	=	0x00aa
                     00AB   462 _ET1	=	0x00ab
                     00AC   463 _ES0	=	0x00ac
                     00AD   464 _ET2	=	0x00ad
                     00AE   465 _ES1	=	0x00ae
                     00AF   466 _EA	=	0x00af
                     00B0   467 _PD0	=	0x00b0
                     00B1   468 _PD1	=	0x00b1
                     00B2   469 _PD2	=	0x00b2
                     00B3   470 _PD3	=	0x00b3
                     00B4   471 _PD4	=	0x00b4
                     00B5   472 _PD5	=	0x00b5
                     00B6   473 _PD6	=	0x00b6
                     00B7   474 _PD7	=	0x00b7
                     00B8   475 _PX0	=	0x00b8
                     00B9   476 _PT0	=	0x00b9
                     00BA   477 _PX1	=	0x00ba
                     00BB   478 _PT1	=	0x00bb
                     00BC   479 _PS0	=	0x00bc
                     00BD   480 _PT2	=	0x00bd
                     00BE   481 _PS1	=	0x00be
                     00C0   482 _RI1	=	0x00c0
                     00C1   483 _TI1	=	0x00c1
                     00C2   484 _RB81	=	0x00c2
                     00C3   485 _TB81	=	0x00c3
                     00C4   486 _REN1	=	0x00c4
                     00C5   487 _SM21	=	0x00c5
                     00C6   488 _SM11	=	0x00c6
                     00C7   489 _SM01	=	0x00c7
                     00C8   490 _CP_RL2	=	0x00c8
                     00C9   491 _C_T2	=	0x00c9
                     00CA   492 _TR2	=	0x00ca
                     00CB   493 _EXEN2	=	0x00cb
                     00CC   494 _TCLK	=	0x00cc
                     00CD   495 _RCLK	=	0x00cd
                     00CE   496 _EXF2	=	0x00ce
                     00CF   497 _TF2	=	0x00cf
                     00D0   498 _P	=	0x00d0
                     00D1   499 _FL	=	0x00d1
                     00D2   500 _OV	=	0x00d2
                     00D3   501 _RS0	=	0x00d3
                     00D4   502 _RS1	=	0x00d4
                     00D5   503 _F0	=	0x00d5
                     00D6   504 _AC	=	0x00d6
                     00D7   505 _CY	=	0x00d7
                     00DB   506 _INT6	=	0x00db
                     00DC   507 _RESI	=	0x00dc
                     00DD   508 _ERESI	=	0x00dd
                     00DF   509 _SMOD1	=	0x00df
                     00E8   510 _EUSB	=	0x00e8
                     00E9   511 _EI2C	=	0x00e9
                     00EA   512 _EIEX4	=	0x00ea
                     00EB   513 _EIEX5	=	0x00eb
                     00EC   514 _EIEX6	=	0x00ec
                     00F8   515 _PUSB	=	0x00f8
                     00F9   516 _PI2C	=	0x00f9
                     00FA   517 _EIPX4	=	0x00fa
                     00FB   518 _EIPX5	=	0x00fb
                     00FC   519 _EIPX6	=	0x00fc
                            520 ;--------------------------------------------------------
                            521 ; overlayable register banks
                            522 ;--------------------------------------------------------
                            523 	.area REG_BANK_0	(REL,OVR,DATA)
   0000                     524 	.ds 8
                            525 ;--------------------------------------------------------
                            526 ; internal ram data
                            527 ;--------------------------------------------------------
                            528 	.area DSEG    (DATA)
   0008                     529 _Initialize_i_1_3:
   0008                     530 	.ds 2
   000A                     531 _ProcessEP1Data_i_1_5:
   000A                     532 	.ds 2
                            533 ;--------------------------------------------------------
                            534 ; overlayable items in internal ram 
                            535 ;--------------------------------------------------------
                            536 ;--------------------------------------------------------
                            537 ; Stack segment in internal ram 
                            538 ;--------------------------------------------------------
                            539 	.area	SSEG	(DATA)
   000C                     540 __start__stack:
   000C                     541 	.ds	1
                            542 
                            543 ;--------------------------------------------------------
                            544 ; indirectly addressable internal ram data
                            545 ;--------------------------------------------------------
                            546 	.area ISEG    (DATA)
                            547 ;--------------------------------------------------------
                            548 ; absolute internal ram data
                            549 ;--------------------------------------------------------
                            550 	.area IABS    (ABS,DATA)
                            551 	.area IABS    (ABS,DATA)
                            552 ;--------------------------------------------------------
                            553 ; bit data
                            554 ;--------------------------------------------------------
                            555 	.area BSEG    (BIT)
                            556 ;--------------------------------------------------------
                            557 ; paged external ram data
                            558 ;--------------------------------------------------------
                            559 	.area PSEG    (PAG,XDATA)
                            560 ;--------------------------------------------------------
                            561 ; external ram data
                            562 ;--------------------------------------------------------
                            563 	.area XSEG    (XDATA)
                     E400   564 _GPIF_WAVE_DATA	=	0xe400
                     E480   565 _RES_WAVEDATA_END	=	0xe480
                     E600   566 _CPUCS	=	0xe600
                     E601   567 _IFCONFIG	=	0xe601
                     E602   568 _PINFLAGSAB	=	0xe602
                     E603   569 _PINFLAGSCD	=	0xe603
                     E604   570 _FIFORESET	=	0xe604
                     E605   571 _BREAKPT	=	0xe605
                     E606   572 _BPADDRH	=	0xe606
                     E607   573 _BPADDRL	=	0xe607
                     E608   574 _UART230	=	0xe608
                     E609   575 _FIFOPINPOLAR	=	0xe609
                     E60A   576 _REVID	=	0xe60a
                     E60B   577 _REVCTL	=	0xe60b
                     E610   578 _EP1OUTCFG	=	0xe610
                     E611   579 _EP1INCFG	=	0xe611
                     E612   580 _EP2CFG	=	0xe612
                     E613   581 _EP4CFG	=	0xe613
                     E614   582 _EP6CFG	=	0xe614
                     E615   583 _EP8CFG	=	0xe615
                     E618   584 _EP2FIFOCFG	=	0xe618
                     E619   585 _EP4FIFOCFG	=	0xe619
                     E61A   586 _EP6FIFOCFG	=	0xe61a
                     E61B   587 _EP8FIFOCFG	=	0xe61b
                     E620   588 _EP2AUTOINLENH	=	0xe620
                     E621   589 _EP2AUTOINLENL	=	0xe621
                     E622   590 _EP4AUTOINLENH	=	0xe622
                     E623   591 _EP4AUTOINLENL	=	0xe623
                     E624   592 _EP6AUTOINLENH	=	0xe624
                     E625   593 _EP6AUTOINLENL	=	0xe625
                     E626   594 _EP8AUTOINLENH	=	0xe626
                     E627   595 _EP8AUTOINLENL	=	0xe627
                     E630   596 _EP2FIFOPFH	=	0xe630
                     E631   597 _EP2FIFOPFL	=	0xe631
                     E632   598 _EP4FIFOPFH	=	0xe632
                     E633   599 _EP4FIFOPFL	=	0xe633
                     E634   600 _EP6FIFOPFH	=	0xe634
                     E635   601 _EP6FIFOPFL	=	0xe635
                     E636   602 _EP8FIFOPFH	=	0xe636
                     E637   603 _EP8FIFOPFL	=	0xe637
                     E640   604 _EP2ISOINPKTS	=	0xe640
                     E641   605 _EP4ISOINPKTS	=	0xe641
                     E642   606 _EP6ISOINPKTS	=	0xe642
                     E643   607 _EP8ISOINPKTS	=	0xe643
                     E648   608 _INPKTEND	=	0xe648
                     E649   609 _OUTPKTEND	=	0xe649
                     E650   610 _EP2FIFOIE	=	0xe650
                     E651   611 _EP2FIFOIRQ	=	0xe651
                     E652   612 _EP4FIFOIE	=	0xe652
                     E653   613 _EP4FIFOIRQ	=	0xe653
                     E654   614 _EP6FIFOIE	=	0xe654
                     E655   615 _EP6FIFOIRQ	=	0xe655
                     E656   616 _EP8FIFOIE	=	0xe656
                     E657   617 _EP8FIFOIRQ	=	0xe657
                     E658   618 _IBNIE	=	0xe658
                     E659   619 _IBNIRQ	=	0xe659
                     E65A   620 _NAKIE	=	0xe65a
                     E65B   621 _NAKIRQ	=	0xe65b
                     E65C   622 _USBIE	=	0xe65c
                     E65D   623 _USBIRQ	=	0xe65d
                     E65E   624 _EPIE	=	0xe65e
                     E65F   625 _EPIRQ	=	0xe65f
                     E660   626 _GPIFIE	=	0xe660
                     E661   627 _GPIFIRQ	=	0xe661
                     E662   628 _USBERRIE	=	0xe662
                     E663   629 _USBERRIRQ	=	0xe663
                     E664   630 _ERRCNTLIM	=	0xe664
                     E665   631 _CLRERRCNT	=	0xe665
                     E666   632 _INT2IVEC	=	0xe666
                     E667   633 _INT4IVEC	=	0xe667
                     E668   634 _INTSETUP	=	0xe668
                     E670   635 _PORTACFG	=	0xe670
                     E671   636 _PORTCCFG	=	0xe671
                     E672   637 _PORTECFG	=	0xe672
                     E678   638 _I2CS	=	0xe678
                     E679   639 _I2DAT	=	0xe679
                     E67A   640 _I2CTL	=	0xe67a
                     E67B   641 _XAUTODAT1	=	0xe67b
                     E67C   642 _XAUTODAT2	=	0xe67c
                     E680   643 _USBCS	=	0xe680
                     E681   644 _SUSPEND	=	0xe681
                     E682   645 _WAKEUPCS	=	0xe682
                     E683   646 _TOGCTL	=	0xe683
                     E684   647 _USBFRAMEH	=	0xe684
                     E685   648 _USBFRAMEL	=	0xe685
                     E686   649 _MICROFRAME	=	0xe686
                     E687   650 _FNADDR	=	0xe687
                     E68A   651 _EP0BCH	=	0xe68a
                     E68B   652 _EP0BCL	=	0xe68b
                     E68D   653 _EP1OUTBC	=	0xe68d
                     E68F   654 _EP1INBC	=	0xe68f
                     E690   655 _EP2BCH	=	0xe690
                     E691   656 _EP2BCL	=	0xe691
                     E694   657 _EP4BCH	=	0xe694
                     E695   658 _EP4BCL	=	0xe695
                     E698   659 _EP6BCH	=	0xe698
                     E699   660 _EP6BCL	=	0xe699
                     E69C   661 _EP8BCH	=	0xe69c
                     E69D   662 _EP8BCL	=	0xe69d
                     E6A0   663 _EP0CS	=	0xe6a0
                     E6A1   664 _EP1OUTCS	=	0xe6a1
                     E6A2   665 _EP1INCS	=	0xe6a2
                     E6A3   666 _EP2CS	=	0xe6a3
                     E6A4   667 _EP4CS	=	0xe6a4
                     E6A5   668 _EP6CS	=	0xe6a5
                     E6A6   669 _EP8CS	=	0xe6a6
                     E6A7   670 _EP2FIFOFLGS	=	0xe6a7
                     E6A8   671 _EP4FIFOFLGS	=	0xe6a8
                     E6A9   672 _EP6FIFOFLGS	=	0xe6a9
                     E6AA   673 _EP8FIFOFLGS	=	0xe6aa
                     E6AB   674 _EP2FIFOBCH	=	0xe6ab
                     E6AC   675 _EP2FIFOBCL	=	0xe6ac
                     E6AD   676 _EP4FIFOBCH	=	0xe6ad
                     E6AE   677 _EP4FIFOBCL	=	0xe6ae
                     E6AF   678 _EP6FIFOBCH	=	0xe6af
                     E6B0   679 _EP6FIFOBCL	=	0xe6b0
                     E6B1   680 _EP8FIFOBCH	=	0xe6b1
                     E6B2   681 _EP8FIFOBCL	=	0xe6b2
                     E6B3   682 _SUDPTRH	=	0xe6b3
                     E6B4   683 _SUDPTRL	=	0xe6b4
                     E6B5   684 _SUDPTRCTL	=	0xe6b5
                     E6B8   685 _SETUPDAT	=	0xe6b8
                     E6C0   686 _GPIFWFSELECT	=	0xe6c0
                     E6C1   687 _GPIFIDLECS	=	0xe6c1
                     E6C2   688 _GPIFIDLECTL	=	0xe6c2
                     E6C3   689 _GPIFCTLCFG	=	0xe6c3
                     E6C4   690 _GPIFADRH	=	0xe6c4
                     E6C5   691 _GPIFADRL	=	0xe6c5
                     E6CE   692 _GPIFTCB3	=	0xe6ce
                     E6CF   693 _GPIFTCB2	=	0xe6cf
                     E6D0   694 _GPIFTCB1	=	0xe6d0
                     E6D1   695 _GPIFTCB0	=	0xe6d1
                     E6D2   696 _EP2GPIFFLGSEL	=	0xe6d2
                     E6D3   697 _EP2GPIFPFSTOP	=	0xe6d3
                     E6D4   698 _EP2GPIFTRIG	=	0xe6d4
                     E6DA   699 _EP4GPIFFLGSEL	=	0xe6da
                     E6DB   700 _EP4GPIFPFSTOP	=	0xe6db
                     E6DC   701 _EP4GPIFTRIG	=	0xe6dc
                     E6E2   702 _EP6GPIFFLGSEL	=	0xe6e2
                     E6E3   703 _EP6GPIFPFSTOP	=	0xe6e3
                     E6E4   704 _EP6GPIFTRIG	=	0xe6e4
                     E6EA   705 _EP8GPIFFLGSEL	=	0xe6ea
                     E6EB   706 _EP8GPIFPFSTOP	=	0xe6eb
                     E6EC   707 _EP8GPIFTRIG	=	0xe6ec
                     E6F0   708 _XGPIFSGLDATH	=	0xe6f0
                     E6F1   709 _XGPIFSGLDATLX	=	0xe6f1
                     E6F2   710 _XGPIFSGLDATLNOX	=	0xe6f2
                     E6F3   711 _GPIFREADYCFG	=	0xe6f3
                     E6F4   712 _GPIFREADYSTAT	=	0xe6f4
                     E6F5   713 _GPIFABORT	=	0xe6f5
                     E6C6   714 _FLOWSTATE	=	0xe6c6
                     E6C7   715 _FLOWLOGIC	=	0xe6c7
                     E6C8   716 _FLOWEQ0CTL	=	0xe6c8
                     E6C9   717 _FLOWEQ1CTL	=	0xe6c9
                     E6CA   718 _FLOWHOLDOFF	=	0xe6ca
                     E6CB   719 _FLOWSTB	=	0xe6cb
                     E6CC   720 _FLOWSTBEDGE	=	0xe6cc
                     E6CD   721 _FLOWSTBHPERIOD	=	0xe6cd
                     E60C   722 _GPIFHOLDAMOUNT	=	0xe60c
                     E67D   723 _UDMACRCH	=	0xe67d
                     E67E   724 _UDMACRCL	=	0xe67e
                     E67F   725 _UDMACRCQUAL	=	0xe67f
                     E740   726 _EP0BUF	=	0xe740
                     E780   727 _EP1OUTBUF	=	0xe780
                     E7C0   728 _EP1INBUF	=	0xe7c0
                     F000   729 _EP2FIFOBUF	=	0xf000
                     F400   730 _EP4FIFOBUF	=	0xf400
                     F800   731 _EP6FIFOBUF	=	0xf800
                     FC00   732 _EP8FIFOBUF	=	0xfc00
                     E628   733 _ECCCFG	=	0xe628
                     E629   734 _ECCRESET	=	0xe629
                     E62A   735 _ECC1B0	=	0xe62a
                     E62B   736 _ECC1B1	=	0xe62b
                     E62C   737 _ECC1B2	=	0xe62c
                     E62D   738 _ECC2B0	=	0xe62d
                     E62E   739 _ECC2B1	=	0xe62e
                     E62F   740 _ECC2B2	=	0xe62f
                     E50D   741 _GPCR2	=	0xe50d
                            742 ;--------------------------------------------------------
                            743 ; absolute external ram data
                            744 ;--------------------------------------------------------
                            745 	.area XABS    (ABS,XDATA)
                            746 ;--------------------------------------------------------
                            747 ; external initialized ram data
                            748 ;--------------------------------------------------------
                            749 	.area XISEG   (XDATA)
                            750 	.area HOME    (CODE)
                            751 	.area GSINIT0 (CODE)
                            752 	.area GSINIT1 (CODE)
                            753 	.area GSINIT2 (CODE)
                            754 	.area GSINIT3 (CODE)
                            755 	.area GSINIT4 (CODE)
                            756 	.area GSINIT5 (CODE)
                            757 	.area GSINIT  (CODE)
                            758 	.area GSFINAL (CODE)
                            759 	.area CSEG    (CODE)
                            760 ;--------------------------------------------------------
                            761 ; interrupt vector 
                            762 ;--------------------------------------------------------
                            763 	.area HOME    (CODE)
   0000                     764 __interrupt_vect:
   0000 02 00 06      [24]  765 	ljmp	__sdcc_gsinit_startup
                            766 ;--------------------------------------------------------
                            767 ; global & static initialisations
                            768 ;--------------------------------------------------------
                            769 	.area HOME    (CODE)
                            770 	.area GSINIT  (CODE)
                            771 	.area GSFINAL (CODE)
                            772 	.area GSINIT  (CODE)
                            773 	.globl __sdcc_gsinit_startup
                            774 	.globl __sdcc_program_startup
                            775 	.globl __start__stack
                            776 	.globl __mcs51_genXINIT
                            777 	.globl __mcs51_genXRAMCLEAR
                            778 	.globl __mcs51_genRAMCLEAR
                            779 	.area GSFINAL (CODE)
   005F 02 00 03      [24]  780 	ljmp	__sdcc_program_startup
                            781 ;--------------------------------------------------------
                            782 ; Home
                            783 ;--------------------------------------------------------
                            784 	.area HOME    (CODE)
                            785 	.area HOME    (CODE)
   0003                     786 __sdcc_program_startup:
   0003 02 02 04      [24]  787 	ljmp	_main
                            788 ;	return from main will return to caller
                            789 ;--------------------------------------------------------
                            790 ; code
                            791 ;--------------------------------------------------------
                            792 	.area CSEG    (CODE)
                            793 ;------------------------------------------------------------
                            794 ;Allocation info for local variables in function 'ResetFifos'
                            795 ;------------------------------------------------------------
                            796 ;	fx2bridge.c:27: void ResetFifos() {
                            797 ;	-----------------------------------------
                            798 ;	 function ResetFifos
                            799 ;	-----------------------------------------
   0062                     800 _ResetFifos:
                     0007   801 	ar7 = 0x07
                     0006   802 	ar6 = 0x06
                     0005   803 	ar5 = 0x05
                     0004   804 	ar4 = 0x04
                     0003   805 	ar3 = 0x03
                     0002   806 	ar2 = 0x02
                     0001   807 	ar1 = 0x01
                     0000   808 	ar0 = 0x00
                            809 ;	fx2bridge.c:28: FIFORESET = 0x80;  SYNCDELAY;  // NAK all requests from host. 
   0062 90 E6 04      [24]  810 	mov	dptr,#_FIFORESET
   0065 74 80         [12]  811 	mov	a,#0x80
   0067 F0            [24]  812 	movx	@dptr,a
   0068 00            [12]  813 	nop 
   0069 00            [12]  814 	nop 
   006A 00            [12]  815 	nop 
   006B 00            [12]  816 	nop 
                            817 ;	fx2bridge.c:29: FIFORESET = 0x82;  SYNCDELAY;  // Reset individual EP (2,4,6,8)
   006C 90 E6 04      [24]  818 	mov	dptr,#_FIFORESET
   006F 74 82         [12]  819 	mov	a,#0x82
   0071 F0            [24]  820 	movx	@dptr,a
   0072 00            [12]  821 	nop 
   0073 00            [12]  822 	nop 
   0074 00            [12]  823 	nop 
   0075 00            [12]  824 	nop 
                            825 ;	fx2bridge.c:30: FIFORESET = 0x86;  SYNCDELAY;
   0076 90 E6 04      [24]  826 	mov	dptr,#_FIFORESET
   0079 74 86         [12]  827 	mov	a,#0x86
   007B F0            [24]  828 	movx	@dptr,a
   007C 00            [12]  829 	nop 
   007D 00            [12]  830 	nop 
   007E 00            [12]  831 	nop 
   007F 00            [12]  832 	nop 
                            833 ;	fx2bridge.c:31: FIFORESET = 0x00;  SYNCDELAY;  // Resume normal operation. 
   0080 90 E6 04      [24]  834 	mov	dptr,#_FIFORESET
   0083 E4            [12]  835 	clr	a
   0084 F0            [24]  836 	movx	@dptr,a
   0085 00            [12]  837 	nop 
   0086 00            [12]  838 	nop 
   0087 00            [12]  839 	nop 
   0088 00            [12]  840 	nop 
                            841 ;	fx2bridge.c:34: EP2FIFOCFG = 0x00; SYNCDELAY;
   0089 90 E6 18      [24]  842 	mov	dptr,#_EP2FIFOCFG
   008C E4            [12]  843 	clr	a
   008D F0            [24]  844 	movx	@dptr,a
   008E 00            [12]  845 	nop 
   008F 00            [12]  846 	nop 
   0090 00            [12]  847 	nop 
   0091 00            [12]  848 	nop 
                            849 ;	fx2bridge.c:35: OUTPKTEND = 0x82;  SYNCDELAY;
   0092 90 E6 49      [24]  850 	mov	dptr,#_OUTPKTEND
   0095 74 82         [12]  851 	mov	a,#0x82
   0097 F0            [24]  852 	movx	@dptr,a
   0098 00            [12]  853 	nop 
   0099 00            [12]  854 	nop 
   009A 00            [12]  855 	nop 
   009B 00            [12]  856 	nop 
                            857 ;	fx2bridge.c:36: OUTPKTEND = 0x82;  SYNCDELAY;
   009C 90 E6 49      [24]  858 	mov	dptr,#_OUTPKTEND
   009F 74 82         [12]  859 	mov	a,#0x82
   00A1 F0            [24]  860 	movx	@dptr,a
   00A2 00            [12]  861 	nop 
   00A3 00            [12]  862 	nop 
   00A4 00            [12]  863 	nop 
   00A5 00            [12]  864 	nop 
                            865 ;	fx2bridge.c:37: OUTPKTEND = 0x82;  SYNCDELAY;
   00A6 90 E6 49      [24]  866 	mov	dptr,#_OUTPKTEND
   00A9 74 82         [12]  867 	mov	a,#0x82
   00AB F0            [24]  868 	movx	@dptr,a
   00AC 00            [12]  869 	nop 
   00AD 00            [12]  870 	nop 
   00AE 00            [12]  871 	nop 
   00AF 00            [12]  872 	nop 
                            873 ;	fx2bridge.c:38: OUTPKTEND = 0x82;  SYNCDELAY;
   00B0 90 E6 49      [24]  874 	mov	dptr,#_OUTPKTEND
   00B3 74 82         [12]  875 	mov	a,#0x82
   00B5 F0            [24]  876 	movx	@dptr,a
   00B6 00            [12]  877 	nop 
   00B7 00            [12]  878 	nop 
   00B8 00            [12]  879 	nop 
   00B9 00            [12]  880 	nop 
                            881 ;	fx2bridge.c:41: EP6FIFOCFG = 0x00; SYNCDELAY;
   00BA 90 E6 1A      [24]  882 	mov	dptr,#_EP6FIFOCFG
   00BD E4            [12]  883 	clr	a
   00BE F0            [24]  884 	movx	@dptr,a
   00BF 00            [12]  885 	nop 
   00C0 00            [12]  886 	nop 
   00C1 00            [12]  887 	nop 
   00C2 00            [12]  888 	nop 
                            889 ;	fx2bridge.c:42: OUTPKTEND = 0x86;  SYNCDELAY;
   00C3 90 E6 49      [24]  890 	mov	dptr,#_OUTPKTEND
   00C6 74 86         [12]  891 	mov	a,#0x86
   00C8 F0            [24]  892 	movx	@dptr,a
   00C9 00            [12]  893 	nop 
   00CA 00            [12]  894 	nop 
   00CB 00            [12]  895 	nop 
   00CC 00            [12]  896 	nop 
                            897 ;	fx2bridge.c:43: OUTPKTEND = 0x86;  SYNCDELAY;
   00CD 90 E6 49      [24]  898 	mov	dptr,#_OUTPKTEND
   00D0 74 86         [12]  899 	mov	a,#0x86
   00D2 F0            [24]  900 	movx	@dptr,a
   00D3 00            [12]  901 	nop 
   00D4 00            [12]  902 	nop 
   00D5 00            [12]  903 	nop 
   00D6 00            [12]  904 	nop 
                            905 ;	fx2bridge.c:44: OUTPKTEND = 0x86;  SYNCDELAY;
   00D7 90 E6 49      [24]  906 	mov	dptr,#_OUTPKTEND
   00DA 74 86         [12]  907 	mov	a,#0x86
   00DC F0            [24]  908 	movx	@dptr,a
   00DD 00            [12]  909 	nop 
   00DE 00            [12]  910 	nop 
   00DF 00            [12]  911 	nop 
   00E0 00            [12]  912 	nop 
                            913 ;	fx2bridge.c:45: OUTPKTEND = 0x86;  SYNCDELAY;
   00E1 90 E6 49      [24]  914 	mov	dptr,#_OUTPKTEND
   00E4 74 86         [12]  915 	mov	a,#0x86
   00E6 F0            [24]  916 	movx	@dptr,a
   00E7 00            [12]  917 	nop 
   00E8 00            [12]  918 	nop 
   00E9 00            [12]  919 	nop 
   00EA 00            [12]  920 	nop 
                            921 ;	fx2bridge.c:47: EP2FIFOCFG = 0x10; SYNCDELAY; //  AUTOOUT=1; byte-wide operation
   00EB 90 E6 18      [24]  922 	mov	dptr,#_EP2FIFOCFG
   00EE 74 10         [12]  923 	mov	a,#0x10
   00F0 F0            [24]  924 	movx	@dptr,a
   00F1 00            [12]  925 	nop 
   00F2 00            [12]  926 	nop 
   00F3 00            [12]  927 	nop 
   00F4 00            [12]  928 	nop 
                            929 ;	fx2bridge.c:48: EP6FIFOCFG = 0x0c; SYNCDELAY; //  AUTOIN=1; byte-wide operation
   00F5 90 E6 1A      [24]  930 	mov	dptr,#_EP6FIFOCFG
   00F8 74 0C         [12]  931 	mov	a,#0x0C
   00FA F0            [24]  932 	movx	@dptr,a
   00FB 00            [12]  933 	nop 
   00FC 00            [12]  934 	nop 
   00FD 00            [12]  935 	nop 
   00FE 00            [12]  936 	nop 
   00FF 22            [24]  937 	ret
                            938 ;------------------------------------------------------------
                            939 ;Allocation info for local variables in function 'Initialize'
                            940 ;------------------------------------------------------------
                            941 ;i                         Allocated with name '_Initialize_i_1_3'
                            942 ;------------------------------------------------------------
                            943 ;	fx2bridge.c:51: static void Initialize(void)
                            944 ;	-----------------------------------------
                            945 ;	 function Initialize
                            946 ;	-----------------------------------------
   0100                     947 _Initialize:
                            948 ;	fx2bridge.c:55: CPUCS=0x12;   // 48 MHz, CLKOUT output enabled. 
   0100 90 E6 00      [24]  949 	mov	dptr,#_CPUCS
   0103 74 12         [12]  950 	mov	a,#0x12
   0105 F0            [24]  951 	movx	@dptr,a
                            952 ;	fx2bridge.c:56: SYNCDELAY;
   0106 00            [12]  953 	nop 
   0107 00            [12]  954 	nop 
   0108 00            [12]  955 	nop 
   0109 00            [12]  956 	nop 
                            957 ;	fx2bridge.c:58: IFCONFIG=0xe3;  // Internal 48MHz IFCLK; IFCLK pin output enabled
   010A 90 E6 01      [24]  958 	mov	dptr,#_IFCONFIG
   010D 74 E3         [12]  959 	mov	a,#0xE3
   010F F0            [24]  960 	movx	@dptr,a
                            961 ;	fx2bridge.c:60: SYNCDELAY;
   0110 00            [12]  962 	nop 
   0111 00            [12]  963 	nop 
   0112 00            [12]  964 	nop 
   0113 00            [12]  965 	nop 
                            966 ;	fx2bridge.c:62: REVCTL=0x03;  // See TRM...
   0114 90 E6 0B      [24]  967 	mov	dptr,#_REVCTL
   0117 74 03         [12]  968 	mov	a,#0x03
   0119 F0            [24]  969 	movx	@dptr,a
                            970 ;	fx2bridge.c:63: SYNCDELAY;
   011A 00            [12]  971 	nop 
   011B 00            [12]  972 	nop 
   011C 00            [12]  973 	nop 
   011D 00            [12]  974 	nop 
                            975 ;	fx2bridge.c:65: PORTACFG &= ~0xC0;
   011E 90 E6 70      [24]  976 	mov	dptr,#_PORTACFG
   0121 E0            [24]  977 	movx	a,@dptr
   0122 FF            [12]  978 	mov	r7,a
   0123 54 3F         [12]  979 	anl	a,#0x3F
   0125 F0            [24]  980 	movx	@dptr,a
                            981 ;	fx2bridge.c:67: OEA = 0x80;	// PA7 is fpga reset pin
   0126 75 B2 80      [24]  982 	mov	_OEA,#0x80
                            983 ;	fx2bridge.c:68: IOA = 0x00;
   0129 75 80 00      [24]  984 	mov	_IOA,#0x00
                            985 ;	fx2bridge.c:70: PINFLAGSAB = 0x98;  // FLAGA = EP2 EF (empty flag); FLAGB = EP4 EF
   012C 90 E6 02      [24]  986 	mov	dptr,#_PINFLAGSAB
   012F 74 98         [12]  987 	mov	a,#0x98
   0131 F0            [24]  988 	movx	@dptr,a
                            989 ;	fx2bridge.c:71: SYNCDELAY;
   0132 00            [12]  990 	nop 
   0133 00            [12]  991 	nop 
   0134 00            [12]  992 	nop 
   0135 00            [12]  993 	nop 
                            994 ;	fx2bridge.c:72: PINFLAGSCD = 0xfe;  // FLAGC = EP6 FF (full flag); FLAGD = EP8 FF
   0136 90 E6 03      [24]  995 	mov	dptr,#_PINFLAGSCD
   0139 74 FE         [12]  996 	mov	a,#0xFE
   013B F0            [24]  997 	movx	@dptr,a
                            998 ;	fx2bridge.c:73: SYNCDELAY;
   013C 00            [12]  999 	nop 
   013D 00            [12] 1000 	nop 
   013E 00            [12] 1001 	nop 
   013F 00            [12] 1002 	nop 
                           1003 ;	fx2bridge.c:75: EP1INCFG=0xa0;		// EP1 bulk IN  
   0140 90 E6 11      [24] 1004 	mov	dptr,#_EP1INCFG
   0143 74 A0         [12] 1005 	mov	a,#0xA0
   0145 F0            [24] 1006 	movx	@dptr,a
                           1007 ;	fx2bridge.c:76: EP1OUTCFG=0xa0;		// EP1 bulk OUT
   0146 90 E6 10      [24] 1008 	mov	dptr,#_EP1OUTCFG
   0149 74 A0         [12] 1009 	mov	a,#0xA0
   014B F0            [24] 1010 	movx	@dptr,a
                           1011 ;	fx2bridge.c:77: EP2CFG=0xa0;  // 1010 0010 (bulk OUT, 512 bytes, double-buffered)
   014C 90 E6 12      [24] 1012 	mov	dptr,#_EP2CFG
   014F 74 A0         [12] 1013 	mov	a,#0xA0
   0151 F0            [24] 1014 	movx	@dptr,a
                           1015 ;	fx2bridge.c:78: EP6CFG=0xe0;  // 1110 0010 (bulk IN, 512 bytes, double-buffered)
   0152 90 E6 14      [24] 1016 	mov	dptr,#_EP6CFG
   0155 74 E0         [12] 1017 	mov	a,#0xE0
   0157 F0            [24] 1018 	movx	@dptr,a
                           1019 ;	fx2bridge.c:79: SYNCDELAY;
   0158 00            [12] 1020 	nop 
   0159 00            [12] 1021 	nop 
   015A 00            [12] 1022 	nop 
   015B 00            [12] 1023 	nop 
                           1024 ;	fx2bridge.c:81: ResetFifos();
   015C 12 00 62      [24] 1025 	lcall	_ResetFifos
                           1026 ;	fx2bridge.c:84: EP1OUTBC=0xff; // arm endpoint 1 for OUT (host->device) transfers
   015F 90 E6 8D      [24] 1027 	mov	dptr,#_EP1OUTBC
   0162 74 FF         [12] 1028 	mov	a,#0xFF
   0164 F0            [24] 1029 	movx	@dptr,a
                           1030 ;	fx2bridge.c:85: SYNCDELAY;
   0165 00            [12] 1031 	nop 
   0166 00            [12] 1032 	nop 
   0167 00            [12] 1033 	nop 
   0168 00            [12] 1034 	nop 
                           1035 ;	fx2bridge.c:89: for (i=0; i<0x2000; i++) NOP;
   0169 E4            [12] 1036 	clr	a
   016A F5 08         [12] 1037 	mov	_Initialize_i_1_3,a
   016C F5 09         [12] 1038 	mov	(_Initialize_i_1_3 + 1),a
   016E                    1039 00103$:
   016E E5 09         [12] 1040 	mov	a,(_Initialize_i_1_3 + 1)
   0170 54 E0         [12] 1041 	anl	a,#0xE0
   0172 60 02         [24] 1042 	jz	00114$
   0174 80 0E         [24] 1043 	sjmp	00101$
   0176                    1044 00114$:
   0176 00            [12] 1045 	nop 
   0177 74 01         [12] 1046 	mov	a,#0x01
   0179 25 08         [12] 1047 	add	a,_Initialize_i_1_3
   017B F5 08         [12] 1048 	mov	_Initialize_i_1_3,a
   017D E4            [12] 1049 	clr	a
   017E 35 09         [12] 1050 	addc	a,(_Initialize_i_1_3 + 1)
   0180 F5 09         [12] 1051 	mov	(_Initialize_i_1_3 + 1),a
   0182 80 EA         [24] 1052 	sjmp	00103$
   0184                    1053 00101$:
                           1054 ;	fx2bridge.c:90: IOA = 0x80;
   0184 75 80 80      [24] 1055 	mov	_IOA,#0x80
   0187 22            [24] 1056 	ret
                           1057 ;------------------------------------------------------------
                           1058 ;Allocation info for local variables in function 'ProcessEP1Data'
                           1059 ;------------------------------------------------------------
                           1060 ;i                         Allocated with name '_ProcessEP1Data_i_1_5'
                           1061 ;cmd                       Allocated to registers r7 
                           1062 ;------------------------------------------------------------
                           1063 ;	fx2bridge.c:95: static void ProcessEP1Data(void)
                           1064 ;	-----------------------------------------
                           1065 ;	 function ProcessEP1Data
                           1066 ;	-----------------------------------------
   0188                    1067 _ProcessEP1Data:
                           1068 ;	fx2bridge.c:98: unsigned char cmd = *EP1OUTBUF;
   0188 90 E7 80      [24] 1069 	mov	dptr,#_EP1OUTBUF
   018B E0            [24] 1070 	movx	a,@dptr
   018C FF            [12] 1071 	mov	r7,a
                           1072 ;	fx2bridge.c:100: switch(cmd) {
   018D BF C0 02      [24] 1073 	cjne	r7,#0xC0,00133$
   0190 80 05         [24] 1074 	sjmp	00101$
   0192                    1075 00133$:
                           1076 ;	fx2bridge.c:101: case CMD_POLL_FW:
   0192 BF C1 68      [24] 1077 	cjne	r7,#0xC1,00106$
   0195 80 12         [24] 1078 	sjmp	00102$
   0197                    1079 00101$:
                           1080 ;	fx2bridge.c:102: *EP1INBUF = CMD_FW_OK;
   0197 90 E7 C0      [24] 1081 	mov	dptr,#_EP1INBUF
   019A 74 A0         [12] 1082 	mov	a,#0xA0
   019C F0            [24] 1083 	movx	@dptr,a
                           1084 ;	fx2bridge.c:103: SYNCDELAY;
   019D 00            [12] 1085 	nop 
   019E 00            [12] 1086 	nop 
   019F 00            [12] 1087 	nop 
   01A0 00            [12] 1088 	nop 
                           1089 ;	fx2bridge.c:104: EP1INBC = 1;
   01A1 90 E6 8F      [24] 1090 	mov	dptr,#_EP1INBC
   01A4 74 01         [12] 1091 	mov	a,#0x01
   01A6 F0            [24] 1092 	movx	@dptr,a
                           1093 ;	fx2bridge.c:105: break;
                           1094 ;	fx2bridge.c:107: case CMD_RESET_FPGA:
   01A7 80 54         [24] 1095 	sjmp	00106$
   01A9                    1096 00102$:
                           1097 ;	fx2bridge.c:108: IOA = 0x00;
                           1098 ;	fx2bridge.c:109: for (i=0; i<2000; i++) NOP;
   01A9 E4            [12] 1099 	clr	a
   01AA F5 80         [12] 1100 	mov	_IOA,a
   01AC F5 0A         [12] 1101 	mov	_ProcessEP1Data_i_1_5,a
   01AE F5 0B         [12] 1102 	mov	(_ProcessEP1Data_i_1_5 + 1),a
   01B0                    1103 00108$:
   01B0 C3            [12] 1104 	clr	c
   01B1 E5 0A         [12] 1105 	mov	a,_ProcessEP1Data_i_1_5
   01B3 94 D0         [12] 1106 	subb	a,#0xD0
   01B5 E5 0B         [12] 1107 	mov	a,(_ProcessEP1Data_i_1_5 + 1)
   01B7 94 07         [12] 1108 	subb	a,#0x07
   01B9 50 0E         [24] 1109 	jnc	00103$
   01BB 00            [12] 1110 	nop 
   01BC 74 01         [12] 1111 	mov	a,#0x01
   01BE 25 0A         [12] 1112 	add	a,_ProcessEP1Data_i_1_5
   01C0 F5 0A         [12] 1113 	mov	_ProcessEP1Data_i_1_5,a
   01C2 E4            [12] 1114 	clr	a
   01C3 35 0B         [12] 1115 	addc	a,(_ProcessEP1Data_i_1_5 + 1)
   01C5 F5 0B         [12] 1116 	mov	(_ProcessEP1Data_i_1_5 + 1),a
   01C7 80 E7         [24] 1117 	sjmp	00108$
   01C9                    1118 00103$:
                           1119 ;	fx2bridge.c:110: IOA = 0x80;
   01C9 75 80 80      [24] 1120 	mov	_IOA,#0x80
                           1121 ;	fx2bridge.c:111: ResetFifos();
   01CC 12 00 62      [24] 1122 	lcall	_ResetFifos
                           1123 ;	fx2bridge.c:112: for (i=0; i<2000; i++) NOP;
   01CF E4            [12] 1124 	clr	a
   01D0 F5 0A         [12] 1125 	mov	_ProcessEP1Data_i_1_5,a
   01D2 F5 0B         [12] 1126 	mov	(_ProcessEP1Data_i_1_5 + 1),a
   01D4                    1127 00111$:
   01D4 C3            [12] 1128 	clr	c
   01D5 E5 0A         [12] 1129 	mov	a,_ProcessEP1Data_i_1_5
   01D7 94 D0         [12] 1130 	subb	a,#0xD0
   01D9 E5 0B         [12] 1131 	mov	a,(_ProcessEP1Data_i_1_5 + 1)
   01DB 94 07         [12] 1132 	subb	a,#0x07
   01DD 50 0E         [24] 1133 	jnc	00104$
   01DF 00            [12] 1134 	nop 
   01E0 74 01         [12] 1135 	mov	a,#0x01
   01E2 25 0A         [12] 1136 	add	a,_ProcessEP1Data_i_1_5
   01E4 F5 0A         [12] 1137 	mov	_ProcessEP1Data_i_1_5,a
   01E6 E4            [12] 1138 	clr	a
   01E7 35 0B         [12] 1139 	addc	a,(_ProcessEP1Data_i_1_5 + 1)
   01E9 F5 0B         [12] 1140 	mov	(_ProcessEP1Data_i_1_5 + 1),a
   01EB 80 E7         [24] 1141 	sjmp	00111$
   01ED                    1142 00104$:
                           1143 ;	fx2bridge.c:114: *EP1INBUF = CMD_ACK_RESET;
   01ED 90 E7 C0      [24] 1144 	mov	dptr,#_EP1INBUF
   01F0 74 A1         [12] 1145 	mov	a,#0xA1
   01F2 F0            [24] 1146 	movx	@dptr,a
                           1147 ;	fx2bridge.c:115: SYNCDELAY;
   01F3 00            [12] 1148 	nop 
   01F4 00            [12] 1149 	nop 
   01F5 00            [12] 1150 	nop 
   01F6 00            [12] 1151 	nop 
                           1152 ;	fx2bridge.c:116: EP1INBC = 1;
   01F7 90 E6 8F      [24] 1153 	mov	dptr,#_EP1INBC
   01FA 74 01         [12] 1154 	mov	a,#0x01
   01FC F0            [24] 1155 	movx	@dptr,a
                           1156 ;	fx2bridge.c:121: }
   01FD                    1157 00106$:
                           1158 ;	fx2bridge.c:124: EP1OUTBC=0xff; // re-arm endpoint 1
   01FD 90 E6 8D      [24] 1159 	mov	dptr,#_EP1OUTBC
   0200 74 FF         [12] 1160 	mov	a,#0xFF
   0202 F0            [24] 1161 	movx	@dptr,a
   0203 22            [24] 1162 	ret
                           1163 ;------------------------------------------------------------
                           1164 ;Allocation info for local variables in function 'main'
                           1165 ;------------------------------------------------------------
                           1166 ;	fx2bridge.c:128: void main(void)
                           1167 ;	-----------------------------------------
                           1168 ;	 function main
                           1169 ;	-----------------------------------------
   0204                    1170 _main:
                           1171 ;	fx2bridge.c:130: Initialize();
   0204 12 01 00      [24] 1172 	lcall	_Initialize
                           1173 ;	fx2bridge.c:134: while (1)
   0207                    1174 00104$:
                           1175 ;	fx2bridge.c:137: if (!(EP1OUTCS & (1<<1))) {
   0207 90 E6 A1      [24] 1176 	mov	dptr,#_EP1OUTCS
   020A E0            [24] 1177 	movx	a,@dptr
   020B FF            [12] 1178 	mov	r7,a
   020C 20 E1 F8      [24] 1179 	jb	acc.1,00104$
                           1180 ;	fx2bridge.c:138: ProcessEP1Data();
   020F 12 01 88      [24] 1181 	lcall	_ProcessEP1Data
   0212 80 F3         [24] 1182 	sjmp	00104$
                           1183 	.area CSEG    (CODE)
                           1184 	.area CONST   (CODE)
                           1185 	.area XINIT   (CODE)
                           1186 	.area CABS    (ABS,CODE)
