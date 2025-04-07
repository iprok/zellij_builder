ARG BASE_IMAGE=debian:bookworm
FROM ${BASE_IMAGE}

ARG DISTRO=unknown
ENV DISTRO=${DISTRO}

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

# Install Rust and cargo-deb
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install cargo-deb

# Clone Zellij
WORKDIR /opt
RUN git clone https://github.com/zellij-org/zellij.git
WORKDIR /opt/zellij
RUN git fetch --tags && \
    LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1)) && \
    git checkout $LATEST_TAG

# Remove broken asset paths
RUN sed -i '/assets\//d' Cargo.toml

# Build .deb
RUN cargo deb

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Declare output mount
VOLUME /output

# Run logic at startup
CMD ["/entrypoint.sh"]
