                              1 ;--------------------------------------------------------
                              2 ; File Created by SDCC : free open source ANSI-C Compiler
                              3 ; Version 3.3.0 #8604 (Sep  2 2013) (Linux)
                              4 ; This file was generated Thu May  8 18:45:16 2014
                              5 ;--------------------------------------------------------
                              6 	.module crc_a
                              7 	.optsdcc -mmcs51 --model-small
                              8 	
                              9 ;--------------------------------------------------------
                             10 ; Public variables in this module
                             11 ;--------------------------------------------------------
                             12 	.globl _UpdateCrc_PARM_2
                             13 	.globl _ComputeCrc_PARM_2
                             14 	.globl _UpdateCrc
                             15 	.globl _ComputeCrc
                             16 ;--------------------------------------------------------
                             17 ; special function registers
                             18 ;--------------------------------------------------------
                             19 	.area RSEG    (ABS,DATA)
   0000                      20 	.org 0x0000
                             21 ;--------------------------------------------------------
                             22 ; special function bits
                             23 ;--------------------------------------------------------
                             24 	.area RSEG    (ABS,DATA)
   0000                      25 	.org 0x0000
                             26 ;--------------------------------------------------------
                             27 ; overlayable register banks
                             28 ;--------------------------------------------------------
                             29 	.area REG_BANK_0	(REL,OVR,DATA)
   0000                      30 	.ds 8
                             31 ;--------------------------------------------------------
                             32 ; internal ram data
                             33 ;--------------------------------------------------------
                             34 	.area DSEG    (DATA)
   001C                      35 _ComputeCrc_PARM_2:
   001C                      36 	.ds 2
   001E                      37 _ComputeCrc_chBlock_1_6:
   001E                      38 	.ds 1
   001F                      39 _ComputeCrc_wCrc_1_6:
   001F                      40 	.ds 2
                             41 ;--------------------------------------------------------
                             42 ; overlayable items in internal ram 
                             43 ;--------------------------------------------------------
                             44 	.area	OSEG    (OVR,DATA)
   0021                      45 _UpdateCrc_PARM_2:
   0021                      46 	.ds 3
   0024                      47 _UpdateCrc_sloc0_1_0:
   0024                      48 	.ds 2
                             49 ;--------------------------------------------------------
                             50 ; indirectly addressable internal ram data
                             51 ;--------------------------------------------------------
                             52 	.area ISEG    (DATA)
                             53 ;--------------------------------------------------------
                             54 ; absolute internal ram data
                             55 ;--------------------------------------------------------
                             56 	.area IABS    (ABS,DATA)
                             57 	.area IABS    (ABS,DATA)
                             58 ;--------------------------------------------------------
                             59 ; bit data
                             60 ;--------------------------------------------------------
                             61 	.area BSEG    (BIT)
                             62 ;--------------------------------------------------------
                             63 ; paged external ram data
                             64 ;--------------------------------------------------------
                             65 	.area PSEG    (PAG,XDATA)
                             66 ;--------------------------------------------------------
                             67 ; external ram data
                             68 ;--------------------------------------------------------
                             69 	.area XSEG    (XDATA)
                             70 ;--------------------------------------------------------
                             71 ; absolute external ram data
                             72 ;--------------------------------------------------------
                             73 	.area XABS    (ABS,XDATA)
                             74 ;--------------------------------------------------------
                             75 ; external initialized ram data
                             76 ;--------------------------------------------------------
                             77 	.area XISEG   (XDATA)
                             78 	.area HOME    (CODE)
                             79 	.area GSINIT0 (CODE)
                             80 	.area GSINIT1 (CODE)
                             81 	.area GSINIT2 (CODE)
                             82 	.area GSINIT3 (CODE)
                             83 	.area GSINIT4 (CODE)
                             84 	.area GSINIT5 (CODE)
                             85 	.area GSINIT  (CODE)
                             86 	.area GSFINAL (CODE)
                             87 	.area CSEG    (CODE)
                             88 ;--------------------------------------------------------
                             89 ; global & static initialisations
                             90 ;--------------------------------------------------------
                             91 	.area HOME    (CODE)
                             92 	.area GSINIT  (CODE)
                             93 	.area GSFINAL (CODE)
                             94 	.area GSINIT  (CODE)
                             95 ;--------------------------------------------------------
                             96 ; Home
                             97 ;--------------------------------------------------------
                             98 	.area HOME    (CODE)
                             99 	.area HOME    (CODE)
                            100 ;--------------------------------------------------------
                            101 ; code
                            102 ;--------------------------------------------------------
                            103 	.area CSEG    (CODE)
                            104 ;------------------------------------------------------------
                            105 ;Allocation info for local variables in function 'UpdateCrc'
                            106 ;------------------------------------------------------------
                            107 ;lpwCrc                    Allocated with name '_UpdateCrc_PARM_2'
                            108 ;ch                        Allocated to registers r7 
                            109 ;sloc0                     Allocated with name '_UpdateCrc_sloc0_1_0'
                            110 ;------------------------------------------------------------
                            111 ;	crc_a.c:12: uint16_t UpdateCrc(unsigned char ch, uint16_t *lpwCrc)
                            112 ;	-----------------------------------------
                            113 ;	 function UpdateCrc
                            114 ;	-----------------------------------------
   094F                     115 _UpdateCrc:
                     0007   116 	ar7 = 0x07
                     0006   117 	ar6 = 0x06
                     0005   118 	ar5 = 0x05
                     0004   119 	ar4 = 0x04
                     0003   120 	ar3 = 0x03
                     0002   121 	ar2 = 0x02
                     0001   122 	ar1 = 0x01
                     0000   123 	ar0 = 0x00
   094F AF 82         [24]  124 	mov	r7,dpl
                            125 ;	crc_a.c:14: ch = (ch^(unsigned char)((*lpwCrc) & 0x00FF));
   0951 AC 21         [24]  126 	mov	r4,_UpdateCrc_PARM_2
   0953 AD 22         [24]  127 	mov	r5,(_UpdateCrc_PARM_2 + 1)
   0955 AE 23         [24]  128 	mov	r6,(_UpdateCrc_PARM_2 + 2)
   0957 8C 82         [24]  129 	mov	dpl,r4
   0959 8D 83         [24]  130 	mov	dph,r5
   095B 8E F0         [24]  131 	mov	b,r6
   095D 12 0C 0F      [24]  132 	lcall	__gptrget
   0960 FA            [12]  133 	mov	r2,a
   0961 A3            [24]  134 	inc	dptr
   0962 12 0C 0F      [24]  135 	lcall	__gptrget
   0965 FB            [12]  136 	mov	r3,a
   0966 8A 00         [24]  137 	mov	ar0,r2
   0968 E8            [12]  138 	mov	a,r0
   0969 62 07         [12]  139 	xrl	ar7,a
                            140 ;	crc_a.c:15: ch = (ch^(ch<<4));
   096B EF            [12]  141 	mov	a,r7
   096C C4            [12]  142 	swap	a
   096D 54 F0         [12]  143 	anl	a,#0xF0
   096F 62 07         [12]  144 	xrl	ar7,a
                            145 ;	crc_a.c:16: *lpwCrc = (*lpwCrc >> 8)^((uint16_t)ch << 8)^((uint16_t)ch<<3)^((uint16_t)ch>>4);
   0971 8B 24         [24]  146 	mov	_UpdateCrc_sloc0_1_0,r3
   0973 75 25 00      [24]  147 	mov	(_UpdateCrc_sloc0_1_0 + 1),#0x00
   0976 8F 01         [24]  148 	mov	ar1,r7
   0978 7F 00         [12]  149 	mov	r7,#0x00
   097A 89 03         [24]  150 	mov	ar3,r1
   097C E4            [12]  151 	clr	a
   097D 62 24         [12]  152 	xrl	_UpdateCrc_sloc0_1_0,a
   097F EB            [12]  153 	mov	a,r3
   0980 62 25         [12]  154 	xrl	(_UpdateCrc_sloc0_1_0 + 1),a
   0982 89 02         [24]  155 	mov	ar2,r1
   0984 EF            [12]  156 	mov	a,r7
   0985 C4            [12]  157 	swap	a
   0986 03            [12]  158 	rr	a
   0987 54 F8         [12]  159 	anl	a,#0xF8
   0989 CA            [12]  160 	xch	a,r2
   098A C4            [12]  161 	swap	a
   098B 03            [12]  162 	rr	a
   098C CA            [12]  163 	xch	a,r2
   098D 6A            [12]  164 	xrl	a,r2
   098E CA            [12]  165 	xch	a,r2
   098F 54 F8         [12]  166 	anl	a,#0xF8
   0991 CA            [12]  167 	xch	a,r2
   0992 6A            [12]  168 	xrl	a,r2
   0993 FB            [12]  169 	mov	r3,a
   0994 E5 24         [12]  170 	mov	a,_UpdateCrc_sloc0_1_0
   0996 62 02         [12]  171 	xrl	ar2,a
   0998 E5 25         [12]  172 	mov	a,(_UpdateCrc_sloc0_1_0 + 1)
   099A 62 03         [12]  173 	xrl	ar3,a
   099C EF            [12]  174 	mov	a,r7
   099D C4            [12]  175 	swap	a
   099E C9            [12]  176 	xch	a,r1
   099F C4            [12]  177 	swap	a
   09A0 54 0F         [12]  178 	anl	a,#0x0F
   09A2 69            [12]  179 	xrl	a,r1
   09A3 C9            [12]  180 	xch	a,r1
   09A4 54 0F         [12]  181 	anl	a,#0x0F
   09A6 C9            [12]  182 	xch	a,r1
   09A7 69            [12]  183 	xrl	a,r1
   09A8 C9            [12]  184 	xch	a,r1
   09A9 FF            [12]  185 	mov	r7,a
   09AA E9            [12]  186 	mov	a,r1
   09AB 62 02         [12]  187 	xrl	ar2,a
   09AD EF            [12]  188 	mov	a,r7
   09AE 62 03         [12]  189 	xrl	ar3,a
   09B0 8C 82         [24]  190 	mov	dpl,r4
   09B2 8D 83         [24]  191 	mov	dph,r5
   09B4 8E F0         [24]  192 	mov	b,r6
   09B6 EA            [12]  193 	mov	a,r2
   09B7 12 0B F4      [24]  194 	lcall	__gptrput
   09BA A3            [24]  195 	inc	dptr
   09BB EB            [12]  196 	mov	a,r3
   09BC 12 0B F4      [24]  197 	lcall	__gptrput
                            198 ;	crc_a.c:17: return(*lpwCrc);
   09BF 8A 82         [24]  199 	mov	dpl,r2
   09C1 8B 83         [24]  200 	mov	dph,r3
   09C3 22            [24]  201 	ret
                            202 ;------------------------------------------------------------
                            203 ;Allocation info for local variables in function 'ComputeCrc'
                            204 ;------------------------------------------------------------
                            205 ;Length                    Allocated with name '_ComputeCrc_PARM_2'
                            206 ;Data                      Allocated to registers r5 r6 r7 
                            207 ;chBlock                   Allocated with name '_ComputeCrc_chBlock_1_6'
                            208 ;wCrc                      Allocated with name '_ComputeCrc_wCrc_1_6'
                            209 ;------------------------------------------------------------
                            210 ;	crc_a.c:20: void ComputeCrc(char *Data, int Length) {
                            211 ;	-----------------------------------------
                            212 ;	 function ComputeCrc
                            213 ;	-----------------------------------------
   09C4                     214 _ComputeCrc:
   09C4 AD 82         [24]  215 	mov	r5,dpl
   09C6 AE 83         [24]  216 	mov	r6,dph
   09C8 AF F0         [24]  217 	mov	r7,b
                            218 ;	crc_a.c:23: wCrc = 0x6363; /* ITU-V.41 */
   09CA 75 1F 63      [24]  219 	mov	_ComputeCrc_wCrc_1_6,#0x63
   09CD 75 20 63      [24]  220 	mov	(_ComputeCrc_wCrc_1_6 + 1),#0x63
                            221 ;	crc_a.c:24: do {
   09D0 8D 02         [24]  222 	mov	ar2,r5
   09D2 8E 03         [24]  223 	mov	ar3,r6
   09D4 8F 04         [24]  224 	mov	ar4,r7
   09D6 A8 1C         [24]  225 	mov	r0,_ComputeCrc_PARM_2
   09D8 A9 1D         [24]  226 	mov	r1,(_ComputeCrc_PARM_2 + 1)
   09DA                     227 00101$:
                            228 ;	crc_a.c:25: chBlock = *Data++;
   09DA 8A 82         [24]  229 	mov	dpl,r2
   09DC 8B 83         [24]  230 	mov	dph,r3
   09DE 8C F0         [24]  231 	mov	b,r4
   09E0 12 0C 0F      [24]  232 	lcall	__gptrget
   09E3 F5 1E         [12]  233 	mov	_ComputeCrc_chBlock_1_6,a
   09E5 A3            [24]  234 	inc	dptr
   09E6 AA 82         [24]  235 	mov	r2,dpl
   09E8 AB 83         [24]  236 	mov	r3,dph
                            237 ;	crc_a.c:26: UpdateCrc(chBlock, &wCrc);
   09EA 75 21 1F      [24]  238 	mov	_UpdateCrc_PARM_2,#_ComputeCrc_wCrc_1_6
   09ED 75 22 00      [24]  239 	mov	(_UpdateCrc_PARM_2 + 1),#0x00
   09F0 75 23 40      [24]  240 	mov	(_UpdateCrc_PARM_2 + 2),#0x40
   09F3 85 1E 82      [24]  241 	mov	dpl,_ComputeCrc_chBlock_1_6
   09F6 C0 04         [24]  242 	push	ar4
   09F8 C0 03         [24]  243 	push	ar3
   09FA C0 02         [24]  244 	push	ar2
   09FC C0 01         [24]  245 	push	ar1
   09FE C0 00         [24]  246 	push	ar0
   0A00 12 09 4F      [24]  247 	lcall	_UpdateCrc
   0A03 D0 00         [24]  248 	pop	ar0
   0A05 D0 01         [24]  249 	pop	ar1
   0A07 D0 02         [24]  250 	pop	ar2
   0A09 D0 03         [24]  251 	pop	ar3
   0A0B D0 04         [24]  252 	pop	ar4
                            253 ;	crc_a.c:27: } while (--Length);
   0A0D 18            [12]  254 	dec	r0
   0A0E B8 FF 01      [24]  255 	cjne	r0,#0xFF,00113$
   0A11 19            [12]  256 	dec	r1
   0A12                     257 00113$:
   0A12 E8            [12]  258 	mov	a,r0
   0A13 49            [12]  259 	orl	a,r1
                            260 ;	crc_a.c:29: *Data++ = (BYTE) (wCrc & 0xFF);
   0A14 70 C4         [24]  261 	jnz	00101$
   0A16 A8 1F         [24]  262 	mov	r0,_ComputeCrc_wCrc_1_6
   0A18 8A 82         [24]  263 	mov	dpl,r2
   0A1A 8B 83         [24]  264 	mov	dph,r3
   0A1C 8C F0         [24]  265 	mov	b,r4
   0A1E E8            [12]  266 	mov	a,r0
   0A1F 12 0B F4      [24]  267 	lcall	__gptrput
   0A22 74 01         [12]  268 	mov	a,#0x01
   0A24 2A            [12]  269 	add	a,r2
   0A25 FD            [12]  270 	mov	r5,a
   0A26 E4            [12]  271 	clr	a
   0A27 3B            [12]  272 	addc	a,r3
   0A28 FE            [12]  273 	mov	r6,a
   0A29 8C 07         [24]  274 	mov	ar7,r4
                            275 ;	crc_a.c:30: *Data++ = (BYTE) ((wCrc >> 8) & 0xFF);
   0A2B AC 20         [24]  276 	mov	r4,(_ComputeCrc_wCrc_1_6 + 1)
   0A2D 8D 82         [24]  277 	mov	dpl,r5
   0A2F 8E 83         [24]  278 	mov	dph,r6
   0A31 8F F0         [24]  279 	mov	b,r7
   0A33 EC            [12]  280 	mov	a,r4
                            281 ;	crc_a.c:31: return;
   0A34 02 0B F4      [24]  282 	ljmp	__gptrput
                            283 	.area CSEG    (CODE)
                            284 	.area CONST   (CODE)
                            285 	.area XINIT   (CODE)
                            286 	.area CABS    (ABS,CODE)
