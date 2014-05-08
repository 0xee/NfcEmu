TARGET=nfcemu.so

SRC = $(wildcard *.cpp)
HEADERS = $(wildcard *.h)

OBJDIR=obj
OBJS = $(patsubst %.cpp,$(OBJDIR)/%.o,$(SRC))
LIBS=libusb-1.0 libpcsclite python
CXX=g++
CXXFLAGS=-g3 -std=c++11 -O0 `pkg-config --cflags $(LIBS)` -fpic
LDFLAGS= -rdynamic -lusb -lboost_system -lboost_timer -lboost_filesystem `pkg-config --libs $(LIBS)` -lboost_python  -shared
DEPS := $(OBJS:.o=.d)

NODEPS=clean

PYTHON_MODULE_PATH=/usr/lib64/python2.7

$(TARGET): $(OBJS)
	$(CXX) -o $(TARGET) $(LDFLAGS) $(OBJS)

install: $(TARGET)
	install $(TARGET) $(PYTHON_MODULE_PATH)/site-packages/$(TARGET)
test: $(TARGET)
	./test.py
#Don't create dependencies when we're cleaning, for instance
ifeq (0, $(words $(findstring $(MAKECMDGOALS), $(NODEPS))))
-include $(DEPS)
endif

#This is the rule for creating the dependency files
obj/%.d: %.cpp
	$(CXX) $(CXXFLAGS) -MM -MT '$(patsubst %.cpp,$(OBJDIR)/%.o,$<)' $< -MF $@


$(OBJS): | $(OBJDIR)
$(DEPS): | $(OBJDIR)

$(OBJDIR)/%.o : %.cpp $(OBJDIR)/%.d
	@echo Compiling $<
	$(CXX) $(CXXFLAGS) -c $< -o $@


# run: $(TARGET)
# 	./$(TARGET)


$(OBJDIR):
	@mkdir -p $@


.PHONY: check-syntax

check-syntax:
	$(CXX) -std=c++11 -Wall -Wextra -pedantic -fsyntax-only $(CHK_SOURCES)

clean:
	rm -rf  core.* $(TARGET) *.log $(OBJDIR)

.PHONY: clean
