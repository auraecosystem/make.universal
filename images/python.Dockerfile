FROM python:3.13-alpine

LABEL org.opencontainers.image.title="make.universal Python runtime"
LABEL org.opencontainers.image.description="Python build image for make.universal"

WORKDIR /workspace

COPY build.mu ./build.mu

CMD ["python", "--version"]
