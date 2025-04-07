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
RUN cargo install cargo-deb

# Clone source
WORKDIR /opt
RUN git clone https://github.com/zellij-org/zellij.git
WORKDIR /opt/zellij
RUN git fetch --tags && \
    LATEST_TAG=$(git describe --tags `git rev-list --tags --max-count=1`) && \
    git checkout $LATEST_TAG

# Remove broken assets
RUN sed -i '/assets\//d' Cargo.toml

# Build .deb
RUN cargo deb


# Stage to copy to volume-mounted directory
FROM debian:bookworm AS export

# Define a mount point for output
VOLUME /output

# Copy binary source from previous stage
COPY --from=builder /opt/zellij/target/debian /build-output

# On container start: copy .deb into mounted volume
CMD cp /build-output/*.deb /output && echo "Copied .deb to /output" && ls -lh /output && bash
