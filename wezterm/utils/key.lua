local wezterm = require("wezterm")
local balance = require("utils.balancepane")
local config = wezterm.config_builder()
local act = wezterm.action

local function basename(s)
  return string.match(string.gsub(s, '(.*[/\\])(.*)', '%2'), "[a-zA-Z0-9_-]+")
end

-- https://github.com/letieu/dotfiles/blob/master/dot_config/wezterm/key.lua
local function is_vim(pane)
  local process_info = pane:get_foreground_process_info()
  local process_name = ""
  if string.find(process_info.executable, "nvim") then
    process_name = "nvim"
  else
    process_name = basename(process_info.name)
  end
  return process_name == "nvim" or process_name == "python"
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
  {
    key = "w",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      -- if current active pane is vim
      if is_vim(pane) then
        wezterm.log_info("Is vim pane: " .. tostring(is_vim(pane)))
        window:perform_action({
          SendKey = { key = "w", mods = "CTRL" },
        }, pane)
      else
        window:perform_action({
          ActivateKeyTable = {
            name = "pane_direction",
            one_shot = false,
            timeout_milliseconds = 1000,
          },
        }, pane)
      end
    end),
  },
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
  { key = "w", mods = "LEADER",      action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },

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
  -- If nvim is in tab; split right and toggle
  {
    key = ";",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      local tab = window:active_tab()
      -- if current active pane is vim
      if is_vim(pane) then
        -- if number of panes is 1
        if (#tab:panes()) == 1 then
          -- Split pane to the right
          pane:split({ direction = "Right" })
        else
          for _, panel in ipairs(tab:panes_with_info()) do
            if is_vim(panel.pane) then
              tab:set_zoomed(false)
            else
              panel.pane:activate()
            end
          end
        end
        return
      end

      -- Zoom to vim pane if it exists
      local vim_pane = find_vim_pane(tab)
      if vim_pane then
        vim_pane:activate()
        tab:set_zoomed(true)
      end
    end),
  },
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
  pane_direction = {
    { key = "h",      mods = "CTRL",         action = act.ActivatePaneDirection("Left") },
    { key = "j",      mods = "CTRL",         action = act.ActivatePaneDirection("Down") },
    { key = "k",      mods = "CTRL",         action = act.ActivatePaneDirection("Up") },
    { key = "l",      mods = "CTRL",         action = act.ActivatePaneDirection("Right") },
    { key = "s",      mods = "CTRL",         action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "v",      mods = "CTRL",         action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "q",      mods = "CTRL",         action = act.CloseCurrentPane({ confirm = true }) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "q",      action = "PopKeyTable" },
  },
}

return M
