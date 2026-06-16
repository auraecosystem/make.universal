Contributing to makeuniversal

Thanks for your interest! A quick guide to get started:

- Code style
  - C/C++: follow usual modern C/C++ conventions. Use clang-format if desired.
  - Shell: follow shellcheck suggestions.

- Running locally
  - Build server for quick tests:
    gcc -std=c11 -Wall -Wextra -O2 -o server/server server/server.c

  - Build and run proxy parser tests:
    gcc -std=c11 -Wall -Wextra -O2 -o server/tests/proxy_test server/tests/proxy_test.c server/rsc/@stud/Proxy-Protocol.c
    ./server/tests/proxy_test

- Branches & PRs
  - Create a feature branch per change: git checkout -b feat/my-change
  - Open a Pull Request against main and describe the change and tests.

- Tests
  - Add unit tests under server/tests/ for server/protocol code.
  - CI will run basic static checks and the proxy tests.

- Security
  - Do not commit secrets. For any network or installer-related change include a short security rationale and threat model.

If you're unsure where to start, open an issue and tag a maintainer.
