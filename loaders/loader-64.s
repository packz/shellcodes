# 79 bytes

.section .data
.section .text
.globl _start
 
_start:
    pop %rbx  # argc
    pop %rbx  # arg0
    pop %rbx  # arg1 pointer

    push $0x9
    pop %rax
 
    xor %rdi, %rdi
    push %rdi
    pop %rsi
    inc %rsi
    shl $0x12, %rsi
    push $0x7
    pop %rdx
    push $0x22
    pop %r10
 
    push %rdi
    push %rdi
    pop %r8
    pop %r9
 
    syscall   # The syscall for the mmap().

inject: 
    xor %rsi, %rsi
    push %rsi
    pop %rdi    
 
inject_loop:
    cmpb %dil, (%rbx, %rsi, 1)
    je inject_finished
    movb (%rbx, %rsi, 1), %r10b
    movb %r10b, (%rax,%rsi,1)
    inc %rsi
    jmp inject_loop
 
ret_to_shellcode:
    push %rax
    ret
 
inject_finished:
    inc %rsi 
    movb $0xc3, (%rax, %rsi, 1)
    call ret_to_shellcode

exit:
    push $60
    pop %rax
    xor %rdi, %rdi
    syscall
