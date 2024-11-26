#!/bin/bash

## Set GTK Themes, Icons, Cursor and Fonts

THEME='Arc-Dark'
ICONS='a-candy-beauty-icon-theme'
FONT='Noto Sans 11'
CURSOR='Bibata-Modern-Ice'

SCHEMA='gsettings set org.gnome.desktop.interface'

apply_themes() {
	${SCHEMA} gtk-theme "$THEME"
	${SCHEMA} icon-theme "$ICONS"
	${SCHEMA} cursor-theme "$CURSOR"
	${SCHEMA} font-name "$FONT"
}

apply_themes