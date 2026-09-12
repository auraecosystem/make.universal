#include "proxy/proxy.h"

#include <assert.h>
#include <stdio.h>

static void test_supported_protocols(void)
{
    ProxySettings settings;
    const ProxyConfig *proxy;

    proxy_settings_init(&settings);

    proxy = proxy_for_scheme(&settings, "http");
    assert(proxy != NULL);
    assert(proxy->type == PROXY_HTTP);

    proxy = proxy_for_scheme(&settings, "https");
    assert(proxy != NULL);
    assert(proxy->type == PROXY_HTTPS);

    proxy = proxy_for_scheme(&settings, "ftp");
    assert(proxy != NULL);
    assert(proxy->type == PROXY_FTP);

    proxy = proxy_for_scheme(&settings, "socks");
    assert(proxy != NULL);
    assert(proxy->type == PROXY_SOCKS);

    proxy_settings_destroy(&settings);
}

static void test_gopher_removed(void)
{
    ProxySettings settings;

    proxy_settings_init(&settings);

    /*
     * Exact behavioral requirement from the patch:
     * Gopher must no longer resolve to a proxy configuration.
     */
    assert(proxy_for_scheme(&settings, "gopher") == NULL);
    assert(proxy_for_scheme(&settings, "GOPHER") == NULL);

    proxy_settings_destroy(&settings);
}

int main(void)
{
    test_supported_protocols();
    test_gopher_removed();

    puts("proxy tests: PASS");

    return 0;
}
