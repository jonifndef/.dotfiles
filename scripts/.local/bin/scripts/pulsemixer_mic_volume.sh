#!/bin/bash

PATH_TO_DIR="/home/$USER/.local/bin/scripts"
SOURCE_ID=$(pulsemixer --list-sources | grep "Name: Built-in" | cut -d'-' -f2 | cut -d',' -f1)

if [ ! -f "$(readlink -f ${PATH_TO_DIR})"/pulsemixer_mic_vol.conf ]; then
    touch "$(readlink -f ${PATH_TO_DIR})"/pulsemixer_mic_vol.conf
    echo "50" > "$(readlink -f ${PATH_TO_DIR})"/pulsemixer_mic_vol.conf
fi

while true; do
    pulsemixer --id="${SOURCE_ID}" --set-volume $(cat "$(readlink -f ${PATH_TO_DIR})"/pulsemixer_mic_vol.conf)
    sleep 0.01
done
