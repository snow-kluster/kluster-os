# Make file replace with cmake later for better compile time


all: bootloader.asm boot.bin

bootloader.asm:
	nasm -f bin src/bootloader.asm -o build/bootloader.bin

boot.bin:
	qemu-system-x86_64 -drive file=build/bootloader.bin,format=raw

