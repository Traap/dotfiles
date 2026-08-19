-- Apply the selected monitor profile and keep DarkKnight layout stable.

local monitor_profile = require("hypr.monitor_profile")

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

local hostname = monitor_profile.detected_hostname()
local selected = monitor_profile.current_layout()

-- Monitor rules and workspace affinity come from the same selected profile.
apply_layout(selected.monitors, selected.workspaces)

if hostname == "GSA-AXA89M" then
  local function apply_mirror(monitor)
    local script = os.getenv("HOME")
      .. "/.config/hypr/scripts/apply-gsa-mirror"
    hl.exec_cmd(
      script
        .. " "
        .. monitor.output
        .. " "
        .. monitor.mode
        .. " "
        .. monitor.mirror
    )
  end

  for _, monitor in ipairs(selected.monitors) do
    if monitor.mirror then
      apply_mirror(monitor)

      -- Dock initialization can reconfigure the output after the first
      -- mirror command. The script is idempotent, so layout events repair a
      -- cleared relationship without reacting forever to their own change.
      hl.on("monitor.layout_changed", function()
        apply_mirror(monitor)
      end)
    end
  end

  hl.on("monitor.added", function()
    hl.exec_cmd("hyprctl reload")
  end)
elseif hostname == "DarkKnight" then
  local function ultra_gear_layout_is_applied()
    local monitors = hl.get_monitors()
    local full_width_output =
      monitor_profile.find_ultra_gear_full_width_output()

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
