TARGET=hex2rom

CXXFLAGS=-std=c++11 -g

test: $(TARGET)
	./$(TARGET) test.ihx 12 8 rom52

build: $(TARGET)

$(TARGET): hex2rom.cpp


install: $(TARGET)
	install $(TARGET) /usr/bin/

clean:
	rm -rf *.o $(TARGET) rom52.*

.PHONY: clean
