SUBDIRS=hex2rom nfcemu

TARGETS = all build clean test install

.PHONY: $(TARGETS)


$(TARGETS):
	$(foreach s, $(SUBDIRS), $(MAKE) -C $(s) $(MAKECMDGOALS);)
