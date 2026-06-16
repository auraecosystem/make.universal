
3) docs/install.md
name= docs/install.md
```markdown
# Install Guide — makeuniversal

This guide documents safe, reproducible ways to try makeuniversal: containerized (recommended for most users) and native installs for development.

Security note: Installer scripts may perform privileged operations and download artifacts. Inspect any install script before running it and prefer running inside a disposable VM or container.

Recommended: Use Docker (non-root)
- Build the developer images:
  ```bash
  # From repo root
  make node     # builds images/node.Dockerfile
  make python   # builds images/python.Dockerfile
