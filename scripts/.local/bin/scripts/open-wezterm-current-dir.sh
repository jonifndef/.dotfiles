#/bin/bash

CURR_DIR=$(pwd)
echo "Curr dir: $CURR_DIR"
nohup wezterm start --cwd "${CURR_DIR}" > /dev/null 2>&1 &
