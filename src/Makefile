SUBDIRS=host fx2 t51 vhdl/sim

TARGETS = all build clean test

.PHONY: $(TARGETS)


$(TARGETS):
	$(foreach s, $(SUBDIRS), $(MAKE) -C $(s) $(MAKECMDGOALS);)
