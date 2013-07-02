# 81 bytes

.text
.globl _start
_start:
jmp startup

calc_hash:
  push %rax
  push %rdx

  initialize_regs:
    push %rdx
    pop %rax
    cld

    calc_hash_loop:
      lodsb
      rol $0xc, %edx
      add %eax, %edx
      test %al, %al
      jnz calc_hash_loop

  calc_done:
    push %rdx
    pop %rsi

  pop %rdx
  pop %rax
ret

startup:
  pop %rax
  pop %rax
  pop %rsi

  xor %rdx, %rdx
  call calc_hash

  push %rsi
  mov %rsp, %rsi

  push %rdx

  mov %rsp, %rcx

  xor %rdi, %rdi
  movb $0x4, %dil
  loop:
    dec %dil
    movb (%rsi,%rdi,1), %al
    movb %al, (%rcx,%rdx,1)
    inc %dl
    cmp %dil, %r10b
    jnz loop

  mov %rcx, %rsi

  inc %rdi
  mov %rdi, %rax

  syscall

  mov $0x3c, %al
  dec %rdi

  syscall
