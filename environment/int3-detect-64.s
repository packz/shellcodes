# 24 bytes

.text
.global _start
_start:
 
  jmp startup
 
go_retro:
  pop %rcx
  inc %rcx
  jmp *%rcx
 
startup:
  call go_retro
 
volatile_segment:
  push $0x3458686a
  push $0x0975c084
  nop
