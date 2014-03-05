#include <stdlib.h>
#include <string.h>

#include "netutil.h"

#ifdef _WIN32
    #define DLL_EXPORT __declspec(dllexport)
#else
    #define DLL_EXPORT __attribute__ ((visibility ("default")))
#endif

size_t san_c(const char * input)
{
    unsigned int count = strlen(input);

    const char * i;
    for(i = input; *i; i++)
    {
        if(*i == '\\' || *i == '\'')
        {
            count++;
        }
    }

    return count;
}

char * san_cpy(char * out_buf, const char * in_buf)
{
    const char * i_in = in_buf;
    char * i_out = out_buf;
    while(*i_in)
    {
        if(*i_in == '\\' || *i_in == '\'')
        {
            *(i_out++) = '\\';
        }
        *(i_out++) = *(i_in++);
    }
    return i_out;
}

DLL_EXPORT const char * nudge(int n, char *v[])
{
    if(n != 4)
    {
        return "";
    }

    size_t out_c = san_c(v[0]) + san_c(v[2]) + san_c(v[3]);

    char * san_out = malloc(out_c + 57);

    char * san_i = san_out;
    strcpy(san_i, "(dp1\nS'ip'\np2\nS'");
    san_i += 16;
    san_i = san_cpy(san_i, v[2]);
    strcpy(san_i, "'\np3\nsS'data'\np4\n(lp5\nS'");
    san_i += 24;
    san_i = san_cpy(san_i, v[0]);
    strcpy(san_i, "'\np6\naS'");
    san_i += 8;
    san_i = san_cpy(san_i, v[3]);
    strcpy(san_i, "'\np7\nas.");

    socket_t nudge_sock = connect_sock(v[1], "45678");
    send_n(nudge_sock, san_out, out_c + 56);
    close_socket(nudge_sock);

    free(san_out);

    return "1";
}

