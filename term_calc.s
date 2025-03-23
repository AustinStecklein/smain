GLOBAL _start

SECTION .data
    message db "Hello world!", 0xa
    len equ $ -message

SECTION .text

; define all functions here

_start:
    ; go to the "main" function. I do it this way so that once the function
    ; returns it will not go through to another label.
    jmp termCalc

; create a basic term calculator
; void termCalc()
termCalc:
    mov eax, 1        ; syscall number for sys_write (1)
    mov edi, 1        ; file descriptor 1 = stdout
    mov esi, message  ; pointer to the message
    mov edx, len      ; length of the message
    syscall

    ; syscall: exit(0)
    mov eax, 60       ; syscall number for sys_exit (60)
    xor edi, edi      ; exit code 0
    syscall
