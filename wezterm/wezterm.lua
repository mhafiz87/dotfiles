-- References: https://github.com/KevinSilvester/wezterm-config/blob/master/config/bindings.lua
-- Pull in the wezterm API
local platform = require("utils.platform")
local key = require("utils.key")
local wezterm = require("wezterm")
local helper = require("utils.helper")
local ws = require("utils.workspaces")
local mux = wezterm.mux
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

if not platform.is_windows() then
  config.default_cwd = "~"
end

if platform.is_windows() then
  config.default_cwd = os.getenv("userprofile")
  config.default_prog = { "pwsh", "-l" }
else
  config.default_cwd = os.getenv("HOME")
  config.default_prog = { "bash" }
end

config.automatically_reload_config = true
config.canonicalize_pasted_newlines = "CarriageReturn"

-- Themes
-- Override scrollbar thumb color
local theme = "Rosé Pine (base16)"
-- local theme = "rose-pine"
local scheme = wezterm.get_builtin_color_schemes()[theme]
scheme.scrollbar_thumb = "#ffffff"
config.color_schemes = { [theme] = scheme }
config.color_scheme = theme

-- UI
config.adjust_window_size_when_changing_font_size = false
config.disable_default_key_bindings = true
config.enable_scroll_bar = true
config.front_end = "OpenGL"
config.hide_mouse_cursor_when_typing = true
config.hide_tab_bar_if_only_one_tab = false
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.50 }
config.min_scroll_bar_height = "2cell"
config.tab_max_width = 25
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 5,
  right = 15,
  top = 10,
  bottom = 10,
}

-- Cursor
config.animation_fps = 60
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.default_cursor_style = "BlinkingBlock"

-- Font Settings
config.font_dirs = { 'fonts' }
config.font = wezterm.font_with_fallback({
    { family = "Cascadia Code NF", harfbuzz_features= { "ss01" } },
    { family = "JetBrainsMono Nerd Font", harfbuzz_features= { "ss01" }  },
    { family = "FiraCode Nerd Font", harfbuzz_features= { "ss01" }  },
    { family = "MesloLGS NF" },
    { family = "DejaVuSansM Nerd Font" },
    { family = "Noto Color Emoji" }
})
config.font_size = 10

-- Keybindings
config.leader = key.leader
config.keys = key.keys
config.key_tables = key.key_tables

-- Tab bar
-- https://github.com/theopn/dotfiles/blob/25b85936ef3e7195a0f029525f854fdb915b9f90/wezterm/wezterm.lua
config.use_fancy_tab_bar = true
config.status_update_interval = 500
config.window_frame = {
  active_titlebar_bg = "rgba(0, 0, 0, 0)",
  -- font = wezterm.font({ family = "JetBrainsMono Nerd Font" }),
  font_size = 10
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

-- To support SSH into linux, modify /etc/ssh/sshd_config
-- find `AcceptEnv` or add it, then modify
-- AcceptEnv LANG LC_* WSLENV WEZTERM_* TERM TERM_PROGRAM TERM_PROGRAM_VERSION COLORTERM
-- sudo systemctl restart sshd
-- SSH Domains
config.ssh_domains = {
  -- cmd: wezterm connect auto-01 &
  {
    name = "auto-01",
    remote_address = "ds4-auto-orbital-01",
    username = "autouser",
    default_prog = { "bash" },
    assume_shell = "Posix",
  },
  -- cmd: wezterm connect system-01 &
  {
    name = "system-01",
    remote_address = "ds4-system-orbital-01",
    username = "systemuser",
    ssh_option = {
      identityfile = "C:/Users/5004124381/.ssh/ds4-orbital-auto-1",
    },
    default_prog = { "bash" },
    assume_shell = "Posix",
  },
}

config.unix_domains = {
  {
    name = "unix",
  },
}

wezterm.on("gui-startup", function(cmd)
  local args = {}
  if cmd then
    args = cmd.args
  end

  if platform.is_windows() then
    temp = { "pwsh", "-l" }
    for key, value in ipairs(temp) do
      table.insert(args, value)
    end
  end

  -- -- local tab, pane, window = mux.spawn_window {
  -- --   workspace = "awake",
  -- --   cwd = config.default_cwd
  -- -- }
  -- -- mux.set_active_workspace("awake")
  -- -- pane:send_text("clear\rkeep-awake\r")

  local tab, pane, window = mux.spawn_window {
    workspace = "home",
    cwd = config.default_cwd,
    args = args,
  }

  -- mux.set_active_workspace "home"
  -- -- if platform.is_windows() then
  -- --   pane:send_text("clear\r")
  -- -- end
  window:gui_window():maximize()

end)

wezterm.on("gui-attached", function()
end)

wezterm.on('window-config-reloaded', function(window, pane)
  window:toast_notification('wezterm', 'configuration reloaded!', nil, 1000)
end)

local battery_index = 0
local battery_level = {
  wezterm.nerdfonts.md_battery_outline .. " ",
  wezterm.nerdfonts.md_battery_low .. " ",
  wezterm.nerdfonts.md_battery_medium .. " ",
  wezterm.nerdfonts.md_battery_high .. " "
}

wezterm.on("update-right-status", function(window, pane)
--   -- Workspace name
  local tab = window:active_tab()
  local workspace = window:active_workspace()
  -- It's a little silly to have workspace name all the time
  -- Utilize this to display LDR or current key table name
  local stat = ""
  if window:active_key_table() then stat = window:active_key_table() end
  if window:leader_is_active() then stat = "LDR" end

  -- Current process
  -- local process = helper.basename(pane:get_foreground_process_name())
  local process = ""
  local process_name = ""
  process = pane:get_foreground_process_info()
  -- wezterm.log_info(process)
  if process ~= nil then
    process_name = process.name
    if string.find(process_name, "nvim") then
      process_name = "nvim"
    end
  end

  -- Domain
  local domain_name = pane:get_domain_name()
  -- wezterm.log_info("Current domain: " .. domain_name)

  -- Number of panes in current tab
  local panes_n = #window:active_tab():panes_with_info()
  local pane_str = "pane"
  if panes_n > 1 then
    pane_str = "panes"
  end

  -- Battery
  local bat = ''
  local bat_color = "rgba(0, 0, 0, 0)"
  local battery_status = ' 🔋'
  for _, b in ipairs(wezterm.battery_info()) do
    if b.state == "Full" then
      battery_index = 4
      battery_status = battery_level[battery_index]
    elseif b.state == "Charging" then
      battery_index = battery_index + 1
      if battery_index > 4 then battery_index = 1 end
      battery_status = battery_level[battery_index]
    elseif b.state == "Discharging" then
      battery_index = battery_index - 1
      if battery_index < 1 then battery_index = 4 end
      battery_status = battery_level[battery_index]
    end
    bat = battery_status .. string.format('%.0f%%', b.state_of_charge * 100)
    if b.state == "Charging" then
      bat_color = "rgba(98, 219, 87, 1)"
    elseif b.state == "Discharging" then
      bat_color = "rgba(235, 111, 146, 1)"
    elseif b.state == "Full" then
      bat_color = "rgba(255, 184, 108, 1)"
    elseif b.state == "Unknown" then
      bat_color = "rgba(0, 0, 0, 1)"
    end
  end

  -- Time
  local time = wezterm.strftime("%H:%M")

  local right_status_data = {
    -- current workspace
    { Background = { Color = "rgba(0, 0, 0, 0)" } },
    { Text = wezterm.nerdfonts.oct_table .. "  " .. workspace },
    { Text = " | " },
    -- number of panes
    { Text = wezterm.nerdfonts.cod_layout .. " " .. panes_n .. " " .. pane_str },
    { Text = " | " },
    -- current process
    { Foreground = { Color = "rgba(255, 184, 108, 0)" } },
    { Text = wezterm.nerdfonts.md_application_settings_outline .. "   " .. process_name },
    "ResetAttributes",
    { Background = { Color = "rgba(0, 0, 0, 0)" } },
    { Text = " | " },
    -- current domain
    { Foreground = { Color = "rgba(98, 219, 87, 1)" } },
    { Text = wezterm.nerdfonts.cod_multiple_windows .. "  " .. domain_name },
    "ResetAttributes",
    { Background = { Color = "rgba(0, 0, 0, 0)" } },
    { Text = " | " },
    -- current battery
    { Foreground = { Color = bat_color } },
    { Text = bat },
    "ResetAttributes",
    -- current time
    { Background = { Color = "rgba(0, 0, 0, 0)" } },
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
    { Text = " |" },
  }

  if stat ~= ""  then
    table.insert(right_status_data, 1, "ResetAttributes")
    table.insert(right_status_data, 1, { Text = " | " })
    table.insert(right_status_data, 1, { Text = stat })
    table.insert(right_status_data, 1, { Foreground = { Color = "rgba(235, 111, 146, 0)" } })
    table.insert(right_status_data, 1, { Background = { Color = "rgba(0, 0, 0, 0)" } })
  end

  window:set_right_status(wezterm.format(right_status_data))
end)

return config
