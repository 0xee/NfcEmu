TARGET=smartcard

vpath %.c ../common
CC = sdcc-sdcc -mmcs51

COMMON=../common
OBJDIR=obj
INCLUDE= -I$(COMMON)
CCFLAGS= $(INCLUDE)
LDFLAGS=--xram-loc 0 --xram-size 2048
VHD_DEST=../../vhdl/gensrc
SRC = $(wildcard *.c)
COMMON_SRC = $(wildcard $(COMMON)/*.c)

OBJS = $(patsubst %.c,$(OBJDIR)/%.rel,$(SRC))
COMMON_OBJS = $(patsubst $(COMMON)/%.c,$(OBJDIR)/%.rel,$(COMMON_SRC)) 

$(VHD_DEST)/ROM52.vhd: $(TARGET).ihx $(VHD_DEST)
	hex2rom $(TARGET).ihx 12 8 ROM52
	mv ROM52.vhd $@

$(VHD_DEST):
	@mkdir -p $@

$(TARGET).ihx: $(OBJS)  $(COMMON_OBJS)
	@echo Sources $(SRC) $(COMMON_SRC)
	@echo Objects $(OBJS) 
	@echo Common Objs $(COMMON_OBJS)
	$(CC) $(LDFLAGS) $(OBJS) $(COMMON_OBJS) -o $(TARGET).out
	mv $(TARGET).out $(TARGET).ihx

$(OBJS): | $(OBJDIR)

$(OBJDIR):
	@mkdir -p $@

$(OBJDIR)/%.rel : %.c Makefile
	@echo Compiling $< 
	$(CC) $(CCFLAGS) -c $< -o $@

# $(COMMON_OBJS) : $(COMMON_SRC)
# 	@echo Compiling $< 
# 	$(CC) $(CCFLAGS) -c $< -o $@


clean:
	rm -rf *.{asm,ihx,out,lnk,lst,map,mem,rel,rst,sym,lk,vhd,d} $(OBJDIR) $(VHD_DEST)/ROM52.vhd


.PHONY: clean
