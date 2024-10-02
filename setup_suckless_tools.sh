#!/bin/bash

DIR="/home/$USER/fq_void"
TOOLS=("dwm" "st" "dmenu" "statusbar")

for tool in "${TOOLS[@]}"; do
   echo "Installing $tool ..."

   cd "$DIR/src/$tool" || {echo "Error: Directory for $tool not found!"; continue; }

   doas make install clean >/dev/null 2>&1

   if [ $? -eq 0 ]; then
     echo "$tool installed successfully."
   else
     echo "Error installing $tool!"
   fi

   echo "------------------------"
done

echo "All installations completed."
