#ifndef MAKE_UNIVERSAL_PROXY_H
#define MAKE_UNIVERSAL_PROXY_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    PROXY_NONE = 0,
    PROXY_HTTP,
    PROXY_HTTPS,
    PROXY_FTP,
    PROXY_SOCKS
} ProxyType;

typedef struct {
    ProxyType type;
    char *host;
    int port;
    bool enabled;
} ProxyConfig;

typedef struct {
    ProxyConfig http;
    ProxyConfig https;
    ProxyConfig ftp;
    ProxyConfig socks;
} ProxySettings;

/*
 * Initialize all proxy settings.
 */
void proxy_settings_init(ProxySettings *settings);

/*
 * Release memory owned by ProxySettings.
 */
void proxy_settings_destroy(ProxySettings *settings);

/*
 * Resolve system proxy configuration.
 *
 * Gopher is intentionally unsupported.
 */
int proxy_settings_load(ProxySettings *settings);

/*
 * Resolve the proxy appropriate for a URI scheme.
 */
const ProxyConfig *
proxy_for_scheme(const ProxySettings *settings, const char *scheme);

#ifdef __cplusplus
}
#endif

#endif
