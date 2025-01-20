#include "stdafx.h"

#include <stdio.h>
#include <winsock2.h>

#define PORT_NO_SERVER (12345)
#define IP_ADDRESS_SERVER "192.168.100.254"

int main(void)
{
    WSADATA wsaData;
    struct sockaddr_in server;
    SOCKET sfd = -1;
    char buf[32] = { 0 };
    int rc = 0;

    WSAStartup(MAKEWORD(2, 0), &wsaData);

    sfd = socket(AF_INET, SOCK_STREAM, 0);

    server.sin_family = AF_INET;
    server.sin_port = htons(PORT_NO_SERVER);
    server.sin_addr.S_un.S_addr = inet_addr(IP_ADDRESS_SERVER);

    rc = connect(sfd, (struct sockaddr *)&server, sizeof(server));
    if (rc < 0) {
        printf("connect() failed(%d)\n", rc);
        exit(EXIT_FAILURE);
    }

    while (1) {
        memset(buf, 0, sizeof(buf));
        int rs = recv(sfd, buf, sizeof(buf), 0);

        printf("recv %d byte, %s\n", rs, buf);
    }

    WSACleanup();

    return 0;
}