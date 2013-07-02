# 10 bytes
jmp startup
pc:
  nop
startup:
  lea -1(%rip), %rax  # the %rax register now contains the address of `pc'.
