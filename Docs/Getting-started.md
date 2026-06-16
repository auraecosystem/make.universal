---
name: Getting-started.md
---
 
```markdown
Getting started — makeuniversal

This page provides the same quickstart as the website and more detail for developers.

## Prerequisites

- Docker (for containerized development)
- gcc/clang and build-essential for native builds
- make

## Quick commands

Build development images:
- make node
- make python

Build & run the demo server locally:
- gcc -std=c11 -Wall -Wextra -O2 -o server/server server/server.c
- ./server/server

Run proxy parser unit tests (if added):
- gcc -std=c11 -Wall -Wextra -O2 -o server/tests/proxy_test server/tests/proxy_test.c server/rsc/@stud/Proxy-Protocol.c
- ./server/tests/proxy_test

## Where to look

- Playground.cpp — C++ demo that exercises expression types
- templates/elf-analyzer/Main.cpp.tpl — ELF analyzer template
- server/ — small gateway and proxy logic
- Lmlm.dev/ — installer scripts and setup tools
- Docs/ and WEB4_Whitepaper_Complete.mk — architecture and whitepaper material

## Security notes

- Inspect installer scripts before running (they use sudo/apt and network downloads).
- The PROXY protocol parser has conservative parsing and validation for both v1 and v2.

## Contributing

See CONTRIBUTING.md in the repository root for guidelines.
