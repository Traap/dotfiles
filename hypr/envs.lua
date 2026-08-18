-- Set personal environment overrides before the rest of Hyprland starts.

hl.env("XCURSOR_SIZE", "24")

-- Hyprland does not inherit variables exported by interactive Bash startup
-- files. Define this in the compositor environment for launched processes.
local home = os.getenv("HOME")
if home then
  hl.env("SESSION_BINDINGS_HOME", home .. "/.config/session_bindings")
end
