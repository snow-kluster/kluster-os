# Make file replace with cmake later for better compile time
# add qcow2 file conv check
CCFLAGS = -m64 -nostdlib -fno-rtti -fno-builtin -fno-exceptions -fno-leading-underscore

BOOTSECT=boot.bin

all: bootloader.asm kluster.qcow2 boot.bin

bootloader.asm:
	nasm -f bin src/boot.asm -o build/boot.bin -I base/ -I include/long -I include/protect

boot.bin:
	qemu-system-x86_64 -drive file=build/boot.bin,format=raw

kluster.qcow2:
	qemu-img convert -f raw build/boot.bin -O qcow2  vm/kluster.qcow2

# iso:
# 	dd if=/dev/zero of=vm/boot.iso bs=512 count=2880
# 	dd if=./src/$(BOOTSECT) of=boot.iso conv=notrunc bs=512 seek=0 count=1
# 	# dd if=./bin/$(KERNEL) of=boot.iso conv=notrunc bs=512 seek=1 count=2048