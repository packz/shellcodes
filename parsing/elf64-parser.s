.section .data
.section .text
 
.globl _start
 
_start:
 jmp startup
 
strlen:
 xor %rdx, %rdx
 
next_byte:
 inc %rdx
 cmpb $0x00, (%rsi,%rdx,1);
 jne next_byte
 ret
 
getpc: 
 mov (%rsp), %rax
 ret
 
startup:
 xor %r15, %r15
 push $0x0a0a0a
 mov %rsp, %r15
 call getpc
 dec %rax
 xor %rcx, %rcx
 push $0x2
 pop %rsi
 
find_header:
 cmpl $0x464c457f, (%rax,%rcx,4)   # Did we find our ELF base pointer?
 je find_sections
 dec %rax
 jmp find_header
 
find_sections:
 # %rax now = base pointer of ELF image.
 xor %rbx, %rbx
 add $0x28, %bl
 xorl (%rax,%rbx,1), %ecx             # %rcx = offset to section headers
 addq %rax, %rcx                      # %rcx = absolute address to section headers
 
 # each section header is 0x40 bytes in length.
next_section:
 xor %rbx, %rbx
 xor %rbp, %rbp
 add $0x40, %rcx
 # %rcx now = address to first entry
 add $0x04, %bl
 xor (%rcx,%rbx,1), %ebp              # %rbp now contains type
 cmp $0x02,  %bpl
 jne next_section
 
found_symbols:
 xor %r8, %r8
 mov %rcx, %r8                        # %rcx = pointer to top of symbol section header
 add $0x40, %r8                       # %r8  = pointer to top of string table section header
 
 xor %rbx, %rbx
 xor $0x18, %bl                      # pointer to actual section is $0x18 bytes from header base
 
 xor %r9, %r9
 xor %r10, %r10
 xor (%rcx,%rbx,1), %r9
 xor (%r8,%rbx,1), %r10
 addq %rax, %r9                      # r9 should now point to the first symbol
 addq %rax, %r10                     # r10 should now point to the first string
 addq $0x18, %r9
 
next_symbol:
 addq $0x18,%r9
 xor %rcx, %rcx
 xor %rbp, %rbp
 xor %rdi, %rdi
 xor (%r9,%rcx,1), %ebp              # %rbp now contains string offset.
 cmp %rbp, %rdi
 je next_symbol
 
print_symbol_name:
 mov %rbp, %rsi
 addq %r10, %rsi                     # %rsi should now be a pointer to a string
 push $0x01
 pop %rax
 push %rax
 pop %rdi
 call strlen
 syscall
 
 push $0x01
 pop %rax
 push %rax
 pop %rdi
 push $0x02
 pop %rdx
 push %r15
 pop %rsi
 syscall
 jmp next_symbol
