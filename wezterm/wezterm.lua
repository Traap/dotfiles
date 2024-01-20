local wezterm = require "wezterm"
local act = wezterm.action

-- {{{ isNeovim function

local function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

local function get_foreground_process_name(pane)
  return basename(pane:get_foreground_process_name())
end

local function isNeovim(pane)
  return get_foreground_process_name(pane) == 'nvim'
end

-- ------------------------------------------------------------------------- }}}
-- {{{ Another Neovim split?

local function anotherNeovimSplit(pane, direction)
  if     direction == 'Left'  then wezterm.log_info("Left split check.")
  elseif direction == 'Down'  then wezterm.log_info("Down split check.")
  elseif direction == 'Up'    then wezterm.log_info("Up split check.")
  elseif direction == 'Right' then wezterm.log_info("Right split check.")
  else                             wezterm.log_info("Check not supported.")
  end
  return true
end

-- ------------------------------------------------------------------------- }}}
-- {{{ Another Wezterm pane?

local function anotherWeztermPane(pane, direction)
  if     direction == 'Left'  then wezterm.log_info("Left pane check.")
  elseif direction == 'Down'  then wezterm.log_info("Down pane check.")
  elseif direction == 'Up'    then wezterm.log_info("Up pane check.")
  elseif direction == 'Right' then wezterm.log_info("Right pane check.")
  else                             wezterm.log_info("Check pane supported.")
  end return false end

-- ------------------------------------------------------------------------- }}}
-- {{{ Update right status area

-- wezterm.on('update-right-status', function(window, pane)
--   local msg = "[" .. get_foreground_process_name(pane) .. "]: "
--   if isNeovim(pane) then
--     msg = msg .. "Neovim"
--   else
--     msg = msg .. "! nvim"
--   end
--   window:set_right_status(msg)
-- end)

-- ------------------------------------------------------------------------- }}}
-- {{{ Neovim split or wezterm pane movement

local function movement(key, mods, direction)
  local event = "Movement_" .. direction
  wezterm.on(event, function(win, pane)

    if isNeovim(pane) then
      -- if not anotherNeovimSplit(pane, direction) then
      -- TODO: Add wezterm pane check
      -- win:perform_action(act.ActivatePaneDirection(direction), pane)
      -- else
      win:perform_action({SendKey = {key = 'w', mods = mods }}, pane)
      win:perform_action({SendKey = {key = key }}, pane)
      -- end
    else
      -- if not anotherWeztermPane(pane, direction) then
      -- TODO: Add Neovim split check
      -- win:perform_action({SendKey = {key = key, mods = mods }}, pane)
      -- else
      win:perform_action(act.ActivatePaneDirection(direction), pane)
      -- end
    end
  end)
  return {
    key = key,
    mods = mods,
    action = wezterm.action.EmitEvent(event),
  }
end

-- ------------------------------------------------------------------------- }}}
-- {{{ Config builder helper

local config = wezterm.config_builder()
config.automatically_reload_config = true

-- ------------------------------------------------------------------------- }}}
-- {{{ General settings.

config.color_scheme = "Tokyo Night"
config.window_background_opacity = 0.90
config.text_background_opacity = 1.0

config.initial_rows = 45
config.initial_cols = 90

config.enable_tab_bar = true
config.exit_behavior = "Close"

-- ------------------------------------------------------------------------- }}}
-- {{{ Key bindings

config.disable_default_key_bindings = false

config.leader = { key = 'Space', mods = 'CTRL', timeout_millisecons = 1000 }

config.keys = {

  -- Horizontal and vertial wezterm pain splits.
  { key = "l", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "j", mods = "LEADER", action = act.SplitVertical   { domain = "CurrentPaneDomain" } },

  -- wezterm SendKey example
  {
    key = 'LeftArrow',
    action = act.Multiple {
      act.SendKey { key = 'l' },
      act.SendKey { key = 'e' },
      act.SendKey { key = 'f' },
      act.SendKey { key = 't' },
    },
  },

  movement("h", "CTRL", "Left"),
  movement("j", "CTRL", "Down"),
  movement("k", "CTRL", "Up"),
  movement("l", "CTRL", "Right"),

  { key = "r", mods = "LEADER", action = act.RotatePanes( "Clockwise") },
  { key = "q", mods = "LEADER", action = act.CloseCurrentPane{ confirm = true } },

  { key = "a", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },

}

-- ------------------------------------------------------------------------- }}}
-- {{{ Fonts

config.font_size = 12.0

config.font = wezterm.font_with_fallback {
  { family = 'JetBrainsMono Nerd Font Mono', weight = 'DemiBold', italic = true },
  { family = 'Nerd Font Symbols Font', weight = 'DemiBold', italic = true },
}

-- ------------------------------------------------------------------------- }}}
-- {{{ Mouse

-- NOTE: All mouse configurations are listed along with most defaults.

config.alternate_buffer_wheel_scroll_speed = 3
config.bypass_mouse_reporting_modifiers = 'ALT'
config.disable_default_mouse_bindings = false
config.hide_mouse_cursor_when_typing = true
config.mouse_wheel_scrolls_tabs = false
config.pane_focus_follows_mouse = false
config.selection_word_boundary = " \t\n{}[]()\"'`"
config.swallow_mouse_click_on_pane_focus = false
config.swallow_mouse_click_on_window_focus = true
config.quote_dropped_files = "SpacesOnly"
config.enable_wayland = true

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

  {
    event = { Drag = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.StartWindowDrag,
  },
}

-- ------------------------------------------------------------------------- }}}
-- {{{ Workspaces

config.default_workspace = "Daryn"

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
config.window_decorations = "TITLE|RESIZE"
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

  -- border_left_color   = 'purple',
  -- border_right_color  = 'purple',
  -- border_bottom_color = 'purple',
  -- border_top_color    = 'purple'
}

for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i), mods = "CTRL|ALT", action = act.ActivateWindow(i - 1),
  })
end

-- ------------------------------------------------------------------------- }}}
-- {{{ Panes

config.inactive_pane_hsb = {
  saturation = 1.0,
  hue = 1.0,
  brightness = 1.0,
}

-- ------------------------------------------------------------------------- }}}
-- {{{ Tab Bar

config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 25
config.use_fancy_tab_bar = true

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
    key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - 1),
  })
end

table.insert(config.keys, {
  key = 't', mods = 'LEADER', action = act.ShowTabNavigator
})

-- config.colors = {
--   tab_bar = {
--     inactive_tab_edge = '#575757',
--   },
-- }

config.colors = {
  tab_bar = {
    background = '#1b1032',

    active_tab = {
      bg_color = '#7aa2f7',
      fg_color = '#32344a',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },

    inactive_tab = {
      bg_color = '#32344a',
      fg_color = '#7aa2f7',
    },

    inactive_tab_hover = {
      bg_color = '#e0af68',
      fg_color = '#32344a',
      italic = true,
    },

    new_tab = {
      bg_color = '#1b1032',
      fg_color = '#787c99',
    },

    new_tab_hover = {
      bg_color = '#1b1032',
      fg_color = '#9ece6b',
      italic = false,
    },
  },
}

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
