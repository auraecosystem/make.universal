FROM node:22-alpine

LABEL org.opencontainers.image.title="make.universal Node runtime"
LABEL org.opencontainers.image.description="Node.js build image for make.universal"

WORKDIR /workspace

COPY build.mu ./build.mu

CMD ["node", "--version"]
