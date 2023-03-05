# Make file replace with cmake later for better compile time

GCCPARAMS = -m64 -nostdlib -fno-rtti -fno-builtin -fno-exceptions -fno-leading-underscore

all: bootloader.asm kluster.qcow2 boot.bin 

bootloader.asm:
	nasm -f bin src/bootloader.asm -o build/bootloader.bin

boot.bin:
	qemu-system-x86_64 -drive file=build/bootloader.bin,format=raw

kluster.qcow2:
	qemu-img convert -f raw build/bootloader.bin -O qcow2  vm/kluster.qcow2