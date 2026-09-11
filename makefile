# ==========================================================
# make.universal
# Production Makefile
# ==========================================================
PROJECT       := make.universal
VERSION       ?= latest
REGISTRY      ?= auraecosystem
DOCKER        := docker
MU            := mu
NODE_IMAGE    := $(REGISTRY)/$(PROJECT)-node:$(VERSION)
PYTHON_IMAGE  := $(REGISTRY)/$(PROJECT)-python:$(VERSION)

.PHONY: \
    all build node python images clean \
    security security-cve security-osv \
    security-sbom security-sarif security-report \
    security-fix verify lint format test \
    package sign publish release help

all: build
build: node python
images: build

node:
	@echo "Building Node.js image..."
	$(DOCKER) build \
		-f images/node.Dockerfile \
		-t $(NODE_IMAGE) .

python:
	@echo "Building Python image..."
	$(DOCKER) build \
		-f images/python.Dockerfile \
		-t $(PYTHON_IMAGE) .

format:
	$(MU) format

lint:
	$(MU) lint

test:
	$(MU) test

verify:
	@set -eu; \
	test -f build.mu; \
	test -f images/node.Dockerfile; \
	test -f images/python.Dockerfile; \
	grep -q 'name[[:space:]]*=[[:space:]]*"my_app"' build.mu; \
	grep -q '"node"' build.mu; \
	grep -q '"python"' build.mu; \
	echo "Verification passed: build.mu and Docker build assets are present."

security:
	$(MAKE) security-cve
	$(MAKE) security-osv
	$(MAKE) security-sbom
	$(MAKE) security-sarif
	$(MAKE) security-report

security-cve:
	$(MU) cve scan

security-osv:
	$(MU) osv scan

security-sbom:
	$(MU) sbom generate

security-sarif:
	$(MU) sarif generate

security-report:
	$(MU) report html

security-fix:
	$(MU) update --secure

package:
	$(MU) package

sign:
	$(MU) sign

publish:
	$(MU) publish

release:
	$(MAKE) format
	$(MAKE) lint
	$(MAKE) test
	$(MAKE) verify
	$(MAKE) security
	$(MAKE) package
	$(MAKE) sign
	$(MAKE) publish

clean:
	$(DOCKER) system prune -af

help:
	@echo "make.universal"
	@echo ""
	@echo "Targets:"
	@echo "  build            Build all images"
	@echo "  node             Build Node image"
	@echo "  python           Build Python image"
	@echo "  test             Run tests"
	@echo "  lint             Run linter"
	@echo "  format           Format project"
	@echo "  verify           Verify project"
	@echo "  security         Run all security scans"
	@echo "  security-fix     Update vulnerable dependencies"
	@echo "  package          Build release package"
	@echo "  sign             Sign artifacts"
	@echo "  publish          Publish artifacts"
	@echo "  release          Complete release pipeline"
	@echo "  clean            Remove Docker resources"
