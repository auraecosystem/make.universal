#!/bin/bash

set -e

echo "Detecting project type..."

if [ -f "package.json" ]; then
    bash features/node.sh
fi

if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    bash features/python.sh
fi

echo "Running cleanup..."
bash features/cleanup.sh

echo "Environment ready."
