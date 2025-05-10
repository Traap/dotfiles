#!/bin/bash

# Set the path to the config and style files
           config_file="${HOME}/.config/waybar/active/config.jconc"
config_background_file="${HOME}/.config/waybar/active/config-background.jsonc"
            style_file="${HOME}/.config/waybar/active/style.css"
 style_background_file="${HOME}/.config/waybar/active/style-background.css"

# Swap names of config files
mv "${config_file}" "${config_file}.temp"
mv "${config_background_file}" "${config_file}"
mv "${config_file}.temp" "${config_background_file}"

# Swap names of style files
mv "${style_file}" "${style_file}.temp"
mv "${style_background_file}" "${style_file}"
mv "${style_file}.temp" "${style_background_file}"

# kill first
killall -q waybar

# Wait for waybar to exit.
while pgrep -x waybar >/dev/null; do sleep1; done

# start up again
CONFIG="$HOME/.config/waybar/active/config.jsonc"
 STYLE="$HOME/.config/waybar/active/style.css"

waybar \
  --bar main-bar \
  --log-level error \
  --config ${CONFIG} \
  --style ${STYLE} &
