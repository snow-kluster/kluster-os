gdt_32_start:

gdt_32_null:
	dd 0x00000000           ; All values in null entry are 0
	dd 0x00000000           ; All values in null entry are 0

; Define the code sector for the 32 bit gdt
gdt_32_code:

	dw 0xFFFF           ; Limit (bits 0-15)
	dw 0x0000           ; Base  (bits 0-15)
	db 0x00             ; Base  (bits 16-23)
	db 0b10011010       ; 1st Flags, Type flags
	db 0b11001111       ; 2nd Flags, Limit (bits 16-19)
	db 0x00             ; Base  (bits 24-31)

; Define the data sector for the 32 bit gdt
gdt_32_data:

	dw 0xFFFF           ; Limit (bits 0-15)
	dw 0x0000           ; Base  (bits 0-15)
	db 0x00             ; Base  (bits 16-23)
	db 0b10010010       ; 1st Flags, Type flags
	db 0b11001111       ; 2nd Flags, Limit (bits 16-19)
	db 0x00             ; Base  (bits 24-31)

gdt_32_end:

gdt_32_descriptor:
	dw gdt_32_end - gdt_32_start - 1        ; Size of GDT, one byte less than true size
	dd gdt_32_start                         ; Start of the 32 bit gdt


code_seg:                           equ gdt_32_code - gdt_32_start
data_seg:                           equ gdt_32_data - gdt_32_start