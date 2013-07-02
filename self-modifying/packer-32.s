# 37 bytes
.section .data

.section .text

.global _start
 
_start:
	pop %ecx
	pop %ecx
	pop %ecx                        #arg1 pointer

	xor %ebx, %ebx    
 	push %ebx
	pop %edx                        #zero out ebx and edx

count_chars:
	cmpb %dl, (%ecx, %ebx, 1)
	je write
	xor $0x3, (%ecx, %ebx, 1)
	inc %ebx
	jmp count_chars                 #counts characters and xor encode them
 
write:
	push $4
	pop %eax
	mov %ebx, %edx
	push $2
	pop %ebx
	int $0x80                        #writes encoded chars to stdout

exit:
	xor %eax, %eax
	mov %eax, %ebx
	inc %eax
	int $0x80                        #exits

