
default: all

CFLAGS = -O2

all: lzss

lzss: lzss.c

clean:
	@$(RM) -v lzss

distclean: clean
	@$(RM) -v test.bin

.PHONY: all clean distclean $(PL7) $(PL9)

