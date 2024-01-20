local wezterm = require 'wezterm'

local font_size = 12
local bold = true
local font_family = ({
       'JetBrainsMono Nerd Font',
       'JetBrainsMono Nerd Font',
       'JetBrainsMono Nerd Font',
       'JetBrainsMono Nerd Font',
       'JetBrainsMono Nerd Font',
       'JetBrainsMono Nerd Font',
       'JetBrainsMono Nerd Font',
       'JetBrainsMono Nerd Font',
       'JetBrainsMono Nerd Font',
       'JetBrainsMono Nerd Font',
    })[10]

local options = {}
if bold then
   options['weight'] = 'Bold'
end

local font = wezterm.font(font_family, options)

return {
   font      = font,
   font_size = font_size,
}
