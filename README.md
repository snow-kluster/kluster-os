bootsector compile command

- need to specify bin format for boot sector

nasm -f bin src/boot.asm -o build/boot.bin

qemu run vm command

- need to specify format as raw or could overwrite boot sector 
- if image format not specified qemu will take guess image format and could rewrite sector 0
- 

qemu-system-x86_64 -drive file=build/boot.bin,format=raw