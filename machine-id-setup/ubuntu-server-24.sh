#!/bin/bash

sudo rm -f /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id

sudo systemd-machine-id-setup

sudo ln -s /etc/machine-id /var/lib/dbus/machine-id

sudo truncate -s 0 /etc/machine-id