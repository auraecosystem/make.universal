#include "proxy/proxy.h"

#include <stdlib.h>
#include <string.h>

static char *duplicate_string(const char *value)
{
    size_t length;
    char *copy;

    if (value == NULL || *value == '\0') {
        return NULL;
    }

    length = strlen(value);

    copy = malloc(length + 1);
    if (copy == NULL) {
        return NULL;
    }

    memcpy(copy, value, length + 1);

    return copy;
}

static void load_proxy_from_environment(
    ProxyConfig *proxy,
    const char *primary,
    const char *secondary)
{
    const char *value = NULL;

    if (proxy == NULL) {
        return;
    }

    if (primary != NULL) {
        value = getenv(primary);
    }

    if (value == NULL && secondary != NULL) {
        value = getenv(secondary);
    }

    if (value == NULL || *value == '\0') {
        return;
    }

    /*
     * The complete URI parser can be added here.
     *
     * For now, this adapter deliberately only establishes the
     * modern configuration boundary.
     */
    proxy->host = duplicate_string(value);
    proxy->enabled = proxy->host != NULL;
}

int proxy_settings_load(ProxySettings *settings)
{
    if (settings == NULL) {
        return -1;
    }

    proxy_settings_init(settings);

    /*
     * Modern equivalents of the old protocol-specific settings.
     *
     * HTTP:
     *   http_proxy / HTTP_PROXY
     *
     * HTTPS:
     *   https_proxy / HTTPS_PROXY
     *
     * FTP:
     *   ftp_proxy / FTP_PROXY
     *
     * SOCKS:
     *   all_proxy / ALL_PROXY
     *
     * Gopher intentionally has no entry.
     */

    load_proxy_from_environment(
        &settings->http,
        "http_proxy",
        "HTTP_PROXY"
    );

    load_proxy_from_environment(
        &settings->https,
        "https_proxy",
        "HTTPS_PROXY"
    );

    load_proxy_from_environment(
        &settings->ftp,
        "ftp_proxy",
        "FTP_PROXY"
    );

    load_proxy_from_environment(
        &settings->socks,
        "all_proxy",
        "ALL_PROXY"
    );

    return 0;
}
