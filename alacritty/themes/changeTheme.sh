#!/bin/bash

_themes=(
  "dracula"
  "grubox-dark"
  "konsole-dark-pastels"
  "nord"
  "onedark"
  "solarized-dark"
  "tokyonight"
  "tomorrow-night"
)

if [[ "${_themes[*]}" =~ "$1" ]]; then
  path=~/.config/alacritty/themes
  cp $path/"$1".yml $path/.default.yml
else
  echo "Theme was not changed."
fi
