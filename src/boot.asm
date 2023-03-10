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
call print_bios

call elevate_bios

bootsector_hold:
jmp $

%include "../base/print.asm"
%include "../base/hex.asm"
%include "../base/load.asm"
%include "../base/gdt.asm"
%include "../base/protect.asm"

msg_hello_world:
db 0dh,0ah,'Hello World, using CRLF!',0dh,0ah, 0

; Boot drive storage
boot_drive:
db 0x00

times 510 - ($ - $$) db 0x00
dw 0xAA55

; BEGIN SECOND SECTOR. THIS ONE CONTAINS 32-BIT CODE ONLY

bootsector_extended:
begin_protected:

[bits 32]

; Clear vga memory output
call clear_protected

call detect_lm_protected

; Test VGA-style print function
mov esi, protected_alert
call print_protected

call init_pt_protected

call elevate_protected

jmp $       ; Infinite Loop

; INCLUDE protected-mode functions
%include "../include/protect/clear.asm"
%include "../include/protect/print.asm"
%include "../include/protect/init.asm"
%include "../include/protect/detect.asm"
%include "../include/protect/gdt.asm"
%include "../include/protect/elevate.asm"


; Define necessary constants
vga_start:                  equ 0x000B8000
vga_extent:                 equ 80 * 25 * 2             ; VGA Memory is 80 chars wide by 25 chars tall (one char is 2 bytes)
kernel_start:               equ 0x00100000              ; Kernel is at 1MB
style_wb:                   equ 0x0F

; Define messages
protected_alert:                 db `Now in 32-bit protected mode`, 0

; Fill with zeros to the end of the sector
times 512 - ($ - bootsector_extended) db 0x00

begin_long_mode:

[bits 64]

mov rdi, style_blue
call clear_long

mov rdi, style_blue
mov rsi, long_mode_note
call print_long

jmp $

%include "../include/long/clear.asm"
%include "../include/long/print.asm"

long_mode_note:                      db `Now running in fully-enabled, 64-bit long mode!`, 0
style_blue:                     equ 0x1F

times 512 - ($ - begin_long_mode) db 0x00