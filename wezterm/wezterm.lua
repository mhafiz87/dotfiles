-- References: https://github.com/KevinSilvester/wezterm-config/blob/master/config/bindings.lua

-- Pull in the wezterm API
local platform = require("utils.platform")()
local balance = require("utils.balancepane")
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
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	{ key = "p", mods = "LEADER|CTRL|SHIFT", action = act.ActivateCommandPalette },
	{ key = "F11", mods = "LEADER", action = act.ToggleFullScreen },

	-- Fonts
	{
		key = "f",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_font",
			one_shot = false,
			timeout_milliseconds = 1000,
		}),
	},

	-- Copy Paste
	{ key = "x", mods = "LEADER|CTRL|SHIFT", action = act.ActivateCopyMode },
	{ key = "c", mods = "LEADER|CTRL|SHIFT", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "LEADER|CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

	-- Tab
	{ key = "l", mods = "LEADER|SHIFT", action = act.ActivateTabRelative(1) },
	{ key = "h", mods = "LEADER|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "t", mods = "LEADER|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
	{
		key = "1",
		mods = "LEADER|CTRL",
		action = act.SpawnCommandInNewTab({
			args = { "pwsh", "-l" },
			cwd = config.default_cwd,
		}),
	},
	{
		key = "2",
		mods = "LEADER|CTRL",
		action = act.SpawnCommandInNewTab({
			args = { "cmd", "-l" },
			cwd = config.default_cwd,
		}),
	},
	{ key = "w", mods = "LEADER|CTRL", action = act.CloseCurrentTab({ confirm = true }) },

	-- Search
	{ key = "f", mods = "LEADER|CTRL|SHIFT", action = act.Search({ CaseInSensitiveString = "" }) },

	-- Pane
	{ key = "f", mods = "LEADER|ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER|ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "w", mods = "LEADER|ALT", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "k", mods = "LEADER|ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER|ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "h", mods = "LEADER|ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER|ALT", action = act.ActivatePaneDirection("Right") },

	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
			timeout_milliseconds = 1000,
		}),
	},

	-- Hyperlink
	{
		key = "u",
		mods = "LEADER",
		action = wezterm.action.QuickSelectArgs({
			label = "open url",
			patterns = {
				"https?://\\S+",
			},
			action = wezterm.action_callback(function(window, pane)
				local url = window:get_selection_text_for_pane(pane)
				wezterm.log_info("opening: " .. url)
				wezterm.open_with(url)
			end),
		}),
	},
}

-- Key Tables
config.key_tables = {
	resize_font = {
		{ key = "=", action = act.IncreaseFontSize },
		{ key = "-", action = act.DecreaseFontSize },
		{ key = "Backspace", action = act.ResetFontSize },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
	},
	resize_pane = {
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{
			key = "b",
			action = wezterm.action.Multiple({
				wezterm.action_callback(balance.balance_panes("x")),
				wezterm.action_callback(balance.balance_panes("y")),
			}),
		},
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
	},
}

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

-- and finally, return the configuration to wezterm
return config
