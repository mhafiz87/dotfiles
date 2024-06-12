local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

M.choices = { { label = "awake" } }

M.workspaces = {
  awake = {
    parameter = {
      label = "awake",
      cwd = os.getenv("userprofile"),
    },
  },
  home = {
    parameter = {
      label = "home",
      cwd = os.getenv("userprofile"),
    },
  },
}

function M.kill_workspace(workspace)
  wezterm.log_info("Workspace to delete: " .. workspace)
  local success, stdout = wezterm.run_child_process({ "wezterm", "cli", "list", "--format=json" })
  if success then
    local json = wezterm.json_parse(stdout)
    if not json then
      return
    end
    for _, value in ipairs(json) do
      if value.workspace == workspace then
        local count = 0
        local temp = M.workspaces
        for key, _ in pairs(temp) do
          if key == workspace then
            wezterm.run_child_process({ "wezterm", "cli", "kill-pane", "--pane-id=" .. value.pane_id })
            M.workspaces[workspace] = nil
          end
          count = count + 1
        end
      end
    end
  end
end

function M.create_workspace(window, pane)
  window:perform_action(
    act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      },
      action = wezterm.action_callback(function(inner_window, inner_pane, line)
        if line then
          M.workspaces[line] = { parameter = { label = line } }
          for k, v in pairs(M.workspaces) do
            wezterm.log_info(k, v)
          end
          inner_window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            inner_pane
          )
        end
      end)
    },
    pane
  )
end

function M.load_workpace(window, pane, label)
  window:perform_action(
    act.SwitchToWorkspace {
      name = label,
      spawn = M.workspaces[label]["parameter"],
    },
    pane
  )
end

return M
