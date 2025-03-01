#!/bin/bash

# Define variables
LIBRESPEED_VERSION="1.0.11"
LIBRESPEED_FILE="librespeed-cli_${LIBRESPEED_VERSION}_linux_arm64.tar.gz"
LIBRESPEED_URL="https://github.com/librespeed/speedtest-cli/releases/download/v${LIBRESPEED_VERSION}/${LIBRESPEED_FILE}"
INSTALL_DIR="/usr/local/bin"

# Download the package
echo "Downloading LibreSpeed CLI..."
wget -q --show-progress "$LIBRESPEED_URL" -O "$LIBRESPEED_FILE"

# Extract the package
echo "Extracting LibreSpeed CLI..."
tar -xvzf "$LIBRESPEED_FILE"

# Make it executable
chmod +x librespeed-cli

# Move to the installation directory
echo "Installing LibreSpeed CLI..."
sudo mv librespeed-cli "$INSTALL_DIR/"

# Cleanup
echo "Cleaning up..."
rm "$LIBRESPEED_FILE"

# Verify installation
echo "LibreSpeed CLI installed successfully!"
librespeed-cli --version
