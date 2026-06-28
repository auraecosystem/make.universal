# ==========================================================
# make.universal Build Specification v1
# File: build.mu
# ==========================================================
project {
    name        = "my_app"
    version     = "1.0.0"
    description = "Universal cross-platform application"
    license     = "MIT"
}
language "c" {
    compiler = "clang"
    standard = "c17"
    warnings = [
        "all",
        "extra",
        "pedantic"
    ]
    optimize = "O2"
    defines = [
        "NDEBUG"
    ]
}
sources {
    include = [
        "src/**/*.c"
    ]
    headers = [
        "include/**/*.h"
    ]
}
output {
    directory = "build"
    binary = "my_app"
    artifacts = [
        "binary",
        "universal",
        "static-library",
        "shared-library"
    ]
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
        "x64",
        "arm64"
    ]
}
testing {
    enabled = true
    framework = "ctest"
    coverage = true
}
security {
    scan = true
    cve = true
    osv = true
    sbom = true
    sarif = true
    secrets = true
    licenses = true
    fail_on = "critical"
}
docker {
    enabled = true
    images = [
        "node",
        "python"
    ]
}
package {
    formats = [
        "tar.gz",
        "zip"
    ]
}
release {
    sign = true
    provenance = true
    checksum = [
        "sha256",
        "sha512"
    ]
    publish = true
}
commands {
    prebuild = [
        "echo Preparing build..."
    ]
    postbuild = [
        "echo Build completed."
    ]
}
