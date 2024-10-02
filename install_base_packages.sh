#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

install_package() {
  if ! xbps-query -l | grep -q "^ii $1-"; then
    if command_exists doas; then
      doas xbps-install -y "$1"
    else
      sudo xbps-install -y "$1"
    fi
  else
    echo "$1 is already installed."
  fi
}

# Check if running as root
if [ "$(id -u)" -eq 0 ]; then
  echo "You should not run scripts as root to prevent security issues."
  exit 1
fi

echo "Updating system ..."
sudo xbps-install -Syu

echo "Installing and configuring doas ..."
install_package opendoas

echo "permit :wheel" | sudo tee /etc/doas.conf > /dev/null
echo "permit nopass $USER as root" | sudo tee -a /etc/doas.conf > /dev/null
sudo chown -c root:root /etc/doas.conf
sudo chmod -c 0400 /etc/doas.conf

echo "Testing doas configuration..."
if doas echo "doas is working correctly"; then
    echo "doas is configured and working. Switching to doas for further operations."
    USE_DOAS=true
else
    echo "doas configuration failed. Continuing with sudo."
    USE_DOAS=false
fi

echo "Installing dependencies ..."

dependencies=(
    base-devel
    libX11-devel
    libXft-devel
    libXinerama-devel
    fontconfig-devel
    git
    make
    gcc
    pkg-config
    xorg
    setxkbmap
    sxhkd
    libXrandr-devel
    xinit
    vim
    nerd-fonts-ttf
    docker
    nginx
    netcat
)

for dep in "${dependencies[@]}"; do
  install_package "$dep"
done

echo "Installation complete. You now have all necessary dependencies."
