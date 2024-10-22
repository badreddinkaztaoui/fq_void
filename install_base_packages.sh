#!/bin/bash

YELLOW="\e[1;33m"
GREEN="\e[1;32m"
RED="\e[1;31m"
WARN="\e[93m"
ENDC="\e[0m"

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

install_package() {
  if ! xbps-query -l | grep -q "^ii $1-"; then
    if command_exists doas; then
      doas xbps-install -Sy "$1" >/dev/null 2>&1
    else
      sudo xbps-install -Sy "$1" >/dev/null 2>&1
    fi
  else
    echo -e $WARN"$1 is already installed."$ENDC
  fi
}

# Check if running as root
if [ "$(id -u)" -eq 0 ]; then
  echo -e $RED"You should not run scripts as root to prevent security issues."$ENDC
  exit 1
fi

echo -e $YELLOW"Updating system ..."$ENDC
sudo xbps-install -Syu >/dev/null 2>&1

echo -e $YELLOW"Installing and configuring doas ..."$ENDC
install_package opendoas

echo "permit :wheel" | sudo tee /etc/doas.conf > /dev/null
echo "permit nopass $USER as root" | sudo tee -a /etc/doas.conf > /dev/null
sudo chown -c root:root /etc/doas.conf
sudo chmod -c 0400 /etc/doas.conf

echo -e $YELLOW"Testing doas configuration..."$ENDC
if doas echo -e $GREEN"doas is working correctly"$ENDC; then
    echo -e $WARN"doas is configured and working. Switching to doas for further operations."$ENDC
    USE_DOAS=true
else
    echo -e $RED"doas configuration failed. Continuing with sudo."$ENDC
    USE_DOAS=false
fi

echo -e $YELLOW"Installing dependencies ..."$ENDC

dependencies=(
    vim
    make
    gcc
    curl
    libX11-devel
    libXft-devel
    libXinerama-devel
    xorg-server
    xinit
    xauth
    xrandr
    xorg-input-drivers
    nerd-fonts-ttf
    pkg-config
    ffmpeg
    setxkbmap
    sxhkd
    firefox
    docker
    nginx
    netcat
    xclip
)

for dep in "${dependencies[@]}"; do
  install_package "$dep"
done

# Configure nginx and docker
echo -e $YELLOW"Configuring docker ..."$ENDC
doas ln -s /etc/sv/docker /var/service/
doas sv start docker
doas usermod -aG docker $USER

echo -e $YELLOW"Configuring nginx ..."$ENDC
doas ln -s /etc/sv/nginx /var/service/
doas sv start nginx

echo -e $GREEN"docker nginx setup completed."$ENDC

echo -e $GREEN"Installation complete. You now have all necessary dependencies."$ENDC
