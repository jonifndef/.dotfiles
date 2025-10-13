local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font_size = 13
config.font = wezterm.font 'Hack Nerd Font'
config.color_scheme = 'GruvboxDarkHard'

config.enable_tab_bar = false

config.window_padding = {
    left = 15,
    right = 15,
    top = 15,
    bottom = 15
}

config.window_background_opacity = 0.55

config.colors = {
    background = '#000000'
}

return config
