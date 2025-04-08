ARG BASE_IMAGE=debian:bookworm
FROM ${BASE_IMAGE}

ARG DISTRO=unknown
ARG ZELLIJ_VERSION=""
ENV DISTRO=${DISTRO}
ENV ZELLIJ_VERSION=${ZELLIJ_VERSION}

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

# Clone Zellij and checkout tag
WORKDIR /opt
RUN git clone https://github.com/zellij-org/zellij.git
WORKDIR /opt/zellij
RUN git fetch --tags && \
    if [ -n "$ZELLIJ_VERSION" ]; then \
      echo "🧩 Checking out tag: v$ZELLIJ_VERSION" && \
      git checkout "tags/v$ZELLIJ_VERSION"; \
    else \
      echo "🔎 Detecting latest tag..." && \
      LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1)) && \
      echo "✅ Using latest tag: $LATEST_TAG" && \
      git checkout "$LATEST_TAG"; \
    fi

# Remove asset paths from Cargo.toml
RUN sed -i '/assets\//d' Cargo.toml

# Build the .deb package
RUN cargo deb

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Declare output mount and run post-build logic
VOLUME /output
CMD ["/entrypoint.sh"]
