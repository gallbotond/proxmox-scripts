# Install the OpenSSH Server feature
Write-Host "Installing OpenSSH Server..."
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start the sshd service
Write-Host "Starting sshd service..."
Start-Service sshd

# Set the sshd service to start automatically
Write-Host "Setting sshd service to start automatically..."
Set-Service -Name sshd -StartupType 'Automatic'

# Create a firewall rule to allow SSH traffic
Write-Host "Creating firewall rule for SSH..."
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' `
    -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

Write-Host "OpenSSH Server installation and configuration completed."