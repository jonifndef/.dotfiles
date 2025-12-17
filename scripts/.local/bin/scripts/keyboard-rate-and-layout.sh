#!/bin/bash

(
    export DISPLAY=":0"
    export XAUTHORITY="/run/user/1000/gdm/Xauthority"

    /usr/bin/xset r rate 225 25

    echo "Vendor: $ID_VENDOR_ID, model: $ID_MODEL_ID, device: $DEVNAME" > /tmp/olle.txt

    case "$ID_VENDOR_ID$ID_MODEL_ID" in
        "6582060d") # Wilba tech Salvation
            /usr/bin/setxkbmap -layout se -variant swerty
            ;;
        "08530134") # Leopold fc660c
            /usr/bin/setxkbmap -layout se -variant swerty
            ;;
        "54506a31") # Prototypist J-01
            /usr/bin/setxkbmap -layout se
            ;;
        *)
            setxkbmap -layout se
            ;;
    esac
) & disown

# Just install this udev rule to make it work:
#
# ACTION=="add", SUBSYSTEM=="input", RUN+="/home/jonas/.local/bin/scripts/keyboard-rate-and-layout.sh"
