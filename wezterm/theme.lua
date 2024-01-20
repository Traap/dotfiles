local wezterm = require 'wezterm'

local sync_with_system = true

local dark_theme = ({
   'astromouse (terminal.sexy)', -- [1],
   'Catppuccin Frappe', -- [2]
   'rose-pine', -- [3], not working yet
   'Rosé Pine (base16)', -- [4]
   'WildCherry', -- [5]
   'nord', -- [6]
   'Builtin Pastel Dark', -- [7]
   'Brogrammer (base16)', -- [8]
   'City Streets (terminal.sexy)', -- [9]
   'Catppuccin Mocha', -- [10]
})[10]

local light_theme = ({
   'Catppuccin Latte', -- [1]
})[1]

local function scheme_for_appearance(appearance)
   -- if appearance:find 'Dark' then
      return dark_theme
   -- end

   -- return light_theme
end

if sync_with_system then
   wezterm.on('window-config-reloaded', function(window)
      local overrides = window:get_config_overrides() or {}
      local appearance = window:get_appearance()
      local scheme = scheme_for_appearance(appearance)
      if overrides.color_scheme ~= scheme then
         overrides.color_scheme = scheme
         window:set_config_overrides(overrides)
      end
   end)
end

return {
   color_scheme = dark_theme
}
