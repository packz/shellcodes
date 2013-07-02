# 66 bytes

.section .data

.section .text

.global _start

_start:
        pop %edi
        pop %edi
        pop %edi                      #get arg1 pointer (shellcode)

        push $90
        pop %eax                      #mmap() syscall number

        xor %ebx, %ebx
	push %ebx
	push %ebx                     #args 5/6 (null)

	push $0x22                    #arg 4
	push $0x7                     #arg 5
	
        push %ebx
        pop %ecx
        inc %ecx
        shl $0x12, %ecx
        push %ecx                     #arg2 (0x1000)

	push %ebx                     #arg1 (null)

        mov %esp, %ebx                #move pointer to args to ebx for mmap()
        int $0x80


inject:
	xor %esi, %esi
	push %esi
	pop %edx                      #zero out esi and edx

inject_loop:
	cmpb %dl, (%edi, %esi, 1)
	je inject_finished
	movb (%edi, %esi, 1), %cl
	movb %cl, (%eax, %esi, 1)
	inc %esi
	jmp inject_loop               #places shellcode into mmap() memory

ret_to_shellcode:
	push %eax                     #pushes mmap memory address and returns to it
	ret

inject_finished:
	inc %esi
	movb $0xc3, (%eax, %esi, 1)   #adds ret to the code code so that loader can exit
	call ret_to_shellcode

exit:
	xor %eax, %eax
	mov %eax, %ebx
	inc %eax
	int $0x80	               #exit
