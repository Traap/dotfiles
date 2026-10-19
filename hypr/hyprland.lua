-- Compose Omarchy's defaults with personal Hyprland overrides.

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Load Omarchy defaults, excluding default.hypr.autostart so this config can
-- own monitor setup without omarchy-hyprland-monitor-watch changing it later.
require("default.hypr.helpers")
local require_optional = require("default.hypr.require_optional")

-- Stock tiling bindings call o.workspaces. Loading
-- default.hypr.monitor-workspaces would also put each monitor on its own
-- workspace block and fight hypr.monitors, so these stay global workspaces 1-10.
o.workspaces = {
  focus = function(workspace)
    return hl.dsp.focus({ workspace = tostring(workspace) })
  end,
  move_window = function(workspace, follow)
    return hl.dsp.window.move({
      workspace = tostring(workspace),
      follow = follow ~= false,
    })
  end,
  move_to_monitor = function(direction)
    return hl.dsp.workspace.move({ monitor = direction })
  end,
  move_window_to_monitor = function(direction)
    return hl.dsp.window.move({ monitor = direction })
  end,
}

if _G.omarchy_default_bindings ~= false then
  require("default.hypr.bindings.media")
  require("default.hypr.bindings.clipboard")
  require("default.hypr.bindings.tiling")
  require("default.hypr.bindings.utilities")
  require_optional.module("default.hypr.bindings.applications")
end

require("default.hypr.envs")
require("default.hypr.looknfeel")
require("default.hypr.input")
require("default.hypr.windows")
require_optional.module("omarchy.current.theme.hyprland")

-- Personal overrides. These load after Omarchy's defaults so package updates
-- can improve the defaults without rewriting ~/.config/hypr files.
require("hypr.envs")
require("hypr.looknfeel")
require("hypr.bindings")
require("hypr.input")
require("hypr.monitors")
require("hypr.windowrules")
require("hypr.workspacerules")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")
