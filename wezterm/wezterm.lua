-- References: https://github.com/KevinSilvester/wezterm-config/blob/master/config/bindings.lua

-- Pull in the wezterm API
local platform = require("utils.platform")()
local balance = require("utils.balancepane")
local key = require("utils.key")
local wezterm = require("wezterm")
local helper = require("utils.helper")
local mux = wezterm.mux
local act = wezterm.action

local function basename(s)
  return string.match(string.gsub(s, '(.*[/\\])(.*)', '%2'), "[a-zA-Z0-9_-]+")
end

local function table_length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function remove_exe(s)
  local temp = string.gmatch(s, "%.")
  for i in temp do
    print(i)
  end
end

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
config.color_schemes = { ["Vs Code Dark+ (Gogh)"] = scheme }
config.color_scheme = "Vs Code Dark+ (Gogh)"

-- UI
config.disable_default_key_bindings = true
config.enable_scroll_bar = true
config.adjust_window_size_when_changing_font_size = false
config.hide_mouse_cursor_when_typing = true
config.hide_tab_bar_if_only_one_tab = false
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
  window:toast_notification('wezterm', 'Wezterm Start.', nil, 4000)
end)

wezterm.on('window-config-reloaded', function(window, pane)
  window:toast_notification('wezterm', 'Configuration Reloaded!', nil, 4000)
end)

-- Tab bar
-- https://github.com/theopn/dotfiles/blob/25b85936ef3e7195a0f029525f854fdb915b9f90/wezterm/wezterm.lua
config.use_fancy_tab_bar = false
config.status_update_interval = 500
wezterm.on("update-right-status", function(window, pane)
  -- Workspace name
  local stat = window:active_workspace()
  -- It's a little silly to have workspace name all the time
  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then stat = window:active_key_table() end
  if window:leader_is_active() then stat = "LDR" end
  -- Current process
  -- local process = basename(pane:get_foreground_process_name())
  local process = pane:get_foreground_process_info().executable
  if string.find(process, "nvim") then
    process = "nvim"
  end
  -- Number of panes in current tab
  local panes_n = table_length(window:active_tab():panes_with_info())
  local pane_str = "pane"
  if panes_n > 1 then
    pane_str = "panes"
  end
  -- Time
  local time = wezterm.strftime("%H:%M")

  window:set_right_status(wezterm.format({
    { Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
    { Text = " | " },
    { Text = wezterm.nerdfonts.cod_layout .. " " .. panes_n .. " " .. pane_str },
    { Text = " | " },
    { Foreground = { Color = "#FFB86C" } },
    { Text = wezterm.nerdfonts.fa_code .. "  " .. process },
    "ResetAttributes",
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
    { Text = " |" },
  }))
end)
return config
