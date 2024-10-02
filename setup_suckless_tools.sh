#!/bin/bash

YELLOW="\e[1;33m"
GREEN="\e[1;32m"
RED="\e[1;31m"
ENDC="\e[0m"

DIR="/home/$USER/fq_void"
TOOLS=("dwm" "st" "dmenu" "statusbar")

for tool in "${TOOLS[@]}"; do
   echo -e $YELLOW"Installing $tool ..."$ENDC

   cd "$DIR/src/$tool" || { echo "Error: Directory for $tool not found!"; continue; }

   doas make install clean >/dev/null 2>&1

   if [ $? -eq 0 ]; then
     echo -e $GREEN"$tool installed successfully."$ENDC
   else
     echo -e $RED"Error installing $tool!"$ENDC
   fi
done

echo "All installations completed."
