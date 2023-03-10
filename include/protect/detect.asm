[bits 32]

detect_lm_protected:
	pushad

	pushfd                          ; Copy FLAGS to eax via stack
	pop eax

	; Save to ecx for comparison later
	mov ecx, eax

	; Flip the ID bit (21st bit of eax)
	xor eax, 1 << 21

	; Write to FLAGS
	push eax
	popfd

	; Read from FLAGS again
	; Bit will be flipped if CPUID supported
	pushfd
	pop eax

	; Restore eflags to the older version saved in ecx
	push ecx
	popfd

	cmp eax, ecx
	je cpuid_not_found_protected        ; Print error and hang if CPUID unsupported

	mov eax, 0x80000000             ; CPUID argument than 0x80000000
	cpuid                           ; Run the command
	cmp eax, 0x80000001             ; See if result is larger than than 0x80000001
	jb cpuid_not_found_protected    ; If not, error and hang


	; Actually check for long mode
	;
	; Now, we can use CPUID to check for long mode. If long mode is
	; supported, then CPUID will set the 29th bit of register edx. The
	; eax code to look for long mode is 0x80000001
	mov eax, 0x80000001             ; Set CPUID argument
	cpuid                           ; Run CPUID
	test edx, 1 << 29               ; See if bit 29 set in edx
	jz lm_not_found_protected       ; If it is not, then error and hang
	
	; Return from the function
	popad
	ret

;
; Print an error message and hang
;
cpuid_not_found_protected:
	call clear_protected
	mov esi, cpuid_not_found_str
	call print_protected
	jmp $

;
; Print an error message and hang
;
lm_not_found_protected:
	call clear_protected
	mov esi, lm_not_found_str
	call print_protected
	jmp $

lm_not_found_str:                   db `ERROR: Long mode not supported. Exiting...`, 0
cpuid_not_found_str:                db `ERROR: CPUID unsupported, but required for long mode`, 0