TARGET=nfcemu

SRC = $(wildcard *.cpp)
HEADERS = $(wildcard *.h)

OBJDIR=obj
OBJS = $(patsubst %.cpp,$(OBJDIR)/%.o,$(SRC))

CXX=g++
CXXFLAGS=-g3 -std=c++11 -O0 `pkg-config --cflags libusb-1.0`
LDFLAGS= -lusb -lboost_system `pkg-config --libs libusb-1.0`
DEPS := $(OBJS:.o=.d)

NODEPS=clean

$(TARGET): $(OBJS)
	g++ -o $(TARGET) $(LDFLAGS) $(OBJS)

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


run: $(TARGET)
	./$(TARGET)


$(OBJDIR):
	@mkdir -p $@


clean:
	rm -rf  core.* $(TARGET) *.log $(OBJDIR)

.PHONY: clean

