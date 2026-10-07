-- Override global and tagged window rules after Omarchy defaults load.

o.window(".*", { opacity = "1.00 override 1.00 override" })

-- Make the Grok terminal window slightly transparent.
o.window(
  { class = "^com\\.mitchellh\\.ghostty$", title = ".*Grok.*" },
  { opacity = "0.80 override 0.80 override 1.00 override" }
)

-- Increase Omarchy's default floating-window size.
o.window({ tag = "floating-window" }, { size = { 1094, 750 } })
