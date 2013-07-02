# 11 bytes

jmp startup
getpc:
   mov (%esp), %eax
   ret
startup:
call getpc       # the %eax register now contains %eip on the next line
