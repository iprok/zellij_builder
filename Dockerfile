ARG BASE_IMAGE=debian:bookworm
FROM ${BASE_IMAGE} AS builder

ARG DISTRO=unknown

# Install build dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    cmake \
    pkg-config \
    libxcb-xfixes0-dev \
    libxkbcommon-dev \
    libssl-dev \
    libxcb1-dev \
    libxcb-render0-dev \
    libxcb-shape0-dev \
    libxcb-xfixes0-dev \
    devscripts \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install cargo-deb
RUN cargo install cargo-deb

# Clone source
WORKDIR /opt
RUN git clone https://github.com/zellij-org/zellij.git
WORKDIR /opt/zellij
RUN git fetch --tags && \
    LATEST_TAG=$(git describe --tags `git rev-list --tags --max-count=1`) && \
    git checkout $LATEST_TAG

# Remove asset references
RUN sed -i '/assets\//d' Cargo.toml

# Build .deb
RUN cargo deb
RUN mkdir -p /build-output && cp target/debian/*.deb /build-output/

# --- Extract stage ---
FROM scratch AS export
COPY --from=builder /build-output /output

