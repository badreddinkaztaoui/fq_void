#!/bin/bash

YELLOW="\e[1;33m"
MAGENTA="\e[35m"
ENDC="\e[0m"

echo -e $YELLOW"Welcome to frequency world 🔥❤️"$ENDC

./setup_bash.sh
./install_base_packages.sh
./setup_suckless_tools.sh
./setup_desktop.sh
./setup_vim.sh

# Reboot the system
echo -e $MAGENTA"Rebooting the system ..."$ENDC
doas reboot