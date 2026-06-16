#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define PROXY_V2_SIG "\r\n\r\n\0\r\nQUIT\n"
#define PROXY_V2_SIG_LEN 12
#define MAX_PROXY_HEADER 512

struct sockaddr_storage from;
struct sockaddr_storage to;

/* Safe helper: zero and cast sockaddr */
static void set_ipv4(struct sockaddr_storage *ss, uint32_t ip, uint16_t port) {
    struct sockaddr_in *s = (struct sockaddr_in *)ss;
    memset(s, 0, sizeof(*s));
    s->sin_family = AF_INET;
    s->sin_addr.s_addr = ip;
    s->sin_port = port;
}

static void set_ipv6(struct sockaddr_storage *ss, uint8_t ip[16], uint16_t port) {
    struct sockaddr_in6 *s = (struct sockaddr_in6 *)ss;
    memset(s, 0, sizeof(*s));
    s->sin6_family = AF_INET6;
    memcpy(&s->sin6_addr, ip, 16);
    s->sin6_port = port;
}

/* Safe read evt */
int read_evt(int fd)
{
    union {
        struct {
            char line[108];
        } v1;

        struct {
            uint8_t sig[12];
            uint8_t ver_cmd;
            uint8_t fam;
            uint16_t len;

            union {
                struct {
                    uint32_t src_addr;
                    uint32_t dst_addr;
                    uint16_t src_port;
                    uint16_t dst_port;
                } ip4;

                struct {
                    uint8_t src_addr[16];
                    uint8_t dst_addr[16];
                    uint16_t src_port;
                    uint16_t dst_port;
                } ip6;

                struct {
                    uint8_t src_addr[108];
                    uint8_t dst_addr[108];
                } unx;
            } addr;

        } v2;
    } hdr;

    int ret, size;

    /* STEP 1: Safe peek with retry */
    do {
        ret = recv(fd, &hdr, sizeof(hdr), MSG_PEEK);
    } while (ret < 0 && errno == EINTR);

    if (ret < 0)
        return (errno == EAGAIN || errno == EWOULDBLOCK) ? 0 : -1;

    if (ret == 0)
        return -1;

    /* HARD LIMIT: prevent memory abuse */
    if (ret > MAX_PROXY_HEADER)
        return -1;

    /* =========================
       PROXY v2 detection
       ========================= */
    if (ret >= 16 &&
        memcmp(hdr.v2.sig, PROXY_V2_SIG, PROXY_V2_SIG_LEN) == 0 &&
        (hdr.v2.ver_cmd & 0xF0) == 0x20)
    {
        uint16_t len = ntohs(hdr.v2.len);
        size = 16 + len;

        if (size > ret || size > MAX_PROXY_HEADER)
            return -1;

        uint8_t cmd = hdr.v2.ver_cmd & 0x0F;

        if (cmd == 0x01) { /* PROXY */

            switch (hdr.v2.fam) {

                case 0x11: /* TCP IPv4 */
                    set_ipv4(&from,
                        hdr.v2.addr.ip4.src_addr,
                        hdr.v2.addr.ip4.src_port);

                    set_ipv4(&to,
                        hdr.v2.addr.ip4.dst_addr,
                        hdr.v2.addr.ip4.dst_port);
                    break;

                case 0x21: /* TCP IPv6 */
                    set_ipv6(&from,
                        hdr.v2.addr.ip6.src_addr,
                        hdr.v2.addr.ip6.src_port);

                    set_ipv6(&to,
                        hdr.v2.addr.ip6.dst_addr,
                        hdr.v2.addr.ip6.dst_port);
                    break;

                case 0x00: /* LOCAL */
                    /* keep kernel-provided address */
                    break;

                default:
                    return -1;
            }
        }
        else if (cmd == 0x00) {
            /* LOCAL command → ignore */
        }
        else {
            return -1;
        }

        goto consume;
    }

    /* =========================
       PROXY v1 detection (robust parsing)
       ========================= */
    if (ret >= 8 && memcmp(hdr.v1.line, "PROXY", 5) == 0)
    {
        char *end = memchr(hdr.v1.line, '\n', ret);

        if (!end)
            return -1;

        size = (int)(end - hdr.v1.line) + 1;

        if (size > ret || size > 108)
            return -1;

        /* copy into a local, NUL-terminated buffer for safe parsing */
        char line[109];
        memcpy(line, hdr.v1.line, size);
        line[size - 1] = '\0'; /* strip final LF */

        /* PROXY v1 forms:
         *  - "PROXY UNKNOWN\r\n"
         *  - "PROXY TCP4 <SRC> <DST> <SPORT> <DPORT>\r\n"
         *  - "PROXY TCP6 <SRC> <DST> <SPORT> <DPORT>\r\n"
         * We parse conservatively using bounded sscanf and inet_pton.
         */

        char proto[16] = {0};
        char src[64] = {0};
        char dst[64] = {0};
        int sport = 0, dport = 0;

        int tokens = sscanf(line, "PROXY %15s %63s %63s %d %d", proto, src, dst, &sport, &dport);

        if (tokens < 1)
            return -1;

        /* "UNKNOWN" -> accept and use kernel-provided address */
        if (strcmp(proto, "UNKNOWN") == 0) {
            goto consume;
        }

        if (strcmp(proto, "TCP4") == 0 || strcmp(proto, "TCP") == 0) {
            if (tokens != 5) return -1; /* require ports for TCP */

            struct in_addr in_src, in_dst;
            if (inet_pton(AF_INET, src, &in_src) != 1) return -1;
            if (inet_pton(AF_INET, dst, &in_dst) != 1) return -1;

            if (sport < 0 || sport > 65535 || dport < 0 || dport > 65535) return -1;

            set_ipv4(&from, in_src.s_addr, htons((uint16_t)sport));
            set_ipv4(&to,   in_dst.s_addr, htons((uint16_t)dport));

            goto consume;
        }
        else if (strcmp(proto, "TCP6") == 0) {
            if (tokens != 5) return -1;

            uint8_t in_src6[16];
            uint8_t in_dst6[16];
            if (inet_pton(AF_INET6, src, in_src6) != 1) return -1;
            if (inet_pton(AF_INET6, dst, in_dst6) != 1) return -1;

            if (sport < 0 || sport > 65535 || dport < 0 || dport > 65535) return -1;

            set_ipv6(&from, in_src6, htons((uint16_t)sport));
            set_ipv6(&to,   in_dst6, htons((uint16_t)dport));

            goto consume;
        }
        else {
            /* Unknown transport/proto */
            return -1;
        }
    }

    /* Unknown protocol → reject */
    return -1;

consume:

    /* STEP 2: consume exact bytes safely */
    {
        char tmp[MAX_PROXY_HEADER];
        int r;

        do {
            r = recv(fd, tmp, size, 0);
        } while (r < 0 && errno == EINTR);

        if (r < 0)
            return -1;
    }

    return 1;
}
