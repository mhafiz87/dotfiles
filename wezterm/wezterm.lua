-- References: https://github.com/KevinSilvester/wezterm-config/blob/master/config/bindings.lua

-- Pull in the wezterm API
local platform = require("utils.platform")()
local key = require("utils.key")
local wezterm = require("wezterm")
local helper = require("utils.helper")
local ws = require("utils.workspaces")
local mux = wezterm.mux
local act = wezterm.action

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
config.canonicalize_pasted_newlines = "CarriageReturn"

-- Themes
-- Override scrollbar thumb color
-- local theme = "Monokai Remastered"
local theme = "rose-pine"
local scheme = wezterm.get_builtin_color_schemes()[theme]
scheme.scrollbar_thumb = "#ffffff"
config.color_schemes = { [theme] = scheme }
config.color_scheme = theme

-- UI
config.front_end = "OpenGL"
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
config.window_decorations = "RESIZE"

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
  local args = {}
  if cmd then
    args = cmd.args
  end

  if platform.is_win then
    temp = { "pwsh", "-l" }
    for key, value in ipairs(temp) do
      table.insert(args, value)
    end
  end
  -- local tab, pane, window = mux.spawn_window {
  --   workspace = "awake",
  --   cwd = config.default_cwd
  -- }
  -- mux.set_active_workspace("awake")
  -- pane:send_text("clear\rkeep-awake\r")
  local tab, pane, window = mux.spawn_window {
    workspace = "home",
    cwd = config.default_cwd,
    args = args,
  }
  mux.set_active_workspace "home"
  -- if platform.is_win then
  --   pane:send_text("clear\r")
  -- end
  window:gui_window():maximize()
end)

wezterm.on("gui-attached", function()
end)

wezterm.on('window-config-reloaded', function(window, pane)
end)

-- Tab bar
-- https://github.com/theopn/dotfiles/blob/25b85936ef3e7195a0f029525f854fdb915b9f90/wezterm/wezterm.lua
config.use_fancy_tab_bar = true
config.status_update_interval = 500
config.window_frame = {
  active_titlebar_bg = "rgba(0, 0, 0, 0)"
}
wezterm.on("update-right-status", function(window, pane)
  -- Workspace name
  local tab = window:active_tab()
  local stat = window:active_workspace()
  -- It's a little silly to have workspace name all the time
  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then stat = window:active_key_table() end
  if window:leader_is_active() then stat = "LDR" end
  -- Current process
  -- local process = helper.basename(pane:get_foreground_process_name())
  local process = pane:get_foreground_process_info().executable
  if string.find(process, "nvim") then
    process = "nvim"
  end
  -- Number of panes in current tab
  local panes_n = helper.table_length(window:active_tab():panes_with_info())
  local pane_str = "pane"
  if panes_n > 1 then
    pane_str = "panes"
  end
  -- Time
  local time = wezterm.strftime("%H:%M")

  window:set_right_status(wezterm.format({
    { Background = { Color = "rgba(0, 0, 0, 0)" } },
    { Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
    { Text = " | " },
    { Text = wezterm.nerdfonts.cod_layout .. " " .. panes_n .. " " .. pane_str },
    { Text = " | " },
    { Foreground = { Color = "rgba(255, 184, 108, 0)" } },
    { Text = wezterm.nerdfonts.fa_code .. "  " .. process },
    "ResetAttributes",
    { Background = { Color = "rgba(0, 0, 0, 0)" } },
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
    { Text = " |" },
  }))
end)
return config
