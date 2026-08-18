-- Keep workspaces persistent and launch preferred apps on empty activation.

local vars = require("hypr.vars")
local monitor_profile = require("hypr.monitor_profile")

local default_launch_on_empty = {
  ["1"] = 'omarchy-launch-or-focus-webapp Email "https://app.hey.com"',
  ["2"] = vars.file_manager,
  ["3"] = vars.office,
  ["4"] = vars.terminal .. " -e btop",
  ["5"] = "code-insiders",
  ["6"] = vars.bin_home .. "/toggler Zero",
  ["7"] = {
    vars.browser .. " --new-window https://teams.microsoft.com/v2/",
    vars.browser .. " --new-window https://owa.ventura.org",
  },
  ["8"] = vars.browser .. " --new-window https://www.github.com/Traap/",
  ["9"] = 'omarchy-launch-webapp "https://www.kingjamesbibleonline.org"',
  ["10"] = 'omarchy-launch-webapp "https://chatgpt.com"',
}

-- Customize these commands for GSA-AXA89M without changing other hosts.
local gsa_axa89m_launch_on_empty = {
  ["1"] = {
    vars.browser .. " --new-window https://teams.microsoft.com/v2/",
    vars.browser .. " --new-window https://owa.ventura.org",
  },
  ["2"] = vars.file_manager,
  ["3"] = 'omarchy-launch-or-focus-webapp Email "https://app.hey.com"',
  ["4"] = vars.terminal .. " -e btop",
  ["5"] = {
    "code-insiders",
    vars.browser .. " --new-window http://localhost:3001",
  },
  ["6"] = vars.bin_home .. "/toggler Paperboy",
  ["7"] = vars.bin_home .. "/toggler Work",
  ["8"] = vars.browser .. " --new-window https://www.github.com/Traap/",
  ["9"] = 'omarchy-launch-webapp "https://www.kingjamesbibleonline.org"',
  ["10"] = 'omarchy-launch-webapp "https://chatgpt.com"',
}

local launch_on_empty = default_launch_on_empty
if monitor_profile.detected_hostname() == "GSA-AXA89M" then
  launch_on_empty = gsa_axa89m_launch_on_empty
end

local function workspace_rule(spec)
  spec.persistent = true
  hl.workspace_rule(spec)
end

for workspace = 1, 10 do
  workspace_rule({ workspace = tostring(workspace) })
end

local launch_pending = {}

local function launch_active_workspace_if_empty()
  local workspace = hl.get_active_workspace()
  if not workspace or not workspace.is_empty then
    return
  end

  local id = tostring(workspace.id)
  local command = launch_on_empty[id]
  if not command or launch_pending[id] then
    return
  end

  -- Debounce launches while Hyprland is still reporting an empty workspace.
  launch_pending[id] = true
  if type(command) == "table" then
    for _, cmd in ipairs(command) do
      hl.exec_cmd(cmd)
    end
  else
    hl.exec_cmd(command)
  end
  hl.timer(function()
    launch_pending[id] = nil
  end, { timeout = 3000, type = "oneshot" })
end

hl.on("hyprland.start", launch_active_workspace_if_empty)
hl.on("workspace.active", launch_active_workspace_if_empty)
