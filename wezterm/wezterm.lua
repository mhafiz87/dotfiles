-- References: https://github.com/KevinSilvester/wezterm-config/blob/master/config/bindings.lua

-- Pull in the wezterm API
local platform = require("utils.platform")()
local balance = require("utils.balancepane")
local key = require("utils.key")
local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

if not platform.is_win then
	config.default_cwd = "~"
end

if platform.is_win then
	config.default_cwd = os.getenv("userprofile")
	config.default_prog = { "pwsh", "-l" }
end

config.automatically_reload_config = true

-- Themes
-- Override scrollbar thumb color
local scheme = wezterm.get_builtin_color_schemes()["Vs Code Dark+ (Gogh)"]
scheme.scrollbar_thumb = "#ffffff"
config.color_schemes = {["Vs Code Dark+ (Gogh)"] = scheme}
config.color_scheme = "Vs Code Dark+ (Gogh)"

-- UI
config.disable_default_key_bindings = true
config.enable_scroll_bar = true
config.adjust_window_size_when_changing_font_size = false
config.hide_mouse_cursor_when_typing = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 25
config.window_padding = {
	left = 5,
	right = 15,
	top = 10,
	bottom = 10,
}
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.50 }
config.min_scroll_bar_height = "2cell"

-- Cursor
config.animation_fps = 60
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.default_cursor_style = "BlinkingBlock"

-- Font Settings
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font" },
})
config.font_size = 10

-- Keybindings
config.leader = key.leader
config.keys = key.keys
config.key_tables = key.key_tables

-- Mouse Bindings
config.mouse_bindings = {
	-- Hyperlink
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

wezterm.on('update-right-status', function(window, pane)
  local process_info = pane:get_foreground_process_info()
  if string.find(process_info.executable, "nvim") then
    window:set_right_status("nvim")
  else
    window:set_right_status(basename(process_info.name))
  end
end)

return config
