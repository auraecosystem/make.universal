manifest "1.0"
project {
    name    = "{{PROJECT_NAME}}"
    version = "1.0.0"
    type    = "native-c"
}
compiler {
    language = "c"
    standard = "c17"
    toolchain = "clang"
}
sources {
    include = [
        "src/**/*.c"
    ]
}
output {
    executable = "{{PROJECT_NAME}}"
    directory  = "build"
}
platform {
    target = [
        "linux-x86_64",
        "linux-arm64",
        "macos-universal",
        "windows-x64"
    ]
}
