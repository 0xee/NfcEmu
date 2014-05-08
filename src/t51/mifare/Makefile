vpath %.c ../common
CC = sdcc -mmcs51
VCOM=/opt/altera/modelsim_ase/bin/vcom
COMMON=../common
OBJDIR=../obj
INCLUDE= -I$(COMMON)
CFLAGS= $(INCLUDE)
SRC = $(wildcard *.c)
COMMON_SRC = $(wildcard $(COMMON)/*.c)

OBJS = $(patsubst %.c,$(OBJDIR)/%.rel,$(SRC))
COMMON_OBJS = $(patsubst $(COMMON)/%.c,$(OBJDIR)/%.rel,$(COMMON_SRC)) 

TARGET=mifare

$(TARGET).vhd: $(TARGET).ihx
	hex2rom $(TARGET).ihx ROM52 12b8s > $(TARGET).vhd
	$(VCOM) -work /tmp/work $(TARGET).vhd
	wc -l $(TARGET).vhd

$(TARGET).ihx: $(OBJS)  $(COMMON_OBJS)
	@echo Sources $(SRC) $(COMMON_SRC)
	@echo Objects $(OBJS) 
	@echo Common Objs $(COMMON_OBJS)
	$(CC) $(OBJS) $(COMMON_OBJS) -o $(TARGET).out
	mv $(TARGET).out $(TARGET).ihx

$(OBJS): | $(OBJDIR)

$(OBJDIR):
	@mkdir -p $@

$(OBJDIR)/%.rel : %.c
	@echo Compiling $< 
	$(CC) $(CFLAGS) -c $< -o $@

# $(COMMON_OBJS) : $(COMMON_SRC)
# 	@echo Compiling $< 
# 	$(CC) $(CFLAGS) -c $< -o $@


clean:
	rm -rf *.{asm,ihx,out,lnk,lst,map,mem,rel,rst,sym,lk,vhd,d} $(OBJDIR)


.PHONY: clean


# SRC = $(wildcard *.c) $(wildcard ../common/*.c)


# OBJS = $(SRC:.c=.rel)

# TARGET = relay_echo
# #OBJS    = $(addsuffix .rel, $(basename $(SRC)))


# # pull in dependency info for *existing* .o files
# -include $(OBJS:.rel=.d)

# %.rel: %.c 
# 	$(CC) -c $<
# 	$(CC) -MM $<

