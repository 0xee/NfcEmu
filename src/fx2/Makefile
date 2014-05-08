SUBDIRS=fx2bridge

TARGETS = all build clean test

.PHONY: $(TARGETS)


$(TARGETS):
	$(foreach s, $(SUBDIRS), $(MAKE) -C $(s) $(MAKECMDGOALS);)	
