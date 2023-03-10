[bits 16]

; Define function print_bios
; Input pointer to string in bx
print_bios:
	push ax
	push bx

	mov ah, 0x0e ; tty mode 

	print_bios_loop:

		cmp byte[bx], 0
		je print_bios_end

		mov al, byte[bx]
		int 0x10

		inc bx
		jmp print_bios_loop

print_bios_end:

	pop bx
	pop ax
	ret