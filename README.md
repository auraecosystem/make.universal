# make.universe

make.universe is a universal build and developer-tooling layer for the Web4 ecosystem. It combines Makefile orchestration, Docker environments, C/C++ tooling, scripting, documentation, security automation and release workflows behind a predictable command surface.

[Open the project site](index.html) · [GitHub repository](https://github.com/auraecosystem/make.universe)

## What it provides

- **Build orchestration** — top-level `makefile` coordinates the primary build lifecycle.
- **Container builds** — Node.js and Python images are available through `make node`, `make python`, or `make build`.
- **Developer tooling** — the `mu` command is used for formatting, linting, testing, packaging and security operations.
- **Verification** — `make verify` checks required build assets and configuration.
- **Security** — CVE, OSV, SBOM, SARIF and HTML-report targets are exposed through `make security`.
- **Release automation** — `make release` runs format, lint, test, verification, security, package, sign and publish stages.
- **C/C++ examples** — the repository includes a lightweight TCP gateway and other development material.
- **Documentation** — installation, development, API and Web4 material live under `Docs/`.
- **CI / Pages** — GitHub Actions workflows provide continuous integration and static-site publishing.

## Quickstart

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
