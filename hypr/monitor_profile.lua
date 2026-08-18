-- Describe monitor layouts once so display setup and appearance agree.

local M = {}

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

local function connected_monitors()
  -- Tests can load this module without Hyprland's global hl object.
  if not hl or not hl.get_monitors then
    return {}
  end

  return hl.get_monitors()
end

local function find_ultra_gear_full_width_output()
  local outputs = {}
  for _, monitor in ipairs(connected_monitors()) do
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
      {
        output = full_width_output,
        mode = "5120x2160@165",
        position = "0x0",
        scale = 1,
      },
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
      {
        output = "DP-4",
        mode = "2560x2160@75",
        position = "0x0",
        scale = 1,
      },
      {
        output = "HDMI-A-1",
        mode = "2560x2160@75",
        position = "2560x0",
        scale = 1,
      },
    },
    workspaces = split_workspaces("DP-4", "HDMI-A-1"),
  }
end

local layouts = {
  high_res_laptop = {
    monitors = {
      {
        output = "eDP-1",
        mode = "3840x2400@60",
        position = "0x0",
        scale = 1.875,
      },
    },
    workspaces = all_workspaces_on("eDP-1"),
  },

  high_res_laptop_with_ultrawide = {
    monitors = {
      {
        output = "eDP-1",
        mode = "3840x2400@60",
        position = "0x0",
        scale = 1.6,
      },
      {
        output = "HDMI-A-1",
        mode = "3440x1440@72",
        position = "0x-1440",
        scale = 1,
      },
    },
    workspaces = split_workspaces("HDMI-A-1", "eDP-1"),
  },

  twenty_seven_inch = {
    monitors = {
      {
        output = "eDP-1",
        mode = "2560x1440@60",
        position = "0x0",
        scale = 1,
      },
    },
    workspaces = all_workspaces_on("eDP-1"),
  },

  low_res_laptop = {
    monitors = {
      {
        output = "eDP-1",
        mode = "preferred",
        position = "0x0",
        scale = omarchy_monitor_scale,
      },
    },
    workspaces = all_workspaces_on("eDP-1"),
  },
}

local function monitor_mode_size(monitor)
  if not monitor or not monitor.mode or monitor.mode == "preferred" then
    return nil
  end

  local width, height = monitor.mode:match("^(%d+)x(%d+)")
  if not width or not height then
    return nil
  end

  return tonumber(width), tonumber(height)
end

local function effective_size(monitor)
  local width, height = monitor_mode_size(monitor)
  if not width or not height then
    return nil
  end

  local scale = monitor.scale or 1
  return width / scale, height / scale
end

local function primary_monitor(layout)
  for _, monitor in ipairs(layout.monitors or {}) do
    if not monitor.disabled then
      return monitor
    end
  end

  return nil
end

function M.detected_hostname()
  return detected_hostname()
end

function M.find_ultra_gear_full_width_output()
  return find_ultra_gear_full_width_output()
end

function M.current_layout()
  local hostname = detected_hostname()
  local monitor_count = #connected_monitors()

  -- Hostnames select stable personal profiles; monitor count refines docks.
  if hostname == "GSA-AXA89M" and monitor_count == 2 then
    return layouts.high_res_laptop_with_ultrawide
  elseif hostname == "GSA-AXA89M" then
    return layouts.high_res_laptop
  elseif hostname == "DarkKnight" then
    return ultra_gear_layout()
  elseif hostname == "Ninja" then
    return layouts.low_res_laptop
  elseif hostname == "Tank" then
    return layouts.twenty_seven_inch
  elseif hostname == "Zero" then
    return layouts.low_res_laptop
  end

  return layouts.high_res_laptop
end

function M.primary_monitor(layout)
  return primary_monitor(layout or M.current_layout())
end

function M.effective_size(monitor)
  return effective_size(monitor)
end

function M.single_window_aspect_ratio(layout)
  layout = layout or M.current_layout()

  -- Effective size is mode divided by scale, matching Hyprland layout space.
  for _, monitor in ipairs(layout.monitors or {}) do
    local width = effective_size(monitor)
    if not monitor.disabled and width and width >= 3200 then
      return { 1.33, 1 }
    end
  end

  return nil
end

return M
