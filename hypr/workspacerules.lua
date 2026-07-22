local vars = require("hypr.vars")

hl.workspace_rule({ workspace = "1", on_created_empty = vars.file_manager })
hl.workspace_rule({ workspace = "2", on_created_empty = 'omarchy-launch-or-focus-webapp Email "https://app.hey.com"' })
hl.workspace_rule({ workspace = "3", on_created_empty = vars.office })
hl.workspace_rule({ workspace = "4", on_created_empty = vars.terminal .. " -e btop" })
hl.workspace_rule({ workspace = "6", on_created_empty = vars.bin_home .. "/toggler Zero" })
hl.workspace_rule({ workspace = "8", on_created_empty = vars.browser .. " --new-window https://www.github.com/Traap/" })
hl.workspace_rule({
  workspace = "9",
  on_created_empty = 'omarchy-launch-webapp "https://www.kingjamesbibleonline.org"',
})
hl.workspace_rule({ workspace = "10", on_created_empty = 'omarchy-launch-webapp "https://chatgpt.com"' })

-- Microsoft workspaces.
hl.workspace_rule({ workspace = "5", on_created_empty = "code-insiders" })
hl.workspace_rule({ workspace = "7", on_created_empty = 'omarchy-launch-webapp "https://teams.microsoft.com/v2/"' })
