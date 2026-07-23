-- {{{ Local lua functions

local vars = require("hypr.vars")

local function unbind(keys)
  hl.unbind(keys)
end

local function bind(keys, description, dispatcher)
  unbind(keys)
  o.bind(keys, description, dispatcher)
end

local function bind_dispatch(keys, description, ...)
  unbind(keys)
  for _, dispatcher in ipairs({ ... }) do
    o.bind(keys, description, dispatcher)
  end
end

-- -------------------------------------------------------------------------- }}}
-- {{{ Launch applications.

bind("SUPER + A", "ChatGPT", 'omarchy-launch-webapp "https://chatgpt.com"')

bind("SUPER + E", "Email", 'omarchy-launch-or-focus-webapp Email "https://app.hey.com"')

bind("SUPER + SHIFT + E", "Calendar", 'omarchy-launch-or-focus-webapp Calendar "https://app.hey.com/calendar/weeks/"')

bind("SUPER + L", "Lock Screen", "omarchy-lock-screen")

bind("SUPER + N", "File Manager", vars.file_manager)

bind("SUPER + P", "1 Password", vars.password_manager)

bind("SUPER + O", "LibreOffice", vars.office)

bind("SUPER + Q", "Kill all", hl.dsp.window.close())

bind("SUPER + R", "Toggle Bracco", vars.bin_home .. "/remmina-noswap")

bind("SUPER + RETURN", "Terminal", "ghostty")

-- Hyprland physical keycode for the / key.
unbind("SUPER + code:61")
unbind("SUPER + ALT + code:61")

unbind("SUPER + SPACE")

bind("SUPER + SLASH", "Launch apps", "omarchy-launch-walker")

bind("SUPER + S", "Screenshot", "omarchy-capture-screenshot")

bind("SUPER + SHIFT + T", "Teams", 'omarchy-launch-or-focus-webapp Teams "https://teams.microsoft.com/v2/"')

bind("SUPER + T", "Outlook", 'omarchy-launch-or-focus-webapp Outlook "https://outlook.office365.com/mail"')

bind("SUPER + V", "OBS", "obs")

bind("SUPER + W", "Browser", vars.browser)

bind("SUPER + Y", "YouTube", 'omarchy-launch-or-focus-webapp YouTube "https://youtube.com/"')

bind("SUPER + Z", "Screen Key", "screenkey")

bind("SUPER + CTRL + B", "System btop", "omarchy-launch-tui btop")

bind("SUPER + CTRL + G", "GitHub", 'omarchy-launch-webapp "https://www.github.com/Traap/"')

bind("SUPER + CTRL + K", "KJV", 'omarchy-launch-webapp "https://www.kingjamesbibleonline.org"')

bind("SUPER + CTRL + N", "Editor", "omarchy-launch-editor")

bind("SUPER + CTRL + R", "Hyprland reload", "hyprctl reload")

bind("SUPER + CTRL + W", "Browser (private)", vars.browser .. " --private")

bind("SUPER + SHIFT + M", "Menu", "omarchy-menu")

-- -------------------------------------------------------------------------- }}}
-- {{{ Toggle tmux sessions.
--      NOTE: Keep these in sync with bash aliases and tmux config.

bind("ALT + D", "Toggle DataRunner", vars.bin_home .. "/toggler DataRunner")

bind("ALT + N", "Toggle Neovim", vars.bin_home .. "/toggler Neovim")

bind("ALT + P", "Toggle Paperboy", vars.bin_home .. "/toggler Paperboy")

bind("ALT + U", "Toggle Upgrade", vars.bin_home .. "/toggler Upgrade")

bind("ALT + W", "Toggle Work", vars.bin_home .. "/toggler Work")

bind("ALT + Y", "Toggle YouTube", vars.bin_home .. "/toggler YouTube")

bind("ALT + Z", "Toggle Zero", vars.bin_home .. "/toggler Zero")

bind("ALT + SHIFT + D", "Kill DataRunner", "tmux kill-session -t DataRunner")

bind("ALT + SHIFT + N", "Kill Neovim", "tmux kill-session -t Neovim")

bind("ALT + SHIFT + P", "Kill Paperboy", "tmux kill-session -t Paperboy")

bind("ALT + SHIFT + U", "Kill Upgrade", "tmux kill-session -t YouTube")

bind("ALT + SHIFT + W", "Kill Work", "tmux kill-session -t Work")

bind("ALT + SHIFT + Y", "Kill YouTube", "tmux kill-session -t YouTube")

bind("ALT + SHIFT + Z", "Kill Zero", "tmux kill-session -t Zero")

-- ------------------------------------------------------------------------- }}}
-- {{{ Hide/unhide active workspace.

unbind("ALT + A")
hl.bind("ALT + A", function()
  local magic = hl.get_workspace("special:magic")

  if magic and magic.windows > 0 then
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
  else
    hl.dispatch(hl.dsp.window.move({ workspace = "special:magic", follow = false }))
  end
end, { description = "Toggle Workspace" })

-- ------------------------------------------------------------------------- }}}
-- {{{ Vim-style directional focus movement.

bind_dispatch("ALT + H", "Move focus left", hl.dsp.focus({ direction = "l" }))

bind_dispatch("ALT + J", "Move focus down", hl.dsp.focus({ direction = "d" }))

bind_dispatch("ALT + K", "Move focus up", hl.dsp.focus({ direction = "u" }))

bind_dispatch("ALT + L", "Move focus right", hl.dsp.focus({ direction = "r" }))

-- ------------------------------------------------------------------------- }}}
-- {{{ Move active window between monitors/workspaces.

bind_dispatch("ALT + SHIFT + H", "Move active left", hl.dsp.window.move({ direction = "l" }))

bind_dispatch("ALT + SHIFT + J", "Move active down", hl.dsp.window.move({ direction = "d" }))

bind_dispatch("ALT + SHIFT + K", "Move active up", hl.dsp.window.move({ direction = "u" }))

bind_dispatch("ALT + SHIFT + L", "Move active right", hl.dsp.window.move({ direction = "r" }))

-- ------------------------------------------------------------------------- }}}
-- {{{ Move window silently to workspace.

for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  unbind("SUPER + SHIFT + ALT + " .. key)
  unbind("SUPER + ALT + " .. key)
  hl.bind(
    "SUPER + ALT + " .. key,
    hl.dsp.window.move({ workspace = tostring(workspace), follow = false }),
    { description = "Silently move to workspace " .. workspace }
  )
end

-- ------------------------------------------------------------------------- }}}
-- {{{ Resize active window.

bind_dispatch(
  "SUPER + SHIFT + H",
  "Resize active left",
  hl.dsp.window.resize({ x = -15, y = 0, relative = true })
)

bind_dispatch(
  "SUPER + SHIFT + J",
  "Resize active right",
  hl.dsp.window.resize({ x = 0, y = 15, relative = true })
)

bind_dispatch(
  "SUPER + SHIFT + K",
  "Resize active up",
  hl.dsp.window.resize({ x = 0, y = -15, relative = true })
)

bind_dispatch(
  "SUPER + SHIFT + L",
  "Resize active down",
  hl.dsp.window.resize({ x = 15, y = 0, relative = true })
)

-- ------------------------------------------------------------------------- }}}
-- {{{ Trigger when the switch is turning off.

hl.bind("switch:on:Lid Switch",
  hl.dsp.exec_cmd("swaylock && systemctl suspend"), { locked = true })

-- ------------------------------------------------------------------------- }}}
