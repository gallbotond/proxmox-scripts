#/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install qemu-guest-agent -y

sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent

sudo systemctl enable ssh
sudo systemctl start ssh

sudo truncate -s 0 /etc/machine-id