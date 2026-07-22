-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

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
