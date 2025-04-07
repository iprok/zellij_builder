#!/bin/bash
set -e

# Get version and architecture
VERSION=$(grep '^version =' /opt/zellij/Cargo.toml | head -1 | cut -d'"' -f2)
ARCH=$(dpkg --print-architecture)
NAME="zellij_${VERSION}_${DISTRO}_${ARCH}.deb"

# Copy to mounted volume
cp /opt/zellij/target/debian/*.deb /output/$NAME

echo "✅ Copied to /output/$NAME"
