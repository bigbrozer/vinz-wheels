ARG UV_VERSION="latest"

FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv

# https://gitlab.com/nvidia/container-images/cuda/blob/master/doc/supported-tags.md
FROM nvidia/cuda:13.0.2-cudnn-devel-ubuntu24.04

SHELL [ "/bin/bash", "-c" ]

# hadolint ignore=DL3008
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        ca-certificates \
        clang \
        curl \
        ffmpeg \
        git \
        gosu \
        libcupti12 \
        libcusparselt0 \
        libgl1 \
        libglib2.0-0

COPY --from=uv /uv /uvx /usr/local/bin/

USER ubuntu
WORKDIR /home/ubuntu

COPY ./pylock.toml ./.python-version ./

RUN set -eu \
    && mkdir -v wheels \
    && uv venv \
    && source .venv/bin/activate \
    && uv pip sync --compile-bytecode --preview pylock.toml

COPY --chmod=0755 ./scripts ./scripts/
