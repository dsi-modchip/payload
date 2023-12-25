# DSi modchip payload

This repository contains two things: an exploit payload for a fault
injection-based DSi bootrom exploit, and a replacement DSi bootloader for
initializing all necessary DSi hardware components and chainloading homebrew
programs from the SD card.

The exploit code resides in the SPI flash, and loads the bootloader from there
as well (as there isn't enough space for both at once, as the memory limits
are rather tight the moment the exploit happens).

... or at least that's the intention. Currently, all code here is very
bare-bones, to say the least: the exploit works but does nothing once it has
achieved arbitrary code execution. There is *no* code written for the
bootloader, at all.
