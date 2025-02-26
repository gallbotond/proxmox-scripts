#!/bin/bash

echo "🚀 Setting up automatic security updates on Ubuntu..."

# Update package lists
echo "🔄 Updating package lists..."
sudo apt update -y

# Install unattended-upgrades without interactive prompts
echo "📦 Installing unattended-upgrades..."
sudo apt install -y unattended-upgrades

# Enable unattended upgrades non-interactively
echo "✅ Enabling unattended-upgrades..."
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure unattended-upgrades

# Configure 50unattended-upgrades
CONFIG_FILE="/etc/apt/apt.conf.d/50unattended-upgrades"
echo "⚙️ Configuring $CONFIG_FILE..."
sudo tee "$CONFIG_FILE" > /dev/null <<EOL
Unattended-Upgrade::Allowed-Origins {
    "\${distro_id}:\${distro_codename}-security";
    "\${distro_id}:\${distro_codename}-updates";
    "\${distro_id}:\${distro_codename}-proposed";
    "\${distro_id}:\${distro_codename}-backports";
};
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "03:00";
EOL

# Configure 20auto-upgrades manually
AUTO_UPGRADES_FILE="/etc/apt/apt.conf.d/20auto-upgrades"
echo "⚙️ Configuring $AUTO_UPGRADES_FILE..."
sudo tee "$AUTO_UPGRADES_FILE" > /dev/null <<EOL
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOL

# Restart the unattended-upgrades service
echo "🔄 Restarting unattended-upgrades service..."
sudo systemctl restart unattended-upgrades

# Test the setup
echo "🛠️ Running a test upgrade..."
sudo unattended-upgrade --dry-run

echo "🎉 Automatic updates configured successfully!"
