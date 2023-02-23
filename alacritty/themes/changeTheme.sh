#!/bin/bash

_themes=(
  "afterglow"
  "dracula"
  "grubox-dark"
  "konsole-dark-pastels"
  "nord"
  "onedark"
  "rose-pine"
  "solarized-dark"
  "tokyo-night"
  "tokyo-night-storm"
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
