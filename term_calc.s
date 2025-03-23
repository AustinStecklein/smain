GLOBAL _start

SECTION .data
    message db "Welcome to the term calculator!", 0xa
    messageLen equ $ - message ; current address ($) - address of memory

    newLine db 0xa
    newLineLen equ $ - newLine

SECTION .bss
    input resb 256 ; only grab 256 bytes from the command line
SECTION .text

; define all functions here
mimic:
    ; header
    mov eax, 1        ; syscall number for write
    mov edi, 1        ; file descriptor 1 = stdout
    mov esi, message  ; pointer to the message
    mov edx, messageLen      ; length of the message
    syscall

    ; grab user input
    mov eax, 0        ; syscall number for read(0)
    mov edi, 2        ; file descriptor 2 = stdin
    mov esi, input     ; pointer to the input buffer
    mov edx, 256      ; length of the input buffer
    syscall

    ; print user input again
    mov edx, eax     ; length of the message returned from read
    mov eax, 1       ; syscall number for write
    mov edi, 1       ; file descriptor 1 = stdout
    mov esi, input    ; pointer to the message
    syscall
    ret


_start:
    ; go to the "main" function. I do it this way so that once the function
    ; returns it will not go through to another label.
    jmp termCalc

; create a basic term calculator
; void termCalc()
termCalc:
    call mimic
    ; syscall: exit(0)
    mov eax, 60       ; syscall number for sys_exit (60)
    xor edi, edi      ; exit code 0
    syscall
