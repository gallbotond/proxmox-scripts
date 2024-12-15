#/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install qemu-guest-agent xrdp -y

sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent

sudo echo "gnome-session" | sudo tee ~/.xsession # Set default session to gnome
sudo systemctl enable xrdp
sudo systemctl start xrdp