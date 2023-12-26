
MESON ?= meson
PYTHON3 ?= python3

FLASHROM ?= flashrom
FLASHROM_ARGS ?=
FLASHROM_PRGM ?=

EXTRA_GENIMG_ARGS ?=

-include config.mk

BUILDTYPE ?= debugoptimized

CONFIG ?= --buildtype=$(BUILDTYPE)
BUILD ?=

CROSS_BASE = --cross-file=subprojects/libdawn/cross/arm-none-eabi.txt
CROSS_7 = $(CROSS_BASE) --cross-file=subprojects/libdawn/cross/arm7tdmi.txt
CROSS_9 = $(CROSS_BASE) --cross-file=subprojects/libdawn/cross/arm946e-s.txt

DIR7 := build/meson_arm7/
DIR9 := build/meson_arm9/

PL71 := $(DIR7)/exploit/exploit.elf
PL91 := $(DIR9)/exploit/exploit.elf

#PL72 := $(DIR7)/bootloader/bootloader.elf
#PL92 := $(DIR9)/bootloader/bootloader.elf

default: all


configure_7:
	@mkdir -p $(DIR7)/subprojects/libdawn/include $(DIR7)/subprojects/libdawn/include7  # work around a bug
	$(MESON) setup $(CROSS_7) $(CONFIG) $(DIR7)
configure_9:
	@mkdir -p $(DIR9)/subprojects/libdawn/include $(DIR9)/subprojects/libdawn/include9  # work around a bug
	$(MESON) setup $(CROSS_9) $(CONFIG) $(DIR9)

configure: configure_7 configure_9


%/:
	@mkdir -vp "$@"

build_7: configure_7
	$(MESON) compile -C $(DIR7) $(BUILD)
build_9: configure_9
	$(MESON) compile -C $(DIR9) $(BUILD)

genimg/lzss: genimg/lzss.c
	$(MAKE) -C genimg

build/payload.bin: build_7 build_9 genimg/lzss build/
	$(PYTHON3) genimg/genimg.py $(EXTRA_GENIMG_ARGS) -o "$@" $(PL71) $(PL91)

build: build/payload.bin

all: build


dfu: build/payload.bin
	$(DFU_UTIL) -a 0 -D "$<"

flash: build/payload.bin
	@if [ "x$(FLASHROM_PRGM)" = "x" ]; then >&2 echo "ERROR: FLASHROM_PRGM must be provided."; false; fi
	$(FLASHROM) -p $(FLASHROM_PRGM) $(FLASHROM_ARGS) -w "$<"


clean:
	$(MAKE) -C genimg clean
	$(RM) build/payload.bin


distclean:
	$(MAKE) -C genimg distclean
	$(RM) -r build/

.PHONY: deafult all dfu flash clean
.PHONY: build build_7 build_9
.PHONY: configure configure_7 configure_9

