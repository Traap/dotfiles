local omarchy_monitor_scale = 1

local function detected_hostname()
  local hostname = os.getenv("HOSTNAME")
  if hostname and hostname ~= "" then
    return hostname
  end

  local file = io.open("/etc/hostname", "r")
  if not file then
    return ""
  end

  hostname = file:read("*l") or ""
  file:close()
  return hostname
end

local function set_workspace_monitor(workspace, monitor)
  hl.workspace_rule({
    workspace = tostring(workspace),
    monitor = monitor,
    persistent = true,
  })
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

local function find_ultra_gear_full_width_output()
  local outputs = {}
  for _, monitor in ipairs(hl.get_monitors()) do
    outputs[monitor.name] = monitor
  end

  -- Prefer DisplayPort for the 165 Hz link. HDMI remains a supported fallback.
  for _, output in ipairs({ "DP-4", "HDMI-A-1" }) do
    local monitor = outputs[output]
    -- PIP reports each half as 520 mm wide; full-width mode reports 1040 mm.
    if monitor and monitor.physical_width >= 1000 then
      return output
    end
  end

  return nil
end

local function ultra_gear_layout()
  local full_width_output = find_ultra_gear_full_width_output()
  if full_width_output then
    local monitors = {
      { output = full_width_output, mode = "5120x2160@165", position = "0x0", scale = 1 },
    }

    -- Remove the unused PIP half and any output retained from the old DP-3
    -- single-monitor profile.
    for _, output in ipairs({ "DP-3", "DP-4", "HDMI-A-1" }) do
      if output ~= full_width_output then
        table.insert(monitors, { output = output, disabled = true })
      end
    end

    return {
      monitors = monitors,
      workspaces = all_workspaces_on(full_width_output),
    }
  end

  return {
    monitors = {
      { output = "DP-3",     disabled = true },
      { output = "DP-4",     mode = "2560x2160@75", position = "0x0",    scale = 1 },
      { output = "HDMI-A-1", mode = "2560x2160@75", position = "2560x0", scale = 1 },
    },
    workspaces = split_workspaces("DP-4", "HDMI-A-1"),
  }
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
      { output = "eDP-1",    mode = "3840x2400@60",    position = "0x0",     scale = 1.6 },
      { output = "HDMI-A-1", mode = "3840x2160@59.94", position = "0x-2160", scale = 1 },
    },
    workspaces = split_workspaces("eDP-1", "HDMI-A-1"),
  },

  twenty_seven_inch = {
    monitors = {
      { output = "eDP-1", mode = "2560x1440@60", position = "0x0", scale = 1 },
    },
    workspaces = all_workspaces_on("eDP-1"),
  },

  low_res_laptop = {
    monitors = {
      { output = "eDP-1", mode = "preferred", position = "0x0", scale = omarchy_monitor_scale },
    },
    workspaces = all_workspaces_on("eDP-1"),
  },
}

local hostname = detected_hostname()
local monitor_count = #hl.get_monitors()
local selected = layouts.high_res_laptop

if hostname == "GSA-AXA89M" and monitor_count == 2 then
  selected = layouts.high_res_laptop_with_38inch
elseif hostname == "GSA-AXA89M" then
  selected = layouts.high_res_laptop
elseif hostname == "DarkKnight" then
  selected = ultra_gear_layout()
elseif hostname == "Ninja" then
  selected = layouts.low_res_laptop
elseif hostname == "Tank" then
  selected = layouts.twenty_seven_inch
elseif hostname == "Zero" then
  selected = layouts.low_res_laptop
end

apply_layout(selected.monitors, selected.workspaces)

if hostname == "DarkKnight" then
  local function ultra_gear_layout_is_applied()
    local monitors = hl.get_monitors()
    local full_width_output = find_ultra_gear_full_width_output()

    if full_width_output then
      return #monitors == 1
        and monitors[1].name == full_width_output
        and monitors[1].width == 5120
        and monitors[1].refresh_rate >= 164
    end

    local outputs = {}
    for _, monitor in ipairs(monitors) do
      outputs[monitor.name] = monitor
    end

    return #monitors == 2
      and outputs["DP-4"] ~= nil
      and outputs["DP-4"].width == 2560
      and outputs["DP-4"].x == 0
      and outputs["HDMI-A-1"] ~= nil
      and outputs["HDMI-A-1"].width == 2560
      and outputs["HDMI-A-1"].x == 2560
  end

  local function reload_after_monitor_change()
    -- Allow the new EDID/mode list to settle before selecting PIP or 5120-wide.
    hl.timer(function()
      if not ultra_gear_layout_is_applied() then
        hl.exec_cmd("hyprctl reload")
      end
    end, { timeout = 750, type = "oneshot" })
  end

  hl.on("monitor.added", reload_after_monitor_change)
  hl.on("monitor.layout_changed", reload_after_monitor_change)
  hl.on("monitor.removed", reload_after_monitor_change)
end
