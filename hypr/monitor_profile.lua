-- Describe monitor layouts once so display setup and appearance agree.

local M = {}

local omarchy_monitor_scale = 1

-- EDID descriptions stay stable when the dock renumbers DVI connectors.
local gsa_laptop = "desc:Samsung Display Corp. 0x4165"
local gsa_laptop_output = "eDP-1"
local gsa_ultrawide = "desc:LG Electronics LG ULTRAWIDE 404NTMXBJ251"
local gsa_mirror =
  "desc:Toshiba America Info Systems Inc TOSHIBA-TV 0x01010101"
local gsa_mirror_candidates = {
  {
    description = "Toshiba America Info Systems Inc TOSHIBA-TV 0x01010101",
    mode = "3840x2160@30",
  },
  {
    description = "DLOGIC Ltd. No Monitor USB_6015-2233",
    mode = "1920x1080@60",
  },
}

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

local function connected_monitor_descriptions()
  local descriptions = {}
  for _, monitor in ipairs(connected_monitors()) do
    descriptions[monitor.description] = true
  end
  return descriptions
end

local function connected_drm_edid_contains(needle)
  -- At login, the kernel can know about a dock display before Hyprland has
  -- emitted monitor.added. Read the already-connected DRM EDIDs so the first
  -- config pass chooses the dock layout instead of briefly putting every
  -- persistent workspace on the laptop display.
  local paths = io.popen(
    "find /sys/class/drm -maxdepth 2 -name edid -type f -print 2>/dev/null"
  )
  if not paths then
    return false
  end

  for path in paths:lines() do
    local edid = io.open(path, "rb")
    if edid then
      local contents = edid:read("*a") or ""
      edid:close()
      if contents:find(needle, 1, true) then
        paths:close()
        return true
      end
    end
  end

  paths:close()
  return false
end

local function monitor_for_description(description)
  for _, monitor in ipairs(connected_monitors()) do
    if monitor.description == description then
      return monitor
    end
  end

  return nil
end

local function connected_mirror()
  for _, candidate in ipairs(gsa_mirror_candidates) do
    local monitor = monitor_for_description(candidate.description)
    if monitor then
      return monitor.name, candidate.mode
    end
  end

  return nil, nil
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
      { output = "DP-3", disabled = true },
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
        output = gsa_laptop,
        mode = "3840x2400@60",
        position = "0x0",
        scale = 1.875,
      },
    },
    workspaces = all_workspaces_on(gsa_laptop),
  },

  high_res_laptop_with_ultrawide = {
    monitors = {
      {
        output = gsa_laptop,
        mode = "3840x2400@60",
        position = "0x0",
        scale = 1.6,
      },
      {
        output = gsa_ultrawide,
        mode = "3440x1440@72",
        position = "0x-1440",
        scale = 1,
      },
    },
    workspaces = split_workspaces(gsa_ultrawide, gsa_laptop),
  },

  high_res_laptop_with_mirror = {
    monitors = {
      {
        output = gsa_laptop,
        mode = "3840x2400@60",
        position = "0x0",
        scale = 1.6,
      },
      {
        output = gsa_mirror,
        mode = "3840x2160@30",
        -- Hyprland's mirror target must be a connector name, not a desc selector.
        mirror = gsa_laptop_output,
        scale = 1,
      },
    },
    workspaces = all_workspaces_on(gsa_laptop),
  },

  high_res_laptop_with_ultrawide_and_mirror = {
    monitors = {
      {
        output = gsa_laptop,
        mode = "3840x2400@60",
        position = "0x0",
        scale = 1.6,
      },
      {
        output = gsa_ultrawide,
        mode = "3440x1440@72",
        position = "0x-1440",
        scale = 1,
      },
      {
        output = gsa_mirror,
        mode = "3840x2160@30",
        -- Hyprland's mirror target must be a connector name, not a desc selector.
        mirror = gsa_laptop_output,
        scale = 1,
      },
    },
    workspaces = split_workspaces(gsa_ultrawide, gsa_laptop),
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
  local descriptions = connected_monitor_descriptions()

  -- Select dock layouts by EDID, independent of volatile connector names.
  if hostname == "GSA-AXA89M" then
    local has_ultrawide =
      descriptions["LG Electronics LG ULTRAWIDE 404NTMXBJ251"]
      or connected_drm_edid_contains("404NTMXBJ251")
    if has_ultrawide then
      local ultrawide = monitor_for_description(
        "LG Electronics LG ULTRAWIDE 404NTMXBJ251"
      )
      local mode = "3440x1440@72"
      local position = "0x-1440"

      -- The alternate HDMI path exposes a 16:9 preferred mode, which leaves
      -- part of the ultrawide panel unused. Use its advertised 64:27 mode.
      if ultrawide and ultrawide.physical_width < 800 then
        mode = "2560x1080@60"
        position = "0x-1080"
      end

      layouts.high_res_laptop_with_ultrawide.monitors[2].mode = mode
      layouts.high_res_laptop_with_ultrawide.monitors[2].position = position
      layouts.high_res_laptop_with_ultrawide_and_mirror.monitors[2].mode = mode
      layouts.high_res_laptop_with_ultrawide_and_mirror.monitors[2].position =
        position
    end
    local mirror_output, mirror_mode = connected_mirror()
    local has_mirror = mirror_output ~= nil
    if has_mirror then
      -- Mirroring requires connector names on both sides of the relationship.
      layouts.high_res_laptop_with_mirror.monitors[2].output = mirror_output
      layouts.high_res_laptop_with_mirror.monitors[2].mode = mirror_mode
      layouts.high_res_laptop_with_ultrawide_and_mirror.monitors[3].output =
        mirror_output
      layouts.high_res_laptop_with_ultrawide_and_mirror.monitors[3].mode =
        mirror_mode
    end
    if has_ultrawide and has_mirror then
      return layouts.high_res_laptop_with_ultrawide_and_mirror
    elseif has_ultrawide then
      return layouts.high_res_laptop_with_ultrawide
    elseif has_mirror then
      return layouts.high_res_laptop_with_mirror
    end
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
