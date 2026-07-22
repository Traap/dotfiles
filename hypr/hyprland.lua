-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Load Omarchy defaults, excluding default.hypr.autostart so this config can
-- own monitor setup without omarchy-hyprland-monitor-watch changing it later.
require("default.hypr.helpers")
local require_optional = require("default.hypr.require_optional")

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
