#!/bin/bash

./setup_bash.sh
./install_base_packages.sh
./setup_suckless_tools.sh
./setup_desktop.sh
./setup_vim.sh

# Reboot the system
doas reboot