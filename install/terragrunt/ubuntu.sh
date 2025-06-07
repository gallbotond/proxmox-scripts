#!/usr/bin/env bash

set -euo pipefail

OS="linux"
ARCH="amd64"
VERSION="v0.69.10"
BINARY_NAME="terragrunt_${OS}_${ARCH}"

# Download the binary
curl -sL "https://github.com/gruntwork-io/terragrunt/releases/download/$VERSION/$BINARY_NAME" -o "$BINARY_NAME"

# Generate the checksum
CHECKSUM="$(sha256sum "$BINARY_NAME" | awk '{print $1}')"

# Download the checksum file
curl -sL "https://github.com/gruntwork-io/terragrunt/releases/download/$VERSION/SHA256SUMS" -o SHA256SUMS

# Grab the expected checksum
EXPECTED_CHECKSUM="$(grep "$BINARY_NAME" <SHA256SUMS | awk '{print $1}')"

# Compare the checksums
if [ "$CHECKSUM" == "$EXPECTED_CHECKSUM" ]; then
 echo "Checksums match!"
else
 echo "Checksums do not match!"
fi
