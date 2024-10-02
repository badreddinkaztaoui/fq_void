#!/bin/bash

YELLOW="\e[1;33m"
GREEN="\e[1;32m"
ENDC="\e[0m"

setup_xinitrc() {

  if [ ! -f "~/.xinitrc" ]; then
    touch ~/.xinitrc
  fi

  monitor_name=$(xrandr | grep " connected" | awk '{print $1}')

  cat << EOF >> ~/.xinitrc
xrandr --output "$monitor_name" --mode 1920x1080
setxkbmap -layout us,ara -variant ,digits -option grp:sclk_toggle caps:escape
sxhkd &
statusbar &
dwm
EOF

  echo -e $GREEN".xinitrc setup complete!"$ENDC
}

setup_sxhkd() {
 
  mkdir -p ~/.config/sxhkd/
  
  [ ! -f "~/.config/sxhkd/sxhkdrc" ] && touch ~/.config/sxhkd/sxhkdrc

  cat << EOF >> ~/.config/sxhkd/sxhkdrc
super + Return
	$TERMINAL

super + w
	$BROWSER

super + shift + BackSpace
	$HOME/scripts/exit.sh
EOF

  echo -e $GREEN"sxhkdrc setup complete!"$ENDC
}

echo -e $YELLOW"Configuring .xinitrc ..."$ENDC
setup_xinitrc
echo -e $YELLOW"Configuring sxhkdrc ..."$ENDC
setup_sxhkd

