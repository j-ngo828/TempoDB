# syntax=docker/dockerfile:1
# Small, multi-arch base; works natively on Apple Silicon
FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG LLVM_MAJOR=21

# 1) Minimal deps, add LLVM APT repo (arm64 supported), install toolchain
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates wget gpg; \
    install -d -m 0755 /usr/share/keyrings; \
    wget -O- https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor > /usr/share/keyrings/llvm.gpg; \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/llvm.gpg] https://apt.llvm.org/bookworm/ llvm-toolchain-bookworm-${LLVM_MAJOR} main" \
    > /etc/apt/sources.list.d/llvm.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    clang-${LLVM_MAJOR} lld-${LLVM_MAJOR} \
    libc++-${LLVM_MAJOR}-dev libc++abi-${LLVM_MAJOR}-dev \
    libc6-dev; \
    # Make clang/clang++ the defaults
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-${LLVM_MAJOR} 100; \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-${LLVM_MAJOR} 100; \
    # Clean APT caches to keep the image small
    rm -rf /var/lib/apt/lists/*

# Use libc++ + lld by default; C++23 on
ENV CC=clang CXX=clang++ \
    CXXFLAGS="-std=c++23 -stdlib=libc++" \
    LDFLAGS="-stdlib=libc++ -fuse-ld=lld"

COPY main.cpp /opt/TempoDB/

WORKDIR /opt/TempoDB/

RUN $CXX $CXXFLAGS /opt/TempoDB/main.cpp $LDFLAGS -o /usr/local/bin/TempoDB \
    && /usr/local/bin/TempoDB
