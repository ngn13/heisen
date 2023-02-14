BOOT := boot/boot.s
CC = /usr/local/i386elfgcc/bin/i386-elf-gcc
LD = /usr/local/i386elfgcc/bin/i386-elf-ld

build/heisen.img: build/boot.bin build/kernel.bin
	cat $^ > $@ 

build/kernel.bin: build/kernel.o build/entry.o
	mkdir -p build
	${LD} -o $@ -Ttext 0x1000 $^ --oformat binary

build/entry.o: boot/entry.s
	mkdir -p build
	nasm $< -f elf -o $@

build/kernel.o: kernel/kernel.c
	mkdir -p build
	${CC} -ffreestanding -nostdlib -nostartfiles -o $@ $^

build/boot.bin: boot/boot.s boot/lib.s
	mkdir -p build
	nasm -f bin -o $@ $(BOOT)

qemu:
	qemu-system-x86_64 build/boot.bin

clean:
	rm -rf build/*
