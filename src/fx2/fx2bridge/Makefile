INCLUDES = -I../include
CC = sdcc-sdcc -mmcs51
BASENAME = fx2bridge

$(BASENAME).ihx: $(BASENAME).c
	$(CC) $(INCLUDES) $(BASENAME).c

clean:
	rm -f $(BASENAME).{asm,ihx,lnk,lst,map,mem,rel,rst,sym,lk}

.PHONY: clean
