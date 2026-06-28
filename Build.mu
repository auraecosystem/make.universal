manifest "1.0"
project {
    name        = "my-webapp"
    version     = "1.0.0"
    description = "Universal cross-platform application"
    author      = "Seriki Yakub"
    license     = "MIT"
    homepage    = "https://github.com/auraecosystem/make.universal"
}
language "c" {
    standard = "c17"
    compiler = "clang"
    flags = [
        "-Wall",
        "-Wextra",
        "-O2"
    ]
}
sources {
    include = [
        "src/**/*.c"
    ]
    headers = [
        "include/**/*.h"
    ]
    exclude = [
        "tests/**"
    ]
}
output {
    directory = "build"
    executable = "my_app"
}
platform "macos" {
    deployment = "11.0"
    architectures = [
        "arm64",
        "x86_64"
    ]
    universal = true
}
platform "linux" {
    architectures = [
        "x86_64",
        "aarch64"
    ]
}
platform "windows" {
    architectures = [
        "x64"
    ]
}
dependencies {
    system = [
        "zlib",
        "openssl"
    ]
}
testing {
    enabled = true
    coverage = true
}
security {
    scan = true
    cve = true
    osv = true
    sbom = true
    sarif = true
    fail_on = "critical"
}
release {
    checksum = [
        "sha256",
        "sha512"
    ]
    sign = true
    provenance = true
}
package {
    formats = [
        "zip",
        "tar.gz"
    ]
}
