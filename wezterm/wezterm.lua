local wezterm = require("wezterm")
local theme = wezterm.plugin.require("https://github.com/neapsix/wezterm").moon
local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")

-- Create config table
local config = {}

-- ======================
-- Your normal settings
-- ======================

config.default_prog = { "/usr/bin/fish" }
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = 650 })
config.font_size = 13
config.line_height = 1.2
config.colors = theme.colors()
config.window_background_opacity = 0.90
config.enable_kitty_graphics = true
config.disable_default_key_bindings = false
config.use_fancy_tab_bar = false
config.kde_window_background_blur = true
config.warn_about_missing_glyphs = false
config.keys = {
	{ key = "Enter", mods = "SHIFT", action = wezterm.action.ActivateCopyMode },
}
config.front_end = "OpenGL" -- nebo "OpenGL"
config.enable_wayland = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false

modal.apply_to_config(config)
modal.set_default_keys(config)

-- Return final config
config.color_scheme = "Noctalia"
return config
