
-- LEADER F      | resize font (=, - , BS)
-- LEADER CTRL W | pane navigation (h, j, k, l, w, d, t, v, s, u, i)
-- LEADER P      | resize pane using (h, j, k, l, b)
-- LEADER W      | workspace (o, d, l, h)

local wezterm = require("wezterm")
local balance = require("utils.balancepane")
local helper = require("utils.helper")
local act = wezterm.action
local mux = wezterm.mux
local ws = require("utils.workspaces")

local M = {}

local keys_wezterm = {}

local keys_default = {
  { key = "p",   mods = "LEADER|CTRL|SHIFT", action = act.ActivateCommandPalette },
  { key = "F11", mods = "LEADER",            action = act.ToggleFullScreen },

  -- Search
  { key = "f",   mods = "LEADER|CTRL|SHIFT", action = act.Search({ CaseInSensitiveString = "" }) },

  -- Toggle zoom state
  { key = "z",   mods = "LEADER|CTRL",       action = act.TogglePaneZoomState },

  -- Rename Current Tab
  {
    key = "t",
    mods = "LEADER|CTRL|SHIFT",
    action = act.PromptInputLine{
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }
  },

  -- fonts
  {
    key = "f",
    mods = "LEADER",
    action = act.ActivateKeyTable({
      name = "resize_font",
      one_shot = false,
      timeout_milliseconds = 1000,
      until_unknown = true,
    }),
  },

  -- Copy Paste
  { key = "x",   mods = "LEADER|CTRL", action = act.ActivateCopyMode },
  { key = "c",   mods = "LEADER|CTRL", action = act.CopyTo("Clipboard") },
  { key = "v",   mods = "LEADER|CTRL", action = act.PasteFrom("Clipboard") },

  -- Tab
  { key = "Tab", mods = "CTRL",        action = act.ActivateTabRelative(1) },
  { key = "Tab", mods = "CTRL|SHIFT",  action = act.ActivateTabRelative(-1) },
  { key = "t",   mods = "LEADER|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
  {
    key = "1",
    mods = "LEADER|CTRL",
    action = act.SpawnCommandInNewTab({
      args = { "pwsh", "-l" },
      cwd = os.getenv("userprofile"),
    }),
  },
  {
    key = "2",
    mods = "LEADER|CTRL",
    action = act.SpawnCommandInNewTab({
      args = { "cmd", "-l" },
      cwd = os.getenv("userprofile"),
    }),
  },

  -- Pane Operation
  {
    key = "w",
    mods = "LEADER|CTRL",
    action = act.ActivateKeyTable({
      name = "pane_operation",
      one_shot = false,
      timeout_milliseconds = 2000,
      until_unknown = true,
    }),
  },

  -- Pane
  {
    key = "w",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
        window:perform_action({
          SendKey = { key = "w", mods = "CTRL" },
        }, pane)
      -- -- if current active pane is vim
      -- if helper.is_vim(pane) then
      --   wezterm.log_info("Is vim pane: " .. tostring(helper.is_vim(pane)))
      --   window:perform_action({
      --     SendKey = { key = "w", mods = "CTRL" },
      --   }, pane)
      -- else
      --   -- pane_direction key table does not exist
      --   window:perform_action({
      --     ActivateKeyTable = {
      --       name = "pane_direction",
      --       one_shot = false,
      --       timeout_milliseconds = 1000,
      --       until_unknown = true,
      --     },
      --   }, pane)
      -- end
    end),
  },

  -- Send Ctrl Space to windows
  {
    key = "Space",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      window:perform_action({
        SendKey = { key = "Space", mods = "CTRL" },
      }, pane)
    end),
  },

  -- resize_pane
  {
    key = "p",
    mods = "LEADER",
    action = act.ActivateKeyTable({
      name = "resize_pane",
      one_shot = false,
      timeout_milliseconds = 2000,
      until_unknown = true,
    }),
  },

  -- Workspace
  {
    key = "w",
    mods = "LEADER",
    action = act.ActivateKeyTable({
      name = "workspace",
      one_shot = false,
      timeout_milliseconds = 2000,
      until_unknown = true,
    })
  },

  -- Hyperlink
  {
    key = "u",
    mods = "LEADER",
    action = act.QuickSelectArgs({
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
      if helper.is_vim(pane) then
        -- if number of panes is 1
        if (#tab:panes()) == 1 then
          -- Split pane to the right
          pane:split({ direction = "Right" })
        else
          for _, panel in ipairs(tab:panes_with_info()) do
            if helper.is_vim(panel.pane) then
              tab:set_zoomed(false)
            else
              panel.pane:activate()
            end
          end
        end
        return
      end

      -- Zoom to vim pane if it exists
      local vim_pane = helper.find_vim_pane(tab)
      if vim_pane then
        vim_pane:activate()
        tab:set_zoomed(true)
      end
    end),
  },
}

M.leader = { key = "l", mods = "CTRL", timeout_milliseconds = 2000 }

M.keys = helper.TableConcat(keys_default, keys_wezterm)

M.key_tables = {
  workspace = {
    -- Create new workspace
    {
      key = "o",
      action = act.Multiple({
        wezterm.action_callback(function(window, pane)
          local selection = { { label = "new" } }
          for key, _ in pairs(ws.workspaces) do
            table.insert(selection, { label = key })
          end
          window:perform_action(
            act.InputSelector {
              action = wezterm.action_callback(
                function(inner_window, inner_pane, id, label)
                  if label == "new" then
                    wezterm.log_info("Creating new workspace")
                    ws.create_workspace(inner_window, inner_pane)
                  else
                    wezterm.log_info("Loading workspace...")
                    ws.load_workpace(inner_window, inner_pane, label)
                  end
                end
              ),
              title = 'Choose Workspace',
              choices = selection,
              fuzzy = true,
              fuzzy_description = wezterm.format {
                { Attribute = { Intensity = 'Bold' } },
                { Foreground = { AnsiColor = 'Fuchsia' } },
                { Text = "Select workspace or 'new' to create new workspace: " },
              },
            },
            pane
          )
        end),
      })
    },
    -- Delete workspaces
    {
      key = "d",
      action = wezterm.action_callback(function(window, pane)
        local selection = {}
        for key, _ in pairs(ws.workspaces) do
          table.insert(selection, { label = key })
        end
        window:perform_action(
          act.InputSelector {
            action = wezterm.action_callback(
              function(inner_window, inner_pane, id, label)
                wezterm.log_info(label)
                ws.kill_workspace(label)
              end
            ),
            title = 'Delete Workspace',
            choices = selection,
            fuzzy = true,
            fuzzy_description = wezterm.format {
              { Attribute = { Intensity = 'Bold' } },
              { Foreground = { AnsiColor = 'Fuchsia' } },
              { Text = "Select workspace to delete: " },
            },
          },
          pane
        )
      end)
    },
    -- rename current workspace
    -- {
    --   key = "r",
    --   action = act.PromptInputLine {
    --     description = "Rename current workspace",
    --     action = wezterm.action_callback(function(window, pane, line)
    --       if line then
    --         mux.rename_workspace(mux.get_active_workspace(), line)
    --       end
    --     end)
    --   },
    -- },
    { key = "l",      action = act.SwitchWorkspaceRelative(1) },
    { key = "h",      action = act.SwitchWorkspaceRelative(-1) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "q",      action = "PopKeyTable" },
  },
  resize_font = {
    { key = "=",         action = act.IncreaseFontSize },
    { key = "-",         action = act.DecreaseFontSize },
    { key = "Backspace", action = act.ResetFontSize },
    { key = "Escape",    action = "PopKeyTable" },
    { key = "q",         action = "PopKeyTable" },
  },
  resize_pane = {
    { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
    {
      key = "b",
      action = act.Multiple({
        wezterm.action_callback(balance.balance_panes("x")),
        wezterm.action_callback(balance.balance_panes("y")),
      }),
    },
    { key = "Escape", action = "PopKeyTable" },
    { key = "q",      action = "PopKeyTable" },
  },
  pane_operation = {
    { key = "w",      action = act.CloseCurrentPane({ confirm = true }) },
    { key = "h",      action = act.ActivatePaneDirection("Left") },
    { key = "j",      action = act.ActivatePaneDirection("Down") },
    { key = "k",      action = act.ActivatePaneDirection("Up") },
    { key = "l",      action = act.ActivatePaneDirection("Right") },
    { key = "t",      action = act.TogglePaneZoomState },
    { key = "s",      action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "v",      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "d",      action = act.CloseCurrentPane({ confirm = false }) },
    { key = "u",      action = act.ScrollByLine(5) },
    { key = "i",      action = act.ScrollByLine(-5) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "q",      action = "PopKeyTable" },
  },
}

return M
