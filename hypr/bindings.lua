local vars = require("hypr.vars")

local function unbind(keys)
  hl.unbind(keys)
end

local function bind_dispatch(keys, description, dispatcher)
  hl.bind(keys, hl.dsp.exec_raw(dispatcher), { description = description })
end

-- Launch applications.
o.bind("SUPER + A", "ChatGPT", 'omarchy-launch-webapp "https://chatgpt.com"')

unbind("SUPER + SHIFT + E")
unbind("SUPER + E")
o.bind("SUPER + SHIFT + E", "Calendar", 'omarchy-launch-or-focus-webapp Calendar "https://app.hey.com/calendar/weeks/"')
o.bind("SUPER + E", "Email", 'omarchy-launch-or-focus-webapp Email "https://app.hey.com"')

unbind("SUPER + L")
o.bind("SUPER + L", "Lock Screen", "omarchy-lock-screen")

unbind("SUPER + N")
o.bind("SUPER + N", "File Manager", vars.file_manager)

unbind("SUPER + P")
o.bind("SUPER + P", "1 Password", vars.password_manager)

unbind("SUPER + O")
o.bind("SUPER + O", "LibreOffice", vars.office)

unbind("SUPER + Q")
o.bind("SUPER + Q", "Kill all", hl.dsp.window.close())

unbind("SUPER + R")
o.bind("SUPER + R", "Toggle Bracco", vars.bin_home .. "/remmina-noswap")

unbind("SUPER + RETURN")
o.bind("SUPER + RETURN", "Terminal", "ghostty")

unbind("SUPER + SPACE")
unbind("SUPER + code:61")
unbind("SUPER + ALT + code:61")
o.bind("SUPER + SLASH", "Launch apps", "omarchy-launch-walker")

unbind("SUPER + S")
o.bind("SUPER + S", "Screenshot", "omarchy-capture-screenshot")

unbind("SUPER + SHIFT + T")
o.bind("SUPER + SHIFT + T", "Teams", 'omarchy-launch-or-focus-webapp Teams "https://teams.microsoft.com/v2/"')

unbind("SUPER + T")
o.bind("SUPER + T", "Outlook", 'omarchy-launch-or-focus-webapp Outlook "https://outlook.office365.com/mail"')

unbind("SUPER + V")
o.bind("SUPER + V", "OBS", "obs")

unbind("SUPER + W")
o.bind("SUPER + W", "Browser", vars.browser)

unbind("SUPER + Y")
o.bind("SUPER + Y", "YouTube", 'omarchy-launch-or-focus-webapp YouTube "https://youtube.com/"')

unbind("SUPER + Z")
o.bind("SUPER + Z", "Screen Key", "screenkey")

unbind("SUPER + CTRL + B")
o.bind("SUPER + CTRL + B", "System btop", "omarchy-launch-tui btop")

unbind("SUPER + CTRL + G")
o.bind("SUPER + CTRL + G", "GitHub", 'omarchy-launch-webapp "https://www.github.com/Traap/"')

unbind("SUPER + CTRL + K")
o.bind("SUPER + CTRL + K", "KJV", 'omarchy-launch-webapp "https://www.kingjamesbibleonline.org"')

unbind("SUPER + CTRL + N")
o.bind("SUPER + CTRL + N", "Editor", "omarchy-launch-editor")

unbind("SUPER + CTRL + R")
o.bind("SUPER + CTRL + R", "Hyprland reload", "hyprctl reload")

unbind("SUPER + CTRL + W")
o.bind("SUPER + CTRL + W", "Browser (private)", vars.browser .. " --private")

unbind("SUPER + SHIFT + M")
o.bind("SUPER + SHIFT + M", "Menu", "omarchy-menu")

-- Toggle tmux sessions. Keep these in sync with bash aliases and tmux config.
unbind("ALT + D")
o.bind("ALT + D", "Toggle DataRunner", vars.bin_home .. "/toggler DataRunner")

unbind("ALT + N")
o.bind("ALT + N", "Toggle Neovim", vars.bin_home .. "/toggler Neovim")

unbind("ALT + P")
o.bind("ALT + P", "Toggle Paperboy", vars.bin_home .. "/toggler Paperboy")

unbind("ALT + U")
o.bind("ALT + U", "Toggle Upgrade", vars.bin_home .. "/toggler Upgrade")

unbind("ALT + W")
o.bind("ALT + W", "Toggle Work", vars.bin_home .. "/toggler Work")

unbind("ALT + Y")
o.bind("ALT + Y", "Toggle YouTube", vars.bin_home .. "/toggler YouTube")

unbind("ALT + Z")
o.bind("ALT + Z", "Toggle Zero", vars.bin_home .. "/toggler Zero")

unbind("ALT + SHIFT + D")
o.bind("ALT + SHIFT + D", "Kill DataRunner", "tmux kill-session -t DataRunner")

unbind("ALT + SHIFT + N")
o.bind("ALT + SHIFT + N", "Kill Neovim", "tmux kill-session -t Neovim")

unbind("ALT + SHIFT + P")
o.bind("ALT + SHIFT + P", "Kill Paperboy", "tmux kill-session -t Paperboy")

unbind("ALT + SHIFT + U")
o.bind("ALT + SHIFT + U", "Kill Upgrade", "tmux kill-session -t YouTube")

unbind("ALT + SHIFT + W")
o.bind("ALT + SHIFT + W", "Kill Work", "tmux kill-session -t Work")

unbind("ALT + SHIFT + Y")
o.bind("ALT + SHIFT + Y", "Kill YouTube", "tmux kill-session -t YouTube")

unbind("ALT + SHIFT + Z")
o.bind("ALT + SHIFT + Z", "Kill Zero", "tmux kill-session -t Zero")

-- Hide/unhide active workspace.
unbind("ALT + A")
bind_dispatch("ALT + A", "Toggle Workspace", "togglespecialworkspace magic")
bind_dispatch("ALT + A", "Toggle Workspace", "movetoworkspace +0")
bind_dispatch("ALT + A", "Toggle Workspace", "togglespecialworkspace magic")
bind_dispatch("ALT + A", "Toggle Workspace", "movetoworkspace special:magic")
bind_dispatch("ALT + A", "Toggle Workspace", "togglespecialworkspace magic")

-- Vim-style directional focus movement.
unbind("ALT + H")
bind_dispatch("ALT + H", "Move focus left", "movefocus l")

unbind("ALT + J")
bind_dispatch("ALT + J", "Move focus down", "movefocus d")

unbind("ALT + K")
bind_dispatch("ALT + K", "Move focus up", "movefocus u")

unbind("ALT + L")
bind_dispatch("ALT + L", "Move focus right", "movefocus r")

-- Move active window between monitors/workspaces.
unbind("ALT + SHIFT + H")
bind_dispatch("ALT + SHIFT + H", "Move active left", "movewindow l")

unbind("ALT + SHIFT + J")
bind_dispatch("ALT + SHIFT + J", "Move active down", "movewindow d")

unbind("ALT + SHIFT + K")
bind_dispatch("ALT + SHIFT + K", "Move active up", "movewindow u")

unbind("ALT + SHIFT + L")
bind_dispatch("ALT + SHIFT + L", "Move active right", "movewindow r")

-- Move window silently to workspace.
for workspace = 1, 10 do
  local key = workspace == 10 and "0" or tostring(workspace)
  unbind("SUPER + SHIFT + ALT + " .. key)
  bind_dispatch(
    "SUPER + ALT + " .. key,
    "Silently move to workspace " .. workspace,
    "movetoworkspacesilent " .. workspace
  )
end

-- Special workspaces (scratchpad).
unbind("SUPER + ALT + S")
bind_dispatch("SUPER + ALT + S", "Move to silent", "movetoworkspacesilent special")

unbind("SUPER + SHIFT + S")
bind_dispatch("SUPER + SHIFT + S", "Toggle silent", "togglespecialworkspace")

-- Switch workspaces relative to the active workspace.
unbind("SUPER + CTRL + right")
bind_dispatch("SUPER + CTRL + right", "Switch workspace right", "workspace r+1")

unbind("SUPER + CTRL + left")
bind_dispatch("SUPER + CTRL + left", "Switch workspace left", "workspace r-1")

unbind("SUPER + CTRL + up")
bind_dispatch("SUPER + CTRL + up", "Switch workspace up", "workspace empty")

unbind("SUPER + CTRL + down")
bind_dispatch("SUPER + CTRL + down", "Switch workspace down", "workspace empty")

-- Resize active window.
unbind("SUPER + SHIFT + H")
bind_dispatch("SUPER + SHIFT + H", "Resize active left", "resizeactive -15 0")

unbind("SUPER + SHIFT + J")
bind_dispatch("SUPER + SHIFT + J", "Resize active right", "resizeactive 0 15")

unbind("SUPER + SHIFT + K")
bind_dispatch("SUPER + SHIFT + K", "Resize active up", "resizeactive 0 -15")

unbind("SUPER + SHIFT + L")
bind_dispatch("SUPER + SHIFT + L", "Resize active down", "resizeactive 15 0")

hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("swaylock && systemctl suspend"), { locked = true })
