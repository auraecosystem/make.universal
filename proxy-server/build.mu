project {
    name        = "make-universal-proxy"
    version     = "1.0.0"
    description = "Modern cross-platform proxy configuration"
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
    binary = "make-universal-proxy"

    artifacts = [
        "binary",
        "static-library",
        "shared-library"
    ]
}

platform "linux" {
    architectures = [
        "x86_64",
        "aarch64"
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

platform "windows" {
    architectures = [
        "x64",
        "arm64"
    ]
}

testing {
    enabled = true
    framework = "ctest"
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
