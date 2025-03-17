.globl add_values64, add_values32, two_sum_n2
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

    # leetcode add two numbers problem with n^2 solution
    # int* two_sum_n2(int * nums, int numsSize, int target, int* returnSize)
two_sum_n2:
    # move parameters to gprs or the stack
    push rbp
    mov rbp, rsp
    sub rsp, 0x48
    mov qword ptr [rsp+0x10], rdi # int * nums
    mov dword ptr [rsp+0x18], esi # int numsSize
    mov dword ptr [rsp+0x20], edx # int target
    mov dword ptr [rcx], 0
    mov qword ptr [rsp+0x30], rcx # int target


    # get some memory the return array
    mov rdi, 8
    call malloc
    mov qword ptr [rsp+0x40], rax # don't check if malloc failed cause I don't know how to do that

    mov rcx, qword ptr [rsp + 0x30]
    # double loop through nums until a combo equals the target
    xor r8, r8  # i
    sub r8, 1
    xor r9, r9  # j

.inner:
    add r8, 1
    mov r9, r8
    add r9, 1 # always start as 1 more than i
    cmp r8d, dword ptr [rsp+0x18] # first check if we are over size
    je .cleanup

.outter:
    cmp r9d, dword ptr [rsp+0x18] # first check if we are over size
    je .inner

    # perform operation
    xor r10, r10
    mov r10, [rsp+0x10]
    mov r10d, dword ptr [r10+r8*4]
    mov r11, [rsp+0x10]
    mov r11d, dword ptr [r11+r9*4]
    add r10d, r11d
    cmp r10d, dword ptr [rsp+0x20]
    je .target
    add r9, 1
    jmp .outter

.target:
    # this means the current r8 & r9 are valid
    lea rax, qword ptr [rsp+0x40]
    mov dword ptr [rcx], 2
    mov dword ptr [rax], r8d
    mov dword ptr [rax+4], r9d

    # cleanup and return
.cleanup:
    add rsp, 0x48
    pop rbp
    ret
