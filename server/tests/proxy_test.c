// Simple unit tests for read_evt (Proxy-Protocol.c).
// Compile with:
//   gcc -std=c11 -Wall -Wextra -O2 -o server/tests/proxy_test server/tests/proxy_test.c server/rsc/@stud/Proxy-Protocol.c
// Run: ./server/tests/proxy_test

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>

extern int read_evt(int fd);       // implemented in Proxy-Protocol.c
extern struct sockaddr_storage from;
extern struct sockaddr_storage to;

static int run_with_message(const char *msg, int expect_ret) {
    int sv[2];
    if (socketpair(AF_UNIX, SOCK_STREAM, 0, sv) != 0) {
        perror("socketpair");
        return 0;
    }

    // Send the message fully then invoke read_evt on the other end.
    ssize_t s = write(sv[0], msg, strlen(msg));
    if (s < 0) {
        perror("write");
        close(sv[0]); close(sv[1]);
        return 0;
    }

    int r = read_evt(sv[1]);

    close(sv[0]);
    close(sv[1]);

    if (r != expect_ret) {
        fprintf(stderr, "read_evt returned %d, expected %d for message: %.60s\n", r, expect_ret, msg);
        return 0;
    }

    return 1;
}

static int test_tcp4_valid() {
    const char *hdr = "PROXY TCP4 127.0.0.1 127.0.0.2 12345 80\r\n";
    int sv[2];
    if (socketpair(AF_UNIX, SOCK_STREAM, 0, sv) != 0) {
        perror("socketpair");
        return 0;
    }
    if (write(sv[0], hdr, strlen(hdr)) < 0) { perror("write"); close(sv[0]); close(sv[1]); return 0; }

    int r = read_evt(sv[1]);
    if (r != 1) { fprintf(stderr, "TCP4 valid: read_evt=%d\n", r); close(sv[0]); close(sv[1]); return 0; }

    struct sockaddr_in *sfrom = (struct sockaddr_in *)&from;
    struct sockaddr_in *sto   = (struct sockaddr_in *)&to;
    char buf_from[INET_ADDRSTRLEN], buf_to[INET_ADDRSTRLEN];
    inet_ntop(AF_INET, &sfrom->sin_addr, buf_from, sizeof(buf_from));
    inet_ntop(AF_INET, &sto->sin_addr, buf_to, sizeof(buf_to));
    int sport = ntohs(sfrom->sin_port);
    int dport = ntohs(sto->sin_port);

    int ok = (strcmp(buf_from, "127.0.0.1") == 0) &&
             (strcmp(buf_to,   "127.0.0.2") == 0) &&
             (sport == 12345) &&
             (dport == 80);

    if (!ok) {
        fprintf(stderr, "TCP4 valid: parsed %s:%d -> %s:%d\n", buf_from, sport, buf_to, dport);
    }

    close(sv[0]); close(sv[1]);
    return ok;
}

static int test_unknown() {
    const char *hdr = "PROXY UNKNOWN\r\n";
    return run_with_message(hdr, 1);
}

static int test_tcp4_bad_ip() {
    const char *hdr = "PROXY TCP4 999.999.999.999 127.0.0.2 12345 80\r\n";
    return run_with_message(hdr, -1);
}

int main(void) {
    int ok = 1;

    printf("Running proxy parser tests...\n");

    ok &= test_tcp4_valid();
    printf("test_tcp4_valid: %s\n", (ok ? "PASS" : "FAIL"));

    int r2 = test_unknown();
    printf("test_unknown: %s\n", (r2 ? "PASS" : "FAIL"));
    ok &= r2;

    int r3 = test_tcp4_bad_ip();
    printf("test_tcp4_bad_ip (should reject): %s\n", (r3 ? "FAIL (unexpected accept)" : "PASS (rejected)"));
    ok &= !r3;

    if (!ok) {
        fprintf(stderr, "One or more tests failed\n");
        return 2;
    }
    printf("All proxy tests passed\n");
    return 0;
}
