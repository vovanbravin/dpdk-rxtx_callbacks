FROM ubuntu:24.04

RUN apt update && apt install -y \
    build-essential \
    meson \
    ninja-build \
    python3 \
    python3-pyelftools \
    libnuma-dev \
    pkg-config \
    iproute2 \
    iputils-arping \
    wget && \
    rm -rf /var/lib/apt/lists/*

ARG DPDK_VERSION=25.11

RUN wget -q https://fast.dpdk.org/rel/dpdk-${DPDK_VERSION}.tar.xz && \
    tar xf dpdk-${DPDK_VERSION}.tar.xz && \
    mv dpdk-*/ dpdk && \
    rm dpdk-${DPDK_VERSION}.tar.xz

WORKDIR /dpdk
RUN meson setup build \
    -Dplatform=generic \
    -Dexamples=rxtx_callbacks  

WORKDIR /dpdk/build
    RUN ninja && \
    meson install && \
    ldconfig

RUN mkdir -p /app
RUN cp -r /dpdk/examples/rxtx_callbacks /app

COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh
COPY src/main.c /app/rxtx_callbacks/main.c

VOLUME /logs

WORKDIR /app/rxtx_callbacks
RUN make


CMD ["/scripts/entrypoint.sh"]
