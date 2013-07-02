TARGET=$(shell find . -name '*.s' -o -name '*.c')
all:x86 x64
target:
	echo $(TARGET)

AS_64_OPTS := --64
LD_64_OPTS := -melf_x86_64

define build-64
@echo [+] $(1:.s=)
@as $(AS_64_OPTS) -o $(1:.s=.o) $1
@ld $(LD_64_OPTS) -o $(1:.s=) $(1:.s=.o)
endef

x64:
	$(call build-64,dynamic/linked-exit.s)
	$(call build-64,dynamic/linker-fd-reuse.s)
	gcc -o loaders/dynamic-loader loaders/dynamic-loader.c
	$(call build-64,loaders/loader-64.s)
	gcc -o loaders/socket-loader loaders/socket-loader.c 
	$(call build-64,self-modifying/packer.s)
	$(call build-64,dynamic/poly-linker-fd-reuse.s)
	$(call build-64,self-modifying/decoder-no-mmap.s)
	$(call build-64,self-modifying/decoder.s)
	$(call build-64,null-free/setuid_binsh.s)
	$(call build-64,socket-reuse/socket-reuse.s)
	gcc -o socket-reuse/socket-reuse-send socket-reuse/socket-reuse-send.c 
	$(call build-64,ascii-shellcode/ascii_binsh.s)
	$(call build-64,environment/getpc-64.s)
	$(call build-64,generators/hash-generator.s)
	$(call build-64,environment/getpc-64-alt.s)
	$(call build-64,environment/int3-detect-64.s)
	$(call build-64,environment/lastcall-64.s)
	$(call build-64,environment/lastcall-alphanum.s)

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

