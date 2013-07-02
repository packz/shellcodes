# 90 bytes
_start:
 
xorl %ecx, %ecx
xorl %edx, %edx         #use xor to zero out the registers (removed some not required)
 
push $0x05              #push 0x05 (single byte to remove the null padding used in longs)
pop %eax                #pop that value into eax
push $0x6c              #push part of the file destination as a byte to remove padding
pushl $0x6f6c2f70
pushl $0x6f746b73
pushl $0x65442f74
pushl $0x6f6f722f
movl %esp, %ebx         #move out stack pointer
xorw $0x0641, %cx       #xor the file options as a word into ecx (ecx is 0 so ecx value would be 641)
xorw $0x01b6, %dx       #xor the file permissions as a word into edx (ecx is 0 so edx value would be 1b6)
                        #by using this method of xoring out the nullbytes code size can be reduced as well
      #as remove the null bytes
int $0x80               #execute open()
 
movl %eax, %ebx         #move the file handle into ebx for write()
push $0x04              #push 0x04
pop %eax                #pop it into eax for use in write()
pushl $0x6c6f6c6a       #push part of the null terminated hex string onto the stack
pop %ecx                #pop it into ecx for modification
shr $0x08, %ecx         #shift it to the right by 0x08 to put the nullbyte back into the string without
                        #having it directly in the code
pushl %ecx              #push the modified string back onto the stack
pushl $0x20736920
pushl $0x73696874
movl %esp, %ecx         #move the stack pointer to ecx
push $0xb               #push the size of the stack in hex 
pop %edx                #pop it back into the proper register
pushl %ebx              #push the file descriptor onto the stack for the next function
int $0x80               #write the file
 
pop %ebx                #get the file descriptor back
push $0x06              #push 0x06 to the stack
pop %eax                #pop it into eax for close()
int $0x80               #close the file
 
push $0x01              #push exit() onto the stack
pop %eax                #and put it in the register
push $0x05              #push the return value of 5
pop %ebx                #and put it in ebx
int $0x80               #and exit
