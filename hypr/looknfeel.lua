hl.config({
  animations = {
    enabled = true,
  },

  cursor = {
    hide_on_key_press = true,
  },

  decoration = {
    active_opacity = 0.80,
    inactive_opacity = 0.80,

    blur = {
      enabled = true,
      size = 3,
      passes = 1,
    },
  },

  dwindle = {
    preserve_split = true,
    force_split = 2,
  },

  general = {
    allow_tearing = false,
    border_size = 2,
    col = {
      active_border = { colors = { "rgba(eb6f92ff)", "rgba(c4a7e7ff)" }, angle = 45 },
      inactive_border = { colors = { "rgba(31748fcc)", "rgba(9ccfd8cc)" }, angle = 45 },
    },
    gaps_in = 2,
    gaps_out = 2,
    layout = "dwindle",
    resize_on_border = true,
  },

  master = {
    new_status = "slave",
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    focus_on_activate = false,
    force_default_wallpaper = -1,
  },
})

hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = false, speed = .05, bezier = "wind" })

hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})
