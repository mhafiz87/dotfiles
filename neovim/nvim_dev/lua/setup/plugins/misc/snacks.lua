local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "folke/snacks.nvim",
    priority = 1000,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          -- {
          --   pane = 2,
          --   section = "terminal",
          --   cmd = "colorscript -e square",
          --   height = 5,
          --   padding = 1,
          -- },
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      { "<leader>tz", function() Snacks.zen() end, desc = "[t]oggle [z]en Mode" },
      { "<leader>nc", function() Snacks.notifier.hide() end, desc = "[n]otifier [c]lear" },
      { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "[n]otifier [h]istory" },
    },
    config = function (_, opts)
      require("snacks").setup(opts)
      vim.keymap.set({"n", "t"}, "<c-_>", function() Snacks.terminal("pwsh") end, { desc = "which_key_ignore", silent = true })
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tor")
      Snacks.toggle.inlay_hints():map("<leader>toih")
    end,
  }
  return data
end

return M
