#!/bin/bash
set -e

# Determine version string
if [[ -n "$ZELLIJ_VERSION" ]]; then
  VERSION="$ZELLIJ_VERSION"
else
  VERSION=$(grep '^version =' /opt/zellij/Cargo.toml | head -1 | cut -d'"' -f2)
fi

ARCH=$(dpkg --print-architecture)
NAME="zellij_${VERSION}_${DISTRO}_${ARCH}.deb"

# Copy built package to volume
cp /opt/zellij/target/debian/*.deb /output/$NAME

echo "✅ Copied to /output/$NAME"
