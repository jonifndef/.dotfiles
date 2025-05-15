local wezterm = require 'wezterm'

local config = wezterm.config_builder()

--config.initial_cols = 120
--config.initial_rows = 28

config.font_size = 13
config.font = wezterm.font 'Hack'
config.color_scheme = 'GruvboxDarkHard'

config.enable_tab_bar = false

config.window_padding = {
    left = 15,
    right = 15,
    top = 15,
    bottom = 15
}

return config
