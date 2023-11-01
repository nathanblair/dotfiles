local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.audible_bell = "Disabled"
config.default_cursor_style = "SteadyBar"
config.enable_scroll_bar = true
config.macos_window_background_blur = 18
config.window_background_opacity = 0.65

config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false

config.cursor_blink_rate = 500

config.line_height = 1.4
config.font = wezterm.font {
    family = "FiraCode Nerd Font Mono",
}
config.font_size = 16

return config
