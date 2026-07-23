local vars = require("hypr.vars")

local launch_on_empty = {
  ["1"] = vars.file_manager,
  ["2"] = 'omarchy-launch-or-focus-webapp Email "https://app.hey.com"',
  ["3"] = vars.office,
  ["4"] = vars.terminal .. " -e btop",
  ["5"] = "code-insiders",
  ["6"] = vars.bin_home .. "/toggler Zero",
  ["7"] = 'omarchy-launch-webapp "https://teams.microsoft.com/v2/"',
  ["8"] = vars.browser .. " --new-window https://www.github.com/Traap/",
  ["9"] = 'omarchy-launch-webapp "https://www.kingjamesbibleonline.org"',
  ["10"] = 'omarchy-launch-webapp "https://chatgpt.com"',
}

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

  launch_pending[id] = true
  hl.exec_cmd(command)
  hl.timer(function()
    launch_pending[id] = nil
  end, { timeout = 3000, type = "oneshot" })
end

hl.on("hyprland.start", launch_active_workspace_if_empty)
hl.on("workspace.active", launch_active_workspace_if_empty)
