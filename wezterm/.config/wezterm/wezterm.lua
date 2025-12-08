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
config.keys = {
  { key = '+', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
  { key = '=', mods = 'CTRL', action = wezterm.action.ResetFontSize },
  { key = 'Escape', mods = 'SHIFT|ALT', action = wezterm.action.ActivateCopyMode },
}

config.scrollback_lines = 10000

return config
