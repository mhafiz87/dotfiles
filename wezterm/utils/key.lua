local wezterm = require("wezterm")
local balance = require("utils.balancepane")
local config = wezterm.config_builder()
local act = wezterm.action

-- https://github.com/letieu/dotfiles/blob/master/dot_config/wezterm/key.lua

local function is_vim(pane)
  local process_info = pane:get_foreground_process_info()
  local process_name = ""
  if string.find(process_info.executable, "nvim") then
    process_name = "nvim"
  else
    process_name = process_info.name
  end
  return process_name == "nvim"
end

local function find_vim_pane(tab)
  for _, pane in ipairs(tab:panes()) do
    if is_vim(pane) then
      return pane
    end
  end
end

local function TableConcat(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

local M = {}

local keys_wezterm = {
}

local keys_default = {
  { key = "p",   mods = "LEADER|CTRL|SHIFT", action = act.ActivateCommandPalette },
  { key = "F11", mods = "LEADER",            action = act.ToggleFullScreen },

  -- Search
  { key = "f",   mods = "LEADER|CTRL|SHIFT", action = act.Search({ CaseInSensitiveString = "" }) },

  -- Toggle zoom state
  { key = "z",   mods = "LEADER|CTRL",       action = act.TogglePaneZoomState },

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
  { key = "x",   mods = "LEADER|CTRL|SHIFT", action = act.ActivateCopyMode },
  { key = "c",   mods = "LEADER|CTRL|SHIFT", action = act.CopyTo("Clipboard") },
  { key = "v",   mods = "LEADER|CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

  -- Tab
  { key = "Tab", mods = "CTRL",              action = act.ActivateTabRelative(1) },
  { key = "Tab", mods = "CTRL|SHIFT",        action = act.ActivateTabRelative(-1) },
  { key = "t",   mods = "LEADER|CTRL",       action = act.SpawnTab("CurrentPaneDomain") },
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

  -- Pane
  { key = "f", mods = "LEADER|ALT",  action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "v", mods = "LEADER|ALT",  action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "w", mods = "LEADER|ALT",  action = act.CloseCurrentPane({ confirm = true }) },
  { key = "k", mods = "LEADER|ALT",  action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "LEADER|ALT",  action = act.ActivatePaneDirection("Down") },
  { key = "h", mods = "LEADER|ALT",  action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER|ALT",  action = act.ActivatePaneDirection("Right") },
  {
    key = "p",
    mods = "LEADER",
    action = act.ActivateKeyTable({
      name = "resize_pane",
      one_shot = false,
      timeout_milliseconds = 1000,
    }),
  },

  -- Workspace
  { key = "w", mods = "LEADER", action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },

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
  -- Toggle Zoom For Neovim
  -- {
  -- key = ";",
  -- mods = "CTRL",
  -- action = wezterm.action_callback(function(window, pane)
  -- 	local tab = window:active_tab()
  --
  -- 	-- Open pane below if current pane is vim
  -- 	if is_vim(pane) then
  -- 		if (#tab:panes()) == 1 then
  -- 			-- Open pane right if when there is only one pane and it is vim
  -- 			pane:split({ direction = "Right" })
  -- 		else
  -- 			-- Send `CTRL-; to vim`, navigate to bottom pane from vim
  -- 			window:perform_action({
  -- 				SendKey = { key = ";", mods = "CTRL" },
  -- 			}, pane)
  -- 		end
  -- 		return
  -- 	end
  --
  -- 	-- Zoom to vim pane if it exists
  -- 	local vim_pane = find_vim_pane(tab)
  -- 	if vim_pane then
  -- 		vim_pane:activate()
  -- 		tab:set_zoomed(true)
  -- 	end
  -- end),
  -- },
}

M.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }

M.keys = TableConcat(keys_default, keys_wezterm)

M.key_tables = {
  resize_font = {
    { key = "=",         action = act.IncreaseFontSize },
    { key = "-",         action = act.DecreaseFontSize },
    { key = "Backspace", action = act.ResetFontSize },
    { key = "Escape",    action = "PopKeyTable" },
    { key = "q",         action = "PopKeyTable" },
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
    { key = "q",      action = "PopKeyTable" },
  },
}

return M
