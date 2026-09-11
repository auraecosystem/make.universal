```mk
templates/
├── c/
│   ├── main.c.tpl
│   ├── Makefile.tpl
│   └── build.mu.tpl
│
├── cpp/
│   ├── Main.cpp.tpl
│   ├── CMakeLists.txt.tpl
│   ├── Conan.tpl
│   └── build.mu.tpl
│
├── rust/
│   ├── main.rs.tpl
│   └── build.mu.tpl
│
├── go/
│   ├── main.go.tpl
│   └── build.mu.tpl
│
├── python/
│   ├── main.py.tpl
│   └── build.mu.tpl
│
├── node/
│   ├── index.js.tpl
│   └── build.mu.tpl
│
└── swift/
    ├── main.swift.tpl
    └── build.mu.tpl
```

```mk
templates/
└── c/
    ├── main.c.tpl
    ├── Makefile.tpl
    ├── build.mu.tpl
    ├── crc32.c.tpl
    ├── crc32.h.tpl
    ├── crc32_table_gen.c.tpl
    ├── test_crc32.c.tpl
    └── crc32.mk.tpl
```
# Then the generated project could become:
```mu
generated/
└── crc32/
    ├── src/
    │   ├── main.c
    │   ├── crc32.c
    │   └── crc32_table_gen.c
    ├── include/
    │   └── crc32.h
    ├── tests/
    │   └── test_crc32.c
    ├── generated/
    │   └── crc32_table.h
    ├── Makefile
    └── build.mu
```
The really interesting part is build.mu.tpl. If .mu is intended to be your build/orchestration language, don't make it merely another shell script. Give it a semantic build model, for example:
```build.mu.tpl
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
```
That gives your template system a much stronger architecture:
```pq
             Template
                │
                ▼
          build.mu.tpl
                │
                ▼
        Semantic Build Model
                │
       ┌────────┼────────┐
       ▼        ▼        ▼
       C       C++      Rust
       │        │        │
    Makefile  CMake    Cargo
       │        │        │
       └────────┼────────┘
                ▼
             Build
                │
                ▼
             Verify

And this fits particularly well with your Q-lang direction: .mu can describe the intent and relationships of a build rather than forcing every language to use the same build system.

If you upload the existing templates/ files, I can inspect the actual template syntax and design the .mu layer around what you already have rather than inventing a conflicting format.
