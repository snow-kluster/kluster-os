[org 0x7C00]
[bits 16]

mov bp, 0x0500
mov sp, bp

mov byte[boot_drive], dl

mov bx, msg_hello_world
call print_bios

mov bx, 0x0002

; We only want to load one sector from the disk for now. This will
; be higher later. Note: Only cl will be used
mov cx, 0x0001

; Finally, we want to store the new sector immediately after the first
; loaded sector, at adress 0x7E00. This will help a lot with jumping between
; different sectors of the bootloader.
mov dx, 0x7E00

; Now we're fine to load the new sectors
call load_bios

; We should now be able to read the loaded string
mov bx, loaded_msg
call print_bios

call elevate_bios

bootsector_hold:
jmp $

%include "../base/print.asm"
%include "../base/hex.asm"
%include "../base/load.asm"
%include "../base/gdt.asm"

msg_hello_world:
db 0dh,0ah,'Hello World, using CRLF!',0dh,0ah, 0

times 510 - ($ - $$) db 0x00

dw 0xAA55

; Boot drive storage
boot_drive:
db 0x00

bootsector_extended:

loaded_msg:
db 0dh,0ah,'Now reading from the next sector!',0dh,0ah, 0

; Fill with zeros to the end of the sector
times 512 - ($ - bootsector_extended) db 0x00
bu: