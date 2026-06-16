#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdint.h>
#include <stdio.h>

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
       PROXY v1 detection
       ========================= */
    if (ret >= 8 && memcmp(hdr.v1.line, "PROXY", 5) == 0)
    {
        char *end = memchr(hdr.v1.line, '\n', ret);

        if (!end)
            return -1;

        size = (int)(end - hdr.v1.line) + 1;

        if (size > ret || size > 108)
            return -1;

        hdr.v1.line[size - 1] = '\0';

        /* NOTE:
           In production you should parse with strict tokenizer:
           - inet_pton
           - sscanf with bounds
        */

        goto consume;
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
