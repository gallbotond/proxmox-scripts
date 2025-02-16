#!/bin/bash

# Backup the existing sources.list
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

echo "Updating sources.list for Debian 12 (Bookworm)..."

# Write the new sources list
sudo bash -c 'cat > /etc/apt/sources.list <<EOF
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
EOF'

# Update package lists
sudo apt update

echo "Sources list updated and packages lists refreshed."

# Install nvidia-detect
sudo apt install -y nvidia-detect

# Detect recommended NVIDIA driver
DETECT_OUTPUT=$(nvidia-detect)
echo "nvidia-detect output: $DETECT_OUTPUT"

RECOMMENDED_DRIVER=$(echo "$DETECT_OUTPUT" | awk '/It is recommended to install the/ {getline; print $1}')

if [ -n "$RECOMMENDED_DRIVER" ]; then
    echo "Installing recommended NVIDIA driver: $RECOMMENDED_DRIVER"
    sudo apt install -y "$RECOMMENDED_DRIVER"
else
    echo "No recommended NVIDIA driver found."
fi
