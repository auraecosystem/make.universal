#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

#include "proxy_proto.h"

#define PORT 9000
#define BACKLOG 128

/* simple logging */
static void log_client(proxy_ctx *ctx) {
    char ip[INET6_ADDRSTRLEN];

    if (!ctx->valid) {
        printf("[WARN] Invalid proxy header\n");
        return;
    }

    if (ctx->proto == 2) {
        struct sockaddr_in *s = (struct sockaddr_in*)&ctx->from;
        inet_ntop(AF_INET, &s->sin_addr, ip, sizeof(ip));
        printf("[PROXYv2] Client IP: %s\n", ip);
    }
}

/* handle one connection */
static void handle_client(int cfd)
{
    proxy_ctx ctx;

    int r = proxy_read(cfd, &ctx);

    if (r < 0) {
        printf("[ERROR] proxy parse failed\n");
        close(cfd);
        return;
    }

    log_client(&ctx);

    /* here you would pass fd to:
       - FastAPI gateway
       - AI engine
       - blockchain handler
    */

    /* placeholder response */
    const char *msg = "OK\n";
    send(cfd, msg, strlen(msg), 0);

    close(cfd);
}

int main()
{
    int sfd;
    struct sockaddr_in addr;

    sfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sfd < 0) {
        perror("socket");
        return 1;
    }

    int opt = 1;
    setsockopt(sfd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(PORT);
    addr.sin_addr.s_addr = INADDR_ANY;

    if (bind(sfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        perror("bind");
        return 1;
    }

    if (listen(sfd, BACKLOG) < 0) {
        perror("listen");
        return 1;
    }

    printf("🚀 Web4 Gateway running on port %d\n", PORT);

    while (1) {
        struct sockaddr_in client;
        socklen_t len = sizeof(client);

        int cfd = accept(sfd, (struct sockaddr*)&client, &len);

        if (cfd < 0) {
            if (errno == EINTR) continue;
            perror("accept");
            continue;
        }

        handle_client(cfd);
    }

    close(sfd);
    return 0;
}
