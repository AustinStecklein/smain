GLOBAL _start

SECTION .data
    message db "Welcome to the term calculator!", 0xa
    messageLen equ $ - message ; current address ($) - address of memory
    newLine db 0xa
    newLineLen equ $ - newLine
    exitCommand db "exit", 0xa ; include the terminator since read returns the string with it
    exitCommandLen equ $ - exitCommand

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

.user_input:
    ; grab user input
    mov eax, 0        ; syscall number for read(0)
    mov edi, 2        ; file descriptor 2 = stdin
    mov esi, input     ; pointer to the input buffer
    mov edx, 256      ; length of the input buffer
    syscall

    ; if zero or less jump back up
    cmp eax, 0x01 ; will always have one byte for the null terminator
    jle .user_input

    ; if exit is typed then leave
    mov ecx, exitCommandLen ; Only compare to the length of the exit string.
    ; this is a wild command.;
    ; repe: is an instruction that notes to repeat if ecx is not zero
    ; and the zero flag is set
    ; cmpsb: is a byte wise comparison of (e)si and (e)di. If the DF flag is
    ; zero then the registers are incremented after the comparison.
    ; This should already be cleared since we have never set it
    mov esi, input
    mov edi, exitCommand
    repe cmpsb
    ; for the user input to be equal the zero flag must still be set
    je .end

    ; parse user input
    ; perform arithmetic

    ; jump forever
    jmp .user_input

.end:
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
