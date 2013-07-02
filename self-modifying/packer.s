# 55 bytes
.section .data
.section .text
.globl _start
 
_start:
    pop %rbx  # argc
    pop %rbx  # arg0
    pop %rbx  # arg1 pointer

    xor %rsi, %rsi
    push $0x34
    pop %rdi    
 
count_chars:
    cmpb %dil, (%rbx, %rsi, 1)
    int3
    je write
    xor $0x16, (%rbx, %rsi, 1)
    inc %rsi
    jmp count_chars

write:
    mov $0x1, %rax
    mov $0x1, %rdi
    mov %rsi, %rdx
    mov %rbx, %rsi
    syscall

exit:
    push $60
    pop %rax
    xor %rdi, %rdi
    syscall
