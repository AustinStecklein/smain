.globl addValues64, addValues32, twoSumN2
# Note that we are not using that gross intel syntax
.intel_syntax noprefix
.section .text
    # add two values function uint64_t add_values(const uint64_t a, const uint64_t b);
addValues64:
    # grab the arguments directly from regs for SPEED
    xor rax, rax
    mov rax, rdi
    # perform the operation and save directly to return reg
    add rax, rsi
    ret

    # add two values function int add_values(const int a, const int b);
addValues32:
    # grab the arguments directly from regs for SPEED
    xor eax, eax
    mov eax, edi
    # perform the operation and save directly to return reg
    add eax, esi
    ret

    # leetcode add two numbers problem with n^2 solution
    # int* two_sum_n2(int * nums, int numsSize, int target, int* returnSize, struct Arena allocator)
twoSumN2:
    # move parameters to gprs or the stack
    push rbp
    mov rbp, rsp
    sub rsp, 0x50
    mov qword ptr [rsp], rdi # int * nums
    mov dword ptr [rsp+0x08], esi # int numsSize
    mov dword ptr [rsp+0x10], edx # int target
    mov dword ptr [rcx], 0
    mov qword ptr [rsp+0x20], rcx # int target
    mov qword ptr [rsp+0x30], r8 # struct Arena allocator

    # default to a null ptr
    mov rax, 0x0

    # double loop through nums until a combo equals the target
    xor r8, r8  # i
    sub r8, 1
    xor r9, r9  # j

.inner:
    inc r8
    mov r9, r8
    # always start as 1 more than i
    inc r9
    cmp r8d, dword ptr [rsp+0x08] # first check if we are over size
    je .cleanup

.outter:
    cmp r9d, dword ptr [rsp+0x08] # first check if we are over size
    je .inner

    # perform operation
    xor r10, r10
    mov r10, [rsp]
    mov r10d, dword ptr [r10+r8*4]
    mov r11, [rsp]
    mov r11d, dword ptr [r11+r9*4]
    add r10d, r11d
    cmp r10d, dword ptr [rsp+0x10]
    je .target
    inc r9
    jmp .outter

.target:
    # this means the current r8 & r9 are valid
    # get some memory the return array
    mov dword ptr [rsp + 0x40], r8d
    mov dword ptr [rsp + 0x44], r9d
    lea rdi, [rsp + 0x30]
    mov rsi, 8
    call mallocArena
    mov rcx, qword ptr [rsp + 0x20]
    mov dword ptr [rcx], 2
    mov r8d, dword ptr [rsp + 0x40]
    mov r9d, dword ptr [rsp + 0x44]
    mov dword ptr [rax], r8d
    mov dword ptr [rax+4], r9d

    # cleanup and return
.cleanup:
    add rsp, 0x50
    pop rbp
    ret

