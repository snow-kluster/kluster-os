; bootsector
[bits 16] 		; use 16 bits
[org 0x7c00] 		; sets the start address for bootloader

; bootloader check for last to bytes to confirm bootsector
; 0x55 0xaa are the key signatures present at the end of the bootsector

mov [BOOT_DRIVE], dl ; BIOS stores our boot drive in DL , so it ’s
; best to remember this for later.
mov bp, 0 x8000 ; Here we set our stack safely out of the
mov sp, bp ; way , at 0 x8000
mov bx, 0 x9000 ; Load 5 sectors to 0 x0000 (ES ):0 x9000 (BX)
mov dh, 5 ; from the boot disk.
mov dl, [ BOOT_DRIVE ]
call disk_load
mov dx, [0 x9000 ] ; Print out the first loaded word , which
call print_hex ; we expect to be 0xdada , stored
; at address 0 x9000
mov dx, [0 x9000 + 512] ; Also , print the first word from the
call print_hex ; 2nd loaded sector : should be 0 xface
jmp $

%include "../../include/base/disk_load.asm"

start:
	mov si, msg 	; load the address of msg into si register
	mov ah, 0x0e 	; sets ah to 0xe (function teletype)
	cli		; disables maskable interrupt
.printchar:
	lodsb 		; loads the current byte from si into al and increments value
	cmp al, 0 	; compares al to zero
	je .done 	; if al == 0, jump to done
	int 0x10 	; print to screen using function 0xe of interrupt 0x10
	jmp .printchar 	; repeat with next byte
.done:
	ret 	; stop execution

data:
msg db 'Hello World!',0dh,0ah,'carriage return done!', 0

; Global variables
BOOT_DRIVE : db 0

times 510-($-$$) db 0		; fill the output file with zeroes until 510 bytes
dw 0xaa55		; magic number that tells the BIOS this is bootable. 
; last 2 bits for sig check 

times 256 dw 0 xdada
times 256 dw 0 xface