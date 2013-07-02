TARGET=$(shell find . -name '*.s' -o -name '*.c')
all:x86 x64
target:
	echo $(TARGET)

AS_64_OPTS := --64
LD_64_OPTS := --melf_x86_64 

define build-64
as $(AS_64_OPTS) -o $($1:.s=.o)$1
ld $(LD_64_OPTS) -o $($1:.s=) $($1:.s=.0)
endef

x64:
	$(call build-64 dynamic/linked-exit.s)
	$(call build-64 dynamic/linker-fd-reuse.s)
	gcc -o loaders/dynamic-loader loaders/dynamic-loader.c
	as -o loaders/loader-64.o loaders/loader-64.s
	ld -o loaders/loader-64 loaders/loader-64.o
	gcc -o loaders/socket-loader loaders/socket-loader.c 
	as -o self-modifying/packer.o self-modifying/packer.s 
	ld -o self-modifying/packer self-modifying/packer.o
	as -o dynamic/poly-linker-fd-reuse.o dynamic/poly-linker-fd-reuse.s 
	ld -o dynamic/poly-linker-fd-reuse dynamic/poly-linker-fd-reuse.o 
	as -o self-modifying/decoder-no-mmap.o self-modifying/decoder-no-mmap.s 
	ld -o self-modifying/decoder-no-mmap self-modifying/decoder-no-mmap.o
	as -o self-modifying/decoder.o self-modifying/decoder.s 
	ld -o self-modifying/decoder self-modifying/decoder.o
	as -o null-free/setuid_binsh.o null-free/setuid_binsh.s
	ld -o null-free/setuid_binsh null-free/setuid_binsh.o
	as -o socket-reuse/socket-reuse.o socket-reuse/socket-reuse.s 
	ld -o socket-reuse/socket-reuse socket-reuse/socket-reuse.o
	gcc -o socket-reuse/socket-reuse-send socket-reuse/socket-reuse-send.c 
	as -o ascii-shellcode/ascii_binsh.o ascii-shellcode/ascii_binsh.s 
	ld -o ascii-shellcode/ascii_binsh ascii-shellcode/ascii_binsh.o
	as -o environment/getpc-64.o environment/getpc-64.s
	ld -o environment/getpc-64 environment/getpc-64.o
	as -o generators/hash-generator.o generators/hash-generator.s 
	ld -o generators/hash-generator generators/hash-generator.o
	as -o environment/getpc-64-alt.o environment/getpc-64-alt.s 
	ld -o environment/getpc-64-alt environment/getpc-64-alt.o 
	as -o environment/int3-detect-64.o environment/int3-detect-64.s 
	ld -o environment/int3-detect-64 environment/int3-detect-64.o
	as -o environment/lastcall-64.o environment/lastcall-64.s 
	ld -o environment/lastcall-64 environment/lastcall-64.o
	as -o environment/lastcall-alphanum.o environment/lastcall-alphanum.s 
	ld -o environment/lastcall-alphanum environment/lastcall-alphanum.o

x86:
	as -o loaders/loader-32.o loaders/loader-32.s
	ld -o loaders/loader-32 loaders/loader-32.o
	as -o self-modifying/packer-32.o self-modifying/packer-32.s 
	ld -o self-modifying/packer-32 self-modifying/packer-32.o
	as -o self-modifying/decoder-32.o self-modifying/decoder-32.s 
	ld -o self-modifying/decoder-32 self-modifying/decoder-32.o
	as -o null-free/write-file-32.o null-free/write-file-32.s 
	ld -o null-free/write-file-32 null-free/write-file-32.o
	as -o environment/getpc-32.o environment/getpc-32.s
	ld -o environment/getpc-32 environment/getpc-32.o
	as -o environment/lastcall-32.o environment/lastcall-32.s 
	ld -o environment/lastcall-32 environment/lastcall-32.o

clean:
	find . |xargs file |grep ELF |cut -d':' -f1 |xargs rm

