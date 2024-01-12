local wezterm = require "wezterm"
local act = wezterm.action

-- {{{ Event funcdtions

wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(window:active_workspace())
end)

-- ------------------------------------------------------------------------- }}}
-- {{{ Config builder helper

local config = wezterm.config_builder()
config.automatically_reload_config = true

-- ------------------------------------------------------------------------- }}}
-- {{{ Default keys


config.disable_default_key_bindings = false
config.leader = { key = 'Space', mods = 'CTRL', timeout_millisecons = 1000 }
config.keys = {
  { key = "l", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "j", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },

  { key = "h", mods = "CTRL", action = act.ActivatePaneDirection( "Left" ) },
  { key = "j", mods = "CTRL", action = act.ActivatePaneDirection( "Down" ) },
  { key = "k", mods = "CTRL", action = act.ActivatePaneDirection( "Up" ) },
  { key = "l", mods = "CTRL", action = act.ActivatePaneDirection( "Right" ) },

  { key = "r", mods = "LEADER", action = act.RotatePanes( "Clockwise") },
  { key = "q", mods = "LEADER", action = act.CloseCurrentPane{ confirm = true } },

  { key = "a", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "w", mods = "LEADER", action = act.ShowTabNavigator },
}

table.insert(config.keys, {
  key = 'y', mods = 'LEADER', action = act.SwitchToWorkspace{ name = 'default', }
})

table.insert(config.keys, {
  key = 'u', mods = 'LEADER', action = act.SwitchToWorkspace{ name = 'top', }
})

table.insert(config.keys, {
  key = 'i', mods = 'LEADER', action = act.SwitchToWorkspace
})

table.insert(config.keys, {
   key = 'w'
  ,mods = 'ALT'
  ,action = act.ShowLauncherArgs {flags="FUZZY|WORKSPACES"}
})


-- ------------------------------------------------------------------------- }}}
-- {{{ Initial size and color scheme

config.color_scheme = "Tokyo Night"
config.window_background_opacity = 0.90

config.initial_rows = 40
config.initial_cols = 100

config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true

-- ------------------------------------------------------------------------- }}}
-- {{{ Mouse bindings

config.disable_default_mouse_bindings = false

config.mouse_bindings = {
  -- Right click sends "woot" to the terminal
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.SendString 'ls -la',
  },

  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },

  -- and make CTRL-Click open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
}

-- ------------------------------------------------------------------------- }}}
-- {{{ Window frame integration

config.integrated_title_button_alignment = "Right"
config.integrated_title_button_color = "Auto"
config.integrated_title_button_style = "Windows"
config.window_decorations = "RESIZE"
config.window_padding = {
  left=0,
  right=0,
  top=0,
  bottom=0,
}

config.window_frame = {
  font = wezterm.font { family = 'Roboto', weight = 'Bold' },
  font_size = 12.0,
  active_titlebar_bg = '#333333',
  inactive_titlebar_bg = '#333333',
}

-- ------------------------------------------------------------------------- }}}
-- {{{ Tab Bar Appearance & Colors

table.insert(config.keys, {
  key = ",",
  mods = "LEADER",
  action = act.PromptInputLine {
    description = wezterm.format {
      { Attribute = { Intensity = "Bold" } },
      { Foreground = { AnsiColor = "Fuchsia" } },
      { Text = "Renaming Tab Title...:" },
    },
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:active_tab():set_title(line)
      end
    end)
  }
})

for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1),
  })
end

config.colors = {
  tab_bar = {
    inactive_tab_edge = '#575757',
  },
}

config.mouse_wheel_scrolls_tabs = false



-- ------------------------------------------------------------------------- }}}
-- {{{ WSL domains

config.wsl_domains = {
  {
    name = "WSL:Archlinux",
    distribution = "Archlinux",
    username = "traap",
    default_cwd = "/tmp",
    default_prog = {"bash"},
  },
}

-- ------------------------------------------------------------------------- }}}

return config
