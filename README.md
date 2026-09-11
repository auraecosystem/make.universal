# make.universe

A comprehensive build orchestration and tooling platform for the Web4 ecosystem, enabling mixed-language development with container-first workflows, semantic build definitions, and multi-platform templates.

**Repository:** https://github.com/auraecosystem/Makeuniversal.github.io

---

## Table of Contents

### Prerequisites

- Git
- GNU Make
- Docker for containerized builds
- A C/C++ toolchain when working with native examples
- The project's `mu` command for targets that delegate to it

### Build containers

```bash
make node
make python
```

Or build both:

```bash
make build
```

### Verify the repository

```bash
make verify
```

### Run development checks

```bash
make format
make lint
make test
```

### Run security checks

```bash
make security
```

This invokes the project's CVE, OSV, SBOM, SARIF and HTML security-report stages.

### Run the complete release pipeline

```bash
make release
```

The release target executes formatting, linting, tests, verification, security scanning, packaging, signing and publishing in sequence.

## Native gateway example

A lightweight TCP gateway is provided at `server/server.c`. It listens on port `9000` and uses the repository's proxy-protocol implementation.

```bash
gcc -std=c11 -Wall -Wextra -O2 -o server/server server/server.c
./server/server
```

Review the networking and proxy parsing code before exposing the server to an untrusted network.

## Repository map

```text
make.universe/
├── .github/workflows/     CI, build and Pages automation
├── Docs/                  Developer and architecture documentation
├── server/                TCP gateway and proxy-protocol code
├── templates/             Project templates
├── images/                Container build definitions
├── scripts/               Project scripts where present
├── makefile               Primary build/release control surface
├── build.mu               make.universe build configuration
└── README.md              Project documentation
```

## Security

Installer scripts and networking components can make system or network changes. Audit them before production use. For dependency and artifact hygiene, prefer running the repository's security pipeline before packaging or publishing releases.

## Contributing

Create a focused branch, make the smallest coherent change, run the relevant verification and security checks, and open a pull request against `main`.

```bash
git checkout -b feature/your-change
make verify
make lint
make test
git push -u origin feature/your-change
```

Then open a pull request at:

https://github.com/auraecosystem/make.universe/pulls

## Documentation

- [Getting Started](Docs/Getting-started.md)
- [Developer Documentation](Docs/Dev.html.md)
- [API](Docs/api.md)
- [Web4 Notes](Docs/Web4.md)
- [Project Book](Docs/book.md)
- [Installation](Docs/install.md)

## License

See the repository's license files and GitHub repository metadata for the current licensing status. Do not assume a license from older project links or documentation until a canonical license file is present.
- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Components](#components)
- [Usage Examples](#usage-examples)
- [Security](#security)
- [Contributing](#contributing)
- [Documentation](#documentation)
- [License](#license)

---

## Overview

**makeuniversal** is a mixed build/tooling repository containing:

- **C/C++ demos and tools** for systems programming
- **Makefile-based build orchestration** for container and native builds
- **Multi-language project templates** (C, C++, Rust, Go, Python, Node.js, Swift)
- **Semantic build model** (.mu build language) for language-agnostic build description
- **Installer scripts** for environment provisioning
- **Architecture documentation and whitepapers** for Web4 project design
- **CI/CD workflows** for GitHub Pages deployment

---

## Features

✅ **Container-First Builds** - Docker support for Node.js and Python environments  
✅ **Native C/C++ Support** - Local compilation with CMake and traditional Makefiles  
✅ **Multi-Language Templates** - Pre-configured project scaffolding for 7+ languages  
✅ **Semantic Build Model** - Declarative `.mu` build language for cross-platform builds  
✅ **TCP Gateway Server** - Demo networking server with PROXY protocol support  
✅ **Automated Deployment** - GitHub Pages CI workflows for documentation  
✅ **Security-Focused** - Audit-ready installer and reviewed networking code  

---

## Prerequisites

Before building, ensure you have:

- **Docker** (for containerized builds)
- **C/C++ Toolchain** (gcc 9+ or clang 10+) for native compilation
- **GNU Make** (3.81+)
- **CMake** (3.15+) for native C/C++ builds
- **Git** (2.0+)

**Optional:**
- **Rust** toolchain for Rust template examples
- **Go** 1.16+ for Go template examples
- **Python** 3.8+ for Python template examples
- **Node.js** 14+ for Node.js template examples

---

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/auraecosystem/Makeuniversal.github.io.git
cd Makeuniversal.github.io
```

### 2. Build Container Images

**Node.js Container:**
```bash
make node
```

**Python Container:**
```bash
make python
```

### 3. Build Native C/C++ Components

Inspect available targets:
```bash
cat Makefile
cat mk/*.mk
```

For CMake-based builds:
```bash
mkdir -p build
cd build
cmake ..
make
```

### 4. Run the Demo Server

Build the TCP gateway:
```bash
gcc -o server/server server/server.c
```

Run the server (listens on default port):
```bash
./server/server
```

Expected output:
```
Server listening on port 8080...
Waiting for connections...
```

### 5. Explore the Playground

Build and run the C++ expression playground:
```bash
# Requires C++ 17 build environment
cd Playground
make
./playground
```

---

## Project Structure

```
makeuniversal/
├── Makefile                          # Top-level build orchestration
├── mk/                               # Core build module definitions
│   ├── build.mk
│   ├── container.mk
│   └── ...
├── mu                                # CLI tool for .mu language
├── plugins/                          # Build system plugins
├── scanners/                         # Code analysis tools
├── analyzers/                        # Static analysis modules
├── security/                         # Security scanning
├── package/                          # Packaging utilities
├── release/                          # Release automation
├── src/                              # C/C++ source code
├── server/                           # Networking demo server
│   ├── server.c                      # TCP gateway
│   └── rsc/@stud/Proxy-Protocol.c   # PROXY protocol handler
├── Playground.cpp                    # C++ expression type examples
├── templates/                        # Multi-language project templates
├── Lmlm.dev/                         # Installer scripts
│   └── install.sh                    # System provisioning
├── Docs/                             # Documentation and architecture notes
├── WEB4_Whitepaper_Complete.mk       # Web4 project whitepaper
├── .github/workflows/                # CI/CD for GitHub Pages
├── docs/                             # Rendered documentation
├── examples/                         # Example projects
├── tests/                            # Test suites
└── README.md                         # This file
```

---

## Components

### Templates (Multi-Language)

Pre-built project templates available in `templates/`:

```
templates/
├── c/
│   ├── main.c.tpl
│   ├── Makefile.tpl
│   └── build.mu.tpl
├── cpp/
│   ├── Main.cpp.tpl
│   ├── CMakeLists.txt.tpl
│   ├── Conan.tpl
│   └── build.mu.tpl
├── rust/
│   ├── main.rs.tpl
│   └── build.mu.tpl
├── go/
│   ├── main.go.tpl
│   └── build.mu.tpl
├── python/
│   ├── main.py.tpl
│   └── build.mu.tpl
├── node/
│   ├── index.js.tpl
│   └── build.mu.tpl
└── swift/
    ├── main.swift.tpl
    └── build.mu.tpl
```

### Demo Server (`server/server.c`)

A lightweight TCP gateway demonstrating:
- Socket programming in C
- Connection handling
- PROXY protocol parsing
- Production-grade error handling

### Playground (`Playground.cpp`)

C++ demo exercising:
- KLEE constraint solver integration
- CRAXExpr symbolic expression types
- Expression evaluation and verification

### Installer (`Lmlm.dev/install.sh`)

System provisioning script for:
- Installing build dependencies
- Setting up development environment
- Configuring Hermes-like environments

**⚠️ IMPORTANT:** Review the installer script before running on any system. It performs privileged operations and may prompt for input.

### Documentation

- **`Docs/`** - Architecture notes and design documents
- **`WEB4_Whitepaper_Complete.mk`** - Complete Web4 project specification
- **GitHub Pages** - Auto-deployed documentation from CI workflows

---

## Usage Examples

### Creating a New C Project from Template

```bash
# Generate new project
mu new c my_project

# Build with Makefile
cd my_project
make

# Run with test
make test
```

### Using the .mu Semantic Build Model

Projects define builds declaratively in `.mu` files:

```mu
project "myapp" {
    language = "c"
    standard = "c17"
    
    sources = [
        "src/main.c",
        "src/utils.c"
    ]
    
    headers = [
        "include/utils.h"
    ]
    
    build {
        compiler = "cc"
        flags = [
            "-Wall",
            "-Wextra",
            "-O2"
        ]
    }
    
    test {
        command = "test_runner"
        expected = "All tests passed"
    }
}
```

### Running in Docker

```bash
# Build Node.js environment
make node

# Build Python environment
make python
```

---

## Security

⚠️ **Important Security Considerations:**

### Proxy Protocol Handling

The project includes PROXY protocol parsing in `server/rsc/@stud/Proxy-Protocol.c`. Before using in production:

1. **Review the proxy handler** for robust header parsing and input validation
2. **Check for buffer overflows** and malformed packet handling
3. **Verify protocol compliance** with HAPROXY specification
4. **Test with malicious inputs** using fuzzing tools

### Installer Scripts

The `Lmlm.dev/install.sh` script performs system-level modifications:

- Installs system packages via package manager
- May modify environment variables
- Requires elevated privileges (sudo)

**Before running on production systems:**
1. Read through the entire script
2. Audit all commands and their effects
3. Test in a sandboxed environment first
4. Have rollback procedures documented

### Code Review Checklist

- [ ] Proxy protocol parsing handles truncated packets
- [ ] Buffer sizes validated before writes
- [ ] Input sanitization for all network data
- [ ] No hardcoded credentials or secrets
- [ ] Error messages don't leak internal paths
- [ ] Installer verifies checksums for downloads
- [ ] No unintended privilege escalation paths

---

## Contributing

We welcome contributions! Please follow these guidelines:

### Before Contributing

1. Review the existing code style and patterns
2. Read [CONTRIBUTING.md](CONTRIBUTING.md) for detailed workflow
3. Check existing issues and pull requests
4. Ensure your changes have corresponding tests

### Development Workflow

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/your-feature`
3. **Code** following the project style guide
4. **Test** locally: `make test`
5. **Commit** with clear messages
6. **Push** to your fork
7. **Open** a pull request with description

### Code Style

- **C/C++:** Follow Google C++ Style Guide
- **Makefiles:** Use consistent indentation (tabs)
- **Shell scripts:** Follow ShellCheck recommendations
- **Documentation:** Use clear, technical language

### Build Targets

Common make targets:

```bash
make node          # Build Node.js container
make python        # Build Python container
make clean         # Remove build artifacts
make test          # Run test suite
make docs          # Generate documentation
```

---

## Documentation

Full documentation and architecture guides are available in:

- **`Docs/`** - Complete architecture documentation
- **`WEB4_Whitepaper_Complete.mk`** - Web4 specification and design
- **GitHub Pages** - Rendered docs at https://auraecosystem.github.io/Makeuniversal.github.io/

Build and view documentation locally:

```bash
make docs
# Open docs/index.html in your browser
```

---

## License

[Add LICENSE information here - file currently missing]

This project is part of the Web4 ecosystem. For licensing details, see the LICENSE file in the repository root.

---

## Support & Contact

- **Repository:** https://github.com/auraecosystem/Makeuniversal.github.io
- **Issues:** [GitHub Issues](https://github.com/auraecosystem/Makeuniversal.github.io/issues)
- **Discussions:** [GitHub Discussions](https://github.com/auraecosystem/Makeuniversal.github.io/discussions)

---

## Troubleshooting

### Docker Build Fails

```bash
# Ensure Docker daemon is running
docker ps

# Check available disk space
df -h

# Try building without cache
make node --no-cache
```

### CMake Build Errors

```bash
# Ensure CMake version is 3.15+
cmake --version

# Clean previous builds
rm -rf build/
mkdir build && cd build && cmake ..
```

### Permission Denied on Installer

```bash
# The installer requires sudo for system packages
sudo bash Lmlm.dev/install.sh
```

### Port Already in Use (Demo Server)

```bash
# Find what's using the port
lsof -i :8080

# Kill the process (if needed)
kill -9 <PID>

# Run server again
./server/server
```

---

**Last Updated:** 2026-09-11
