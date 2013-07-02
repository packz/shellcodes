#include <stdio.h>
#include <sys/mman.h>
#include <string.h>

int main(int argc, char *argv[])
{
  int (*fp)();
  void *mem = mmap(0, 0x1000, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
  memcpy(mem, argv[1], strlen(argv[1]));
  fp = (int(*)())mem;
  (int)(*fp)();
}
