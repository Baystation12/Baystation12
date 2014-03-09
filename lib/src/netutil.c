#include "netutil.h"
#include "string.h"

int net_ready = 0;
void net_init()
{
    #ifdef _WIN32
    WSADATA wsa;
    WSAStartup(MAKEWORD(2,0),&wsa);
    #endif
    net_ready = 1;
}

socket_t connect_sock(char * host, char * port)
{
    if(!net_ready)
    {
        net_init();
    }

    socket_t out_sock = -1;
    struct addrinfo addr_in;
    struct addrinfo * addr_proc;
    int gai_status;

    memset(&addr_in, 0, sizeof(addr_in));

    addr_in.ai_family = AF_UNSPEC;
    addr_in.ai_socktype = SOCK_STREAM;
    addr_in.ai_flags = AI_PASSIVE;

    gai_status = getaddrinfo(host, port, &addr_in, &addr_proc);

    if(gai_status)
    {
        return -1;
    }

    struct addrinfo * ai_p;
    for(ai_p = addr_proc; ai_p != 0; ai_p = ai_p->ai_next)
    {
        out_sock = socket(ai_p->ai_family, ai_p->ai_socktype,
                ai_p->ai_protocol);

        if((int)out_sock == -1)
        {
            continue;
        }
        else if(connect(out_sock, ai_p->ai_addr, ai_p->ai_addrlen) == -1)
        {
            close_socket(out_sock);
            continue;
        }
        else
        {
            break;
        }
    }

    if(!out_sock)
    {
        freeaddrinfo(addr_proc);
        return -1;
    }

    freeaddrinfo(addr_proc);
    return out_sock;
}

void send_n(socket_t sock, const char * buf, size_t n)
{
    size_t to_send = n;
    const char * buf_i = buf;
    while(to_send)
    {
        int sent = send(sock, buf_i, to_send, 0);
        if(sent != -1)
        {
            to_send -= sent;
            buf_i += sent;
        }
        else
        {
            return;
        }
    }
    return;
}

void recv_n(socket_t sock, char * buf, size_t n)
{
    size_t total = 0;
    char * buf_i = buf;
    while(total < n)
    {
        int recved = recv(sock, buf_i, n - total, 0);
        if(recved > 0)
        {
            total += recved;
            buf_i += recved;
        }
        else
        {
            return;
        }
    }
    return;
}

