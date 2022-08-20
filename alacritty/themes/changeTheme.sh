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

theme=${1%.*}

if [[ "${_themes[*]}" =~ $theme ]]; then
  echo "Theme changed to [${theme}]."
  path=~/.config/alacritty/themes
  cp $path/$theme.yml $path/.default.yml
else
  echo "Theme [$theme] is not supported."
fi
