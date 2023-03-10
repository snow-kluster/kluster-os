[bits 32]

init_pt_protected:
	pushad

	mov edi, 0x1000         ; Set the base address for rep stosd. Our page table goes from
							; 0x1000 to 0x4FFF, so we want to start at 0x1000

	mov cr3, edi            ; Save the PML4T start address in cr3. This will save us time later
							; because cr3 is what the CPU uses to locate the page table entries

	xor eax, eax            ; Set eax to 0. Note that xor is actually faster than "mov eax, 0".

	mov ecx, 4096           ; Repeat 4096 times. Since each page table is 4096 bytes, and we're
							; writing 4 bytes each repetition, this will zero out all 4 page tables

	rep stosd               ; Now actually zero out the page table entries

	; Set edi back to PML4T[0]
	mov edi, cr3

	mov dword[edi], 0x2003      ; Set PML4T[0] to address 0x2000 (PDPT) with flags 0x0003
	add edi, 0x1000             ; Go to PDPT[0]
	mov dword[edi], 0x3003      ; Set PDPT[0] to address 0x3000 (PDT) with flags 0x0003
	add edi, 0x1000             ; Go to PDT[0]
	mov dword[edi], 0x4003      ; Set PDT[0] to address 0x4000 (PT) with flags 0x0003

	add edi, 0x1000             ; Go to PT[0]
	mov ebx, 0x00000003         ; EBX has address 0x0000 with flags 0x0003
	mov ecx, 512                ; Do the operation 512 times

	add_page_entry_protected:
		; a = address, x = index of page table, flags are entry flags
		mov dword[edi], ebx                 ; Write ebx to PT[x] = a.append(flags)
		add ebx, 0x1000                     ; Increment address of ebx (a+1)
		add edi, 8                          ; Increment page table location (since entries are 8 bytes)
											; x++
		loop add_page_entry_protected       ; Decrement ecx and loop again

	mov eax, cr4
	or eax, 1 << 5               ; Set the PAE-bit, which is the 5th bit
	mov cr4, eax

	popad
	ret