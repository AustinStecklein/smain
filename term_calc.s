GLOBAL _start
; This was a basic program to get my feet wet in larger scale assembly programs
; other than single functions. The general idea is to have a terminal program
; to do basic calculator operations. I say basic since implementing a full
; on calculator with no deps was not the scope of this project. So all
; operations are done with signed ints and it only supports one operator (+ or -)
; and two operands. I might extend this in the future to support more operators
; and more operands. However lots of good parsing is done with the current format
; Spaces are ignored as long as it does not make an illegal sequence like 40 -> 4 0
; and negative signs in front of numbers do negate the number. So this sequence is
; legal -356 + -561 or - 56 + - 58

; nasm defines for quality of life constants
%define bufferLen 256
%define stdout 1
%define stdin 2
%define write 1
%define read 0
%define termCalcStack 0x30

%define plus 1
%define sub 2

SECTION .data
    welMessage db "Welcome to the term calculator!", 0xa, "Type 'exit' to leave", 0xa
    welMessageLen equ $ - welMessage ; current address ($) - address of memory
    newLine db 0xa
    newLineLen equ $ - newLine
    exitCommand db "exit", 0xa ; include the terminator since read returns the string with it
    exitCommandLen equ $ - exitCommand
    format db "The expected input format is (int) (operator:+/-) (int)", 0xa
    formatLen equ $ - format ; current address ($) - address of memory

SECTION .bss
    input resb bufferLen ; only grab 256 bytes from the command line
    output resb bufferLen ; 256 bytes is overkill but also doesn't matter
SECTION .text


; int(size of output) toString(int value, char * output, int size)
toString:
    ; an int cannot produce a bytes char string so no need to add size checks
    ; the string will be build in the inverse order that is needed.
    mov r10, rdx ; get size of the string buffer
    lea r9, [rsi + r10] ; this puts us at the end of the buffer
    mov dword [r9], 0x0a ; always end will a null terminated string
    dec r9
    mov byte [r9], 0x30 ; default case that the value is 0
    xor r11, r11
    cmp edi, 0x0
    je .zero_found
    jl .negative_found

.loop:
    cmp edi, 0x0
    jle .end
    ; this is straight from the godbolt compiler cause I didn't want
    ; to figure out fast int division right now
    mov     ecx, edi
    movsx   rax, edi
    imul    rax, rax, 1717986919
    shr     rax, 32
    mov     edx, eax
    sar     edx, 2 ; this is the result of the division
    mov     eax, edi
    sar     eax, 31
    SUB     edx, eax
    mov     eax, edx
    sal     eax, 2
    add     eax, edx
    add     eax, eax
    SUB     edi, eax ; result is in r8
    ; end of % operation

    add dil, "0" ; convert to string
    mov byte [r9], dil
    mov edi, edx
    dec r9
    jmp .loop

.negative_found:
    ; convert the negative signed number to the
    ; value of an unsigned number to get the positive
    ; representation
    xor edi, 0xFFFFFFFF
    inc edi
    or r11, 0x1
    jmp .loop

.add_negative:
    mov byte [r9], 0x2D ; - sign
    mov r11, 0x0
.zero_found:
    dec r9

.end:
    cmp r11, 0x1
    je .add_negative
    mov rax, r9
    mov r9, r10
    add r9, rsi
    SUB r9, rax ; this gives us the total amount of space taken
    mov rax, r9
    ret

; int(number of bytes it took from) getInt(char * string, int * output)
; this will put the found int in output and move the parameter
; string to the char one position after the found digits
getInt:
    mov rax, 0x0; default to zero bytes iterated
    xor r8, r8 ; zero out the result
    mov r9b, byte [rdi]

    ; spaces can on be in front of a number
    ; meaning that spaces can not follow a number
    xor r10, r10 ; number found flag
    xor rcx, rcx ; negative found flag

.loop:
    cmp r9b, ' '
    je .space_found

    cmp r9b, '-'
    je .negative_found

    ; check that the char is between 0 and 9
    cmp r9b, '0'
    jb .leave
    cmp r9b, '9'
    ja .leave

    or r10, 0x1

    ; add string digit to sum
    SUB r9b, '0'
    imul r8d, 10
    add r8d, r9d

.reset:
    ; reset state
    inc dil
    inc rax
    mov r9b, byte [rdi]
    jmp .loop

.space_found:
    cmp r10, 0x1
    je .leave
    jmp .reset

.negative_found:
    ; founding a negative is fine as long as a number
    ; has not been found yet
    cmp r10, 0x1
    je .leave
    or rcx, 0x1
    jmp .reset

.convert_int:
    xor r8d, 0xFFFFFFFF
    inc r8d
    mov rcx, 0x0

.leave:
    cmp rcx, 0x1
    je .convert_int
    mov dword [rsi], r8d
    ret


; int(number of bytes it took from) getOperator(char * string, int * op)
getOp:
    xor rax, rax

.loop:
    mov r9b, byte [rdi]
    cmp r9b, ' '
    je .space_found
    mov dword [rsi], 0x1
    cmp r9b, '+'
    je .found
    mov dword [rsi], 0x2
    cmp r9b, '-'
    je .found
    mov dword [rsi], 0x3
    cmp r9b, '*'
    je .found
    mov dword [rsi], 0x4
    cmp r9b, '/'
    je .found

    ; no op found
    mov rax, 0x0
    mov dword [rsi], 0x0
    jmp .leave

.space_found:
    inc rax
    inc dil
    jmp .loop

.found:
    inc rax

.leave:
    ret

; void termCalc()
termCalc:
    push rbp
    mov rbp, rsp
    SUB rsp, termCalcStack
    ; print header
    mov eax, write          ; syscall number for write
    mov edi, stdout         ; file descriptor stdout
    mov esi, welMessage        ; pointer to the message
    mov edx, welMessageLen     ; length of the message
    syscall

.user_input:
    ; grab user input (main loop)
    mov eax, read                ; syscall number for read
    mov edi, stdin               ; file descriptor stdin
    mov esi, input               ; pointer to the input buffer
    mov edx, bufferLen      ; length of the input buffer
    syscall

    ; if zero or less jump back up
    mov [rsp], eax
    mov qword [rsp + 0x08], input

    cmp eax, 0x01 ; will always have one byte for the null terminator
    jle .user_input
    dec qword [rsp]

    ; if exit is typed then leave
    mov ecx, exitCommandLen ; Only compare to the length of the exit string.
    ; this is a wild command.
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
    ; the expected format will be an int followed by an operator and then another int
    ; (int) (operator) (int)

    ; first int
    mov rdi, input
    lea rsi, [rsp + 0x10]
    call getInt
    cmp rax, 0x0
    je .error

    mov [rsp + 0x28], rax
    mov r8, input
    add r8, [rsp + 0x28]

    ; operator
    lea rsi, [rsp + 0x18]
    mov rdi, r8
    call getOp
    cmp rax, 0x0
    je .error

    add [rsp + 0x28], rax
    mov r8, input
    add r8, [rsp + 0x28]

    ; second int
    mov rdi, r8
    lea rsi, [rsp + 0x20]
    call getInt
    cmp rax, 0x0
    je .error

    ; ensure that the entire string was parsed now
    add [rsp + 0x28], rax
    mov r8, input
    add r8, [rsp + 0x28]
    SUB r8, qword [rsp] ; current input ptr - input length
    cmp r8d, dword [rsp + 0x08]
    jne .error

    ; perform arithmetic
    mov r10d, dword [rsp + 0x10]
    mov r11d, dword [rsp + 0x20]
    cmp dword [rsp + 0x18], 0x01
    je .add_op

    cmp dword [rsp + 0x18], 0x02
    je .sub_op

    cmp dword [rsp + 0x18], 0x03
    je .mult_op

    cmp dword [rsp + 0x18], 0x04
    je .div_op

    ; jump forever
    jmp .user_input

.error:
    mov eax, write          ; syscall number for write
    mov edi, stdout         ; file descriptor stdout
    mov esi, format         ; pointer to the message
    mov edx, formatLen      ; length of the message
    syscall
    jmp .user_input

.add_op:
    add r10d, r11d
    jmp .print_value

.sub_op:
    SUB r10d, r11d
    jmp .print_value

.mult_op:
    imul r10d, r11d
    jmp .print_value

.div_op:
    mov rdx, 0
    mov eax, r10d
    div r11d
    mov r10d, eax
    jmp .print_value

.print_value:
    mov edi, r10d
    mov esi, output
    mov edx, bufferLen 
    call toString

    mov edx, eax            ; length of the message
    mov eax, write          ; syscall number for write
    mov edi, stdout         ; file descriptor stdout

    ; configure output buffer
    mov esi, output
    add esi, bufferLen
    mov r11d, edx
    dec r11d
    SUB esi, r11d
    syscall
    jmp .user_input

.end:
    add rsp, termCalcStack
    pop rbp
    ret

_start:
    ; go to the "main" function. I do it this way so that once the function
    ; returns it will not go through to another label.
    jmp main

; create a basic term calculator
main:
    call termCalc
    ; syscall: exit(0)
    mov eax, 60       ; syscall number for sys_exit (60)
    xor edi, edi      ; exit code 0
    syscall
