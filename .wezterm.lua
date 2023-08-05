local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.default_cursor_style = "SteadyBar"
config.enable_scroll_bar = true
config.macos_window_background_blur = 14
config.window_background_opacity = 0.85

config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false

config.cursor_blink_rate = 500

config.line_height = 1.4
config.font = wezterm.font {
    family = "FiraCode Nerd Font Mono",
}
config.font_size = 16

return config
