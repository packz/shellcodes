# 12 - bytes

jmp startup
getpc:
   mov (%rsp), %rax
   ret
startup:
call getpc       # the %rax register now contains %rip on the next line
