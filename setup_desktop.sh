#!/bin/bash

YELLOW="\e[1;33m"
GREEN="\e[1;32m"
RED="\e[1;31m"
ENDC="\e[0m"

KEYBOARD_LAYOUT="us,ara"
KEYBOARD_VARIANT=",digits"
KEYBOARD_OPTION="grp:sclk_toggle caps:escape"

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

backup_file() {
    if [ -f "$1" ]; then
        cp "$1" "$1.bak"
        echo -e "${YELLOW}Backed up existing $1 to $1.bak${ENDC}"
    fi
}

setup_xinitrc() {
    backup_file ~/.xinitrc

    cat > ~/.xinitrc << EOF
#!/bin/sh
setxkbmap -layout $KEYBOARD_LAYOUT -variant $KEYBOARD_VARIANT -option $KEYBOARD_OPTION
sxhkd &
statusbar &
dwm
EOF

    echo -e "${GREEN}.xinitrc setup complete!${ENDC}"
}

setup_sxhkd() {
    mkdir -p ~/.config/sxhkd/
    backup_file ~/.config/sxhkd/sxhkdrc
    
    cat > ~/.config/sxhkd/sxhkdrc << EOF
super + Return
    st
super + w
    firefox
EOF

    echo -e "${GREEN}sxhkdrc setup complete!${ENDC}"
}

for prog in setxkbmap sxhkd dwm; do
    if ! command_exists $prog; then
        echo -e "${RED}$prog is not installed. Please install it and try again.${ENDC}"
        exit 1
    fi
done

echo -e "${YELLOW}Configuring .xinitrc ...${ENDC}"
setup_xinitrc || exit 1
echo -e "${YELLOW}Configuring sxhkdrc ...${ENDC}"
setup_sxhkd

echo -e "${GREEN}Configuration complete!${ENDC}"