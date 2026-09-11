project "crc32" {
    language = "c"
    standard = "c17"

    sources = [
        "src/main.c",
        "src/crc32.c",
        "src/crc32_table_gen.c"
    ]

    headers = [
        "include/crc32.h"
    ]

    generate {
        command = "crc_table_gen"
        output = "generated/crc32_table.h"
    }

    build {
        compiler = "cc"
        flags = [
            "-Wall",
            "-Wextra",
            "-Wpedantic",
            "-O2"
        ]
    }

    test {
        command = "test_crc32"
        expected = "CBF43926"
    }
}
