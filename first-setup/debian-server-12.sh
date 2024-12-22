#!/bin/bash

# Add /usr/sbin to PATH
echo -e '\n# Adding /usr/sbin to PATH\nexport PATH=$PATH:/usr/sbin' >> ~/.bashrc

# Source the .bashrc file
source ~/.bashrc

# Update the system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y sudo curl wget git