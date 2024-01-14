local wezterm = require "wezterm"
local act = wezterm.action

-- {{{ Event functions

-- wezterm.on('update-right-status', function(window, pane)
--   window:set_right_status(window:active_workspace())
-- end)

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

local function isNvim(pane)
  return (basename(pane:get_foreground_process_name())) == 'nvim'
end

wezterm.on('update-right-status', function(window, pane)
  if isNvim(pane) then
    window:set_right_status("Neovim")
  else
    window:set_right_status("!nvim")
  end
  -- window:set_right_status(basename(pane:get_foreground_process_name()))
end)

-- ------------------------------------------------------------------------- }}}
-- {{{ Config builder helper

local config = wezterm.config_builder()
config.automatically_reload_config = true

-- ------------------------------------------------------------------------- }}}
-- {{{ Keybindings

config.disable_default_key_bindings = true

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
  { key = "t", mods = "LEADER", action = act.ShowTabNavigator },
}

-- ------------------------------------------------------------------------- }}}
-- {{{ Fonts

config.font_size = 12.0

config.font = wezterm.font('JetBrains Mono', {
  weight = 'DemiBold',
  italic = true,
})


-- ------------------------------------------------------------------------- }}}
-- {{{ Initial size and color scheme

config.color_scheme = "Tokyo Night"
config.window_background_opacity = 0.90
config.text_background_opacity = 1.0

config.initial_rows = 40
config.initial_cols = 100

config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true

-- ------------------------------------------------------------------------- }}}
-- {{{ Mouse bindings

config.disable_default_mouse_bindings = true

config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Middle" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
			end
		end),
	},
}

-- ------------------------------------------------------------------------- }}}
-- {{{ Workspaces

table.insert(config.keys, {
  key = 'k', mods = 'LEADER', action = act.SwitchToWorkspace{ name = 'Work', }
})

table.insert(config.keys, {
  key = 'n', mods = 'LEADER', action = act.SwitchToWorkspace{ name = 'Neovim', }
})

table.insert(config.keys, {
  key = 'W', mods = 'LEADER', action = act.SwitchToWorkspace{ name = 'Wiki', }
})

table.insert(config.keys, {
  key = 'u', mods = 'LEADER', action = act.SwitchToWorkspace{ name = 'Upgrade', }
})

table.insert(config.keys, {
  key = 'y', mods = 'LEADER', action = act.SwitchToWorkspace{ name = 'YouTube', }
})

table.insert(config.keys, {
   key = 'w' ,mods = 'LEADER', action = act.ShowLauncherArgs {flags="WORKSPACES"}
})

-- ------------------------------------------------------------------------- }}}
-- {{{ Window

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
  font = wezterm.font { family = 'JetBrains Mono', weight = 'Bold' },
  font_size = 9.0,

  active_titlebar_border_bottom  = 'purple',
  active_titlebar_bg             = '#1a1b26',

  inactive_titlebar_border_bottom = '#1a1b26',
  inactive_titlebar_bg            = '#1a1b26',

  button_bg = '#1a1b26',
  button_fg = '#c0caf5',

  button_hover_fg = '#c0caf5',
  button_hover_bg = '#cacaf5',

  -- border_left_colo   = 'purple',
  -- border_right_color  = 'purple',
  -- border_bottom_color = 'purple',
  -- border_top_color    = 'purple'
}

-- ------------------------------------------------------------------------- }}}
-- {{{ Panes

config.inactive_pane_hsb = {
  saturation = 1.0,
  hue = 1.0,
  brightness = 1.0,
}

-- ------------------------------------------------------------------------- }}}
-- {{{ Tab Bar

table.insert(config.keys, {
  key = ",",
  mods = "LEADER",
  action = act.PromptInputLine {
    description = wezterm.format {
      { Attribute = { Intensity = "Bold" } },
      { Foreground = { AnsiColor = "Fuchsia" } },
      { Text = "Rename Tab ...:" },
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
    -- inactive_tab_edge = '#575757',
  },
}

config.mouse_wheel_scrolls_tabs = false
config.hide_tab_bar_if_only_one_tab = true
config.hide_mouse_cursor_when_typing = true
config.show_tab_index_in_tab_bar = false
config.tab_max_width = 25

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
