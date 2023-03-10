[org 0x7C00]
[bits 16]

mov bx, msg_hello_world
call print_bios

bootsector_hold:
jmp $

%include "../base/print.asm"
msg_hello_world:
db `\r\nHello World, from the BIOS!\r\n`, 0

times 510 - ($ - $$) db 0x00

dw 0xAA55