-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.enable_tab_bar = false

config.color_scheme = "Tartan (terminal.sexy)"

config.window_frame = {

	font = wezterm.font({ family = "JetBrainsMono NF" }),
	font_size = 12.0,
}

config.window_padding = {
	left = 20,
	right = 20,
	top = 20,
	bottom = 20,
}

-- and finally, return the configuration to wezterm
return config
