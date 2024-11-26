#!/bin/sh
# "Change keyboard layout in" "~/.config/hypr/hyprland.conf" " " \

yad --width=530 --height=550 \
--center \
--fixed \
--title="Garuda Hyprland Keybindings" \
--no-buttons \
--list \
--column=Key: \
--column=Description: \
--column=Command: \
--timeout=60 \
--timeout-indicator=right \
"ESC" "close this app" "" "=" "modkey" "(set mod Mod4)" \
"+enter/+t" "Terminal" "(foot)" \
"+d" "Application Menu" "(wofi)" \
"+Shift+d" "Full Launcher" "(nwggrid)" \
"+o" "" "Open Broswer" \
"+n" "" "Open Files" \
"+q" "close focused app" "(kill)" \
"Print" "screenshot" "(grimblast)" \
"Shift+Print" "screenshot region" "(grimblast)" \
"+Print" "screenshot window" "(grimblast)" \
"+Shift+e" "power-menu" "(wofi)" \
"+Shift+c" "Change wallpaper" "(wpaperd)" \
"+f" "Fullscreen" "Toggles to full screen" \
"+Shift+f" "Fake fullscreen" "Behave full screen without full screen" \
"+Shift+Spacebar" "Float" "Toggle windows to float" \
"+p" "Dwindle effect" "pseudo" \
"+Shift+p" "Dwindle effect" "toggle split" \
"+i" "Calamares" "Install Garuda Hyprland" \
"" "" "     Window closed in 60 sec."\
