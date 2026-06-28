project "swift_Concurrency" {
    version "1.0"

    language {
        cpp
        swift
        c
    }

    target library {
        type shared

        sources {
            "Actor.cpp"
            "Task.cpp"
            "**/*.swift"
        }

        compile {
            cpp {
                standard c++20
                define "__STDC_WANT_LIB_EXT1__"
            }

            swift {
                experimental "IsolatedAny"
                experimental "Extern"
                strict_memory_safety true
            }
        }

        link {
            dispatch when platform == darwin
            Synchronization when platform == windows
        }

        install {
            include "include/"
            library "lib/"
        }
    }
}
