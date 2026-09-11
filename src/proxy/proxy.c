#include "proxy/proxy.h"

#include <stdlib.h>
#include <string.h>
#include <strings.h>

static void proxy_config_init(ProxyConfig *proxy, ProxyType type)
{
    if (proxy == NULL) {
        return;
    }

    proxy->type = type;
    proxy->host = NULL;
    proxy->port = 0;
    proxy->enabled = false;
}

static void proxy_config_destroy(ProxyConfig *proxy)
{
    if (proxy == NULL) {
        return;
    }

    free(proxy->host);

    proxy->host = NULL;
    proxy->port = 0;
    proxy->enabled = false;
}

void proxy_settings_init(ProxySettings *settings)
{
    if (settings == NULL) {
        return;
    }

    proxy_config_init(&settings->http, PROXY_HTTP);
    proxy_config_init(&settings->https, PROXY_HTTPS);
    proxy_config_init(&settings->ftp, PROXY_FTP);
    proxy_config_init(&settings->socks, PROXY_SOCKS);
}

void proxy_settings_destroy(ProxySettings *settings)
{
    if (settings == NULL) {
        return;
    }

    proxy_config_destroy(&settings->http);
    proxy_config_destroy(&settings->https);
    proxy_config_destroy(&settings->ftp);
    proxy_config_destroy(&settings->socks);
}

const ProxyConfig *
proxy_for_scheme(const ProxySettings *settings, const char *scheme)
{
    if (settings == NULL || scheme == NULL) {
        return NULL;
    }

    if (strcasecmp(scheme, "http") == 0) {
        return &settings->http;
    }

    if (strcasecmp(scheme, "https") == 0) {
        return &settings->https;
    }

    if (strcasecmp(scheme, "ftp") == 0) {
        return &settings->ftp;
    }

    if (strcasecmp(scheme, "socks") == 0) {
        return &settings->socks;
    }

    /*
     * Deliberately no "gopher" branch.
     *
     * This is the direct semantic equivalent of removing:
     *
     * if (strcasecmp(cproto, "gopher") == 0) {
     *     ...
     * }
     */

    return NULL;
}
