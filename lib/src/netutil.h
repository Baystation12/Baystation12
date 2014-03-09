#ifndef NETUTIL_H
#define NETUTIL_H

#ifdef _WIN32

#include <winsock2.h>
#include <ws2tcpip.h>
typedef SOCKET socket_t;

#define close_socket(sock) closesocket(sock)

#else

#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <unistd.h>
typedef int socket_t;

#define close_socket(sock) close(sock)

#endif

extern int net_ready;
void init_net();

socket_t connect_sock(char * host, char * port);

void send_n(socket_t sock, const char * buf, size_t n);
void recv_n(socket_t sock, char * buf, size_t n);

#endif

