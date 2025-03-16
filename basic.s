.globl add_values64, add_values32
# Note that we are not using that gross intel syntax
.intel_syntax noprefix
.section .text
    # add two values function uint64_t add_values(const uint64_t a, const uint64_t b);
    add_values64: 
    # grab the arguments directly from regs for SPEED
    xor rax, rax
    mov rax, rdi
    # perform the operation and save directly to return reg
    add rax, rsi
    ret

    # add two values function int add_values(const int a, const int b);
    add_values32: 
    # grab the arguments directly from regs for SPEED
    xor eax, eax
    mov eax, edi
    # perform the operation and save directly to return reg
    add eax, esi
    ret
