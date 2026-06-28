$ curl https://yangcatalog.org/api/search/vendors
$ curl https://yangcatalog.org/api/search/catalog
python3 build_model_maker_api_docs.mk --output_dir=./docs/api
# Install mdbook (example)
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf -y | sh
rustup update
cargo install mdbook
mdbook build
# The built site will be in ./book
docker run --rm -it -v "$(pwd)":/work -w /work makeuniversal-python bash
# or for node:
docker run --rm -it -v "$(pwd)":/work -w /work makeuniversal-node bash
sudo apt update
sudo apt install -y build-essential gcc g++ make docker.io curl git
gcc -std=c11 -Wall -Wextra -O2 -o server/server server/server.c
./server/server
# Inspect
less Lmlm.dev/install.sh

# If satisfied, run in a disposable container
docker run --rm -it -v "$(pwd)":/work -w /work ubuntu:24.04 bash
apt-get update && apt-get install -y curl python3
bash Lmlm.dev/install.sh
"git clone" https://github.com/auraecosystem/make.universe.git
cd make.universe
"git clone" https://github.com/auraecosystem/turbo.build.git
cd turbo.build
# Global install
pnpm add turbo --global
# Install in repository
pnpm add turbo --save-dev --workspace-root

# Global install
bun install turbo --global
# Install in repository
bun install turbo --dev
mu init cpp MyApp
docker run -d -e JUPYTER_PASSWORD="mypassword" \
  -p 8888:8888 -p 8000:8000 -p 2222:22 \
  -v $(pwd)/work:/workspace/work \
  --gpus all \
  unsloth/unsloth
-v C:\Users\YourName\work:/workspace/work
-v $(pwd)/work:/workspace/work
