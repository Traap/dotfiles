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
--
-- monitor-settings still calls o.workspaces.identities() to match a saved
-- display-panel choice to the physical monitor. That is the same naming
-- monitor-workspaces uses: make, model and serial, with " #2" and so on when
-- two monitors report the same description. A remembered identity is kept
-- while that monitor stays plugged in.
local monitor_identity = {}

local function monitor_identities()
  if not hl or not hl.get_monitors then
    return {}
  end

  local listed = hl.get_monitors()
  -- The keybindings menu scans this config with a metatable-backed proxy.
  -- Iterating that proxy never ends, because every numeric lookup exists.
  if type(listed) ~= "table" or getmetatable(listed) ~= nil then
    return {}
  end

  local monitors = {}
  for _, monitor in ipairs(listed) do
    if not monitor.is_mirror then
      monitors[#monitors + 1] = monitor
    end
  end

  local identities = {}
  local taken = {}

  local function described(monitor)
    local description = monitor.description or ""
    if description ~= "" then
      return description
    end
    return monitor.name
  end

  for _, monitor in ipairs(monitors) do
    local identity = monitor_identity[monitor.name]
    if identity and not taken[identity] and identity:gsub(" #%d+$", "") == described(monitor) then
      identities[monitor.name] = identity
      taken[identity] = true
    end
  end

  local ordered = {}
  for _, monitor in ipairs(monitors) do
    ordered[#ordered + 1] = monitor
  end
  table.sort(ordered, function(left, right)
    return left.name < right.name
  end)

  for _, monitor in ipairs(ordered) do
    if not identities[monitor.name] then
      local identity = described(monitor)
      local count = 1
      while taken[identity] do
        count = count + 1
        identity = described(monitor) .. " #" .. count
      end
      identities[monitor.name] = identity
      taken[identity] = true
    end
  end

  monitor_identity = identities
  return identities
end

o.workspaces = {
  identities = monitor_identities,
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
