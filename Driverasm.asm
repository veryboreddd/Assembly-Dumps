; DRIVER FUNCTIONS -----------------------
PUBLIC DriverEntry
PUBLIC Driver_Unload

;-------------------------- 
PUBLIC Get_NT_Base
PUBLIC Get_APIC
PUBLIC Get_Current_Thread


.data

KiExecuteDpc dq 18446735300277891136 ; Testing addressing modes - decimal.
MemBlock dq 18446735300282000456 ; 

MmRoutine dq 18446735286579268512 ; 

.data?

current_thread dq ?

.code 

EXTERN print_ : PROC
EXTERN MmGetSystemRoutineAddress : PROC
EXTERN Get_NT : PROC

Driver_Unload PROC
	ret
Driver_Unload ENDP

DriverEntry PROC
	mov [rsp + 10h], rdx ; Home Space
	mov [rsp + 8h], rcx ; Home space
	sub rsp, 28h

	lea rdx, Driver_Unload ; Set driver unload function
	mov [rcx + 68h], rdx

	;call Get_NT

	call Get_APIC
	mov rcx, rax
	call print_

	xor rax, rax ; STATUS_SUCCESS
	add rsp, 28h
	ret
DriverEntry ENDP

Get_NT_Base PROC
	mov rcx, MmRoutine ; Address of MmGetSystemRoutineAddress
	add rcx, 32h ; Offset 32h is PsNtosImageBase

	mov eax, dword ptr [rcx + 3h] ; Calculate our relative address
	lea rax, [rcx + rax + 7h]

	mov rdx, 100000000h
	sub rax, rdx

	mov rax, [rax] ; return the value at PsNtosImageBase
	ret

Get_NT_Base ENDP


Get_APIC PROC

	mov ecx, 1bh
	rdmsr
	ret

Get_APIC ENDP

Get_Current_Thread PROC

	mov rax, gs:[188h] ; Current thread
	ret

Get_Current_Thread ENDP

END
