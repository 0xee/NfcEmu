SUBDIRS=smartcard

TARGETS = all build clean test

.PHONY: $(TARGETS)

$(TARGETS):
	$(foreach s, $(SUBDIRS), $(MAKE) -C $(s) $(MAKECMDGOALS);)
