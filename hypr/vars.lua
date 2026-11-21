-- Shared command and path defaults for personal Hyprland modules.

local hypr_dir = "~/.config/hypr"

return {
  bin_home = "~/git/dotfiles/bash/bin",
  browser = "chromium",
  editor = os.getenv("EDITOR") or "nvim",
  file_manager = "folio",
  hypr_dir = hypr_dir,
  local_bin = "~/.local/bin",
  office = "libreoffice",
  terminal = os.getenv("TERMINAL") or "foot",
  webapp = "omarchy-launch-webapp",
  edge_webapp = hypr_dir .. "/scripts/omarchy-launch-edge-webapp",
  password_manager = "1password",
}
