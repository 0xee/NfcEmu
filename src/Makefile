SUBDIRS=host fx2 t51

TARGETS = all build clean test

.PHONY: $(TARGETS) vhdl/sim/Makefile


all build test: 
	$(foreach s, $(SUBDIRS), $(MAKE) -C $(s) $(MAKECMDGOALS);)
	cd vhdl/sim; vhdmake
	$(MAKE) -C vhdl/sim $(MAKECMDGOALS)

clean:
	$(foreach s, $(SUBDIRS) vhdl/sim, $(MAKE) -C $(s) $(MAKECMDGOALS);)
	cd vhdl/sim; vhdmake -c
