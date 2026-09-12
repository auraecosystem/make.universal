"git clone" https://github.com/auraecosystem/make.universe.git
cd make.universe
"git clone" https://github.com/auraecosystem/turbo.build.git
cd turbo.build
# Global install
pnpm add turbo --global
# Install in repository
pnpm add turbo --save-dev --workspace-root
# Show actual commands users should run:
make node
make python
./server/server
# Global install
bun install turbo --global
# Install in repository
bun install turbo --dev
