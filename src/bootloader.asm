; bootsector
[bits 16] 		; use 16 bits
[org 0x7c00] 		; sets the start address for bootloader

; bootloader check for last to bytes to confirm bootsector
; 0x55 0xaa are the key signatures present at the end of the bootsector

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

times 510-($-$$) db 0		; fill the output file with zeroes until 510 bytes
dw 0xaa55		; magic number that tells the BIOS this is bootable. 
; last 2 bits for sig check 
