[bits 16]

; Define function print_bios
; Input pointer to string in bx
print_bios:
	push ax
	push bx

	mov ah, 0x0e ; tty mode 

	print_bios_loop:

		; Now, we need to compare the current character pointed to
		; by the address in bx to the null terminator, 0. We can get
		; the value at the address of a register by specifying the size
		; and using square brackets, like follows:
		;
		; byte[bx]
		;
		; To compare it with 0, we use the cmp function. This sets values in
		; a special state register that we can use with other instructions.
		; In this case, we use je, which stands for 'jump if equal' to go to
		; the end of the program.
		cmp byte[bx], 0
		je print_bios_end

		; If the program has reached this point, then we want to print a character!
		; To do this, we need to move the character to al (read the paragraph about
		; BIOS utilities for the reason why) and then call the special multipurpose
		; interrupt 0x10, which we can do with the 'int' command. Remember the
		; special character read syntax we talked about before!
		mov al, byte[bx]
		int 0x10

		; Now that the character is printed, we can go back to the beginning of
		; the loop. Don't forget to increment the pointer first though, which we can
		; do with the handy 'inc' command
		inc bx
		jmp print_bios_loop


	; Label the end of the function, so we can jump here once
	; we reach the null terminator.
print_bios_end:

	; Restore the values of ax and bx registers. Remember that they've
	; been pushed onto the stack, so we'll need to pop them in the opposite
	; order.
	pop bx
	pop ax

	; This instruction returns to the instruction after the initial
	; 'call' instruction that got us here. It works almost the same as
	; 'return' in C, but you can't give it a value.
	ret