local use_background_image = true

local padding = 0
local window_padding = {
  left = padding,
  right = padding,
  top = padding,
  bottom = padding,
}

local M = {
  integrated_title_button_alignment = "Right",
  integrated_title_button_color = "Auto",
  integrated_title_button_style = "Windows",
  window_decorations = "TITLE|RESIZE",
  window_padding = window_padding,

  window_background_image_hsb = {
    brightness = 0.3
  },
  adjust_window_size_when_changing_font_size = false
}

if use_background_image then
  M.window_background_image = 'background.png'
end

return M
