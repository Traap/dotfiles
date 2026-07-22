local function set_workspace_monitor(workspace, monitor)
  hl.workspace_rule({ workspace = tostring(workspace), monitor = monitor })
end

local function apply_layout(monitors, workspace_monitors)
  for _, monitor in ipairs(monitors) do
    hl.monitor(monitor)
  end

  for workspace, monitor in pairs(workspace_monitors) do
    set_workspace_monitor(workspace, monitor)
  end
end

local function all_workspaces_on(monitor)
  local rules = {}
  for workspace = 1, 10 do
    rules[workspace] = monitor
  end
  return rules
end

local function split_workspaces(primary, secondary)
  local rules = {}
  for workspace = 1, 5 do
    rules[workspace] = primary
  end
  for workspace = 6, 10 do
    rules[workspace] = secondary
  end
  return rules
end

local layouts = {
  high_res_laptop = {
    monitors = {
      { output = "eDP-1", mode = "3840x2400@60", position = "0x0", scale = 1.875 },
    },
    workspaces = all_workspaces_on("eDP-1"),
  },

  high_res_laptop_with_38inch = {
    monitors = {
      { output = "eDP-1", mode = "3840x2400@60", position = "0x0", scale = 1.6 },
      { output = "HDMI-A-1", mode = "3840x2160@59.94", position = "0x-2160", scale = 1 },
    },
    workspaces = split_workspaces("eDP-1", "HDMI-A-1"),
  },

  ultra_gear = {
    monitors = {
      { output = "DP-4", mode = "2560x2160@75", position = "0x0", scale = 1 },
      { output = "HDMI-A-1", mode = "2560x2160@75", position = "2560x0", scale = 1 },
    },
    workspaces = split_workspaces("DP-4", "HDMI-A-1"),
  },

  twenty_seven_inch = {
    monitors = {
      { output = "eDP-1", mode = "2560x1440@60", position = "0x0", scale = 1 },
    },
    workspaces = all_workspaces_on("eDP-1"),
  },

  low_res_laptop = {
    monitors = {
      { output = "eDP-1", mode = "2560x1440@60", position = "0x0", scale = 1 },
    },
    workspaces = all_workspaces_on("eDP-1"),
  },
}

local hostname = os.getenv("HOSTNAME") or ""
local monitor_count = #hl.get_monitors()
local selected = layouts.high_res_laptop

if hostname == "GSA-AXA89M" and monitor_count == 2 then
  selected = layouts.high_res_laptop_with_38inch
elseif hostname == "GSA-AXA89M" then
  selected = layouts.high_res_laptop
elseif hostname == "DarkKnight" then
  selected = layouts.ultra_gear
elseif hostname == "Ninja" then
  selected = layouts.high_res_laptop
elseif hostname == "Tank" then
  selected = layouts.twenty_seven_inch
elseif hostname == "Zero" then
  selected = layouts.low_res_laptop
end

apply_layout(selected.monitors, selected.workspaces)
