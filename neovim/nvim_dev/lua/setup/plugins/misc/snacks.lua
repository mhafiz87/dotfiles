local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      { "<leader>bf", function() Snacks.picker.buffers() end, desc = "[b]uffers [f]ind" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "[f]ind [f]files" },
      { "<leader>fm", function() Snacks.picker.marks() end, desc = "[f]ind [m]arks" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      { "<leader>dga", function() Snacks.picker.diagnostics() end, desc = "[d]ia[g]nostics" },
      { "<leader>dgb", function() Snacks.picker.diagnostics_buffer() end, desc = "[d]ia[g]nostics [b]uffer" },
      { "<leader>dgb", function() Snacks.picker.diagnostics_buffer() end, desc = "[d]ia[g]nostics [b]uffer" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "[g]it [s]tatus" },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "[g]it [s]tatus" },
    },
  }
  return data
end

return M

