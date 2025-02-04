local M = {}
local toggle_rnu = {
  name = "[R]elative [N]umber",
  keys = "<leader>tor",
  which_key = true,
  notify = true,
  get = function()
    return vim.wo.relativenumber
  end,
  set = function(state)
    vim.wo.relativenumber = state
  end,
}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
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
    config = function(_, opts)
      -- local powershell_options = {
      --   shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
      --   shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
      --   shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
      --   shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
      --   shellquote = "",
      --   shellxquote = "",
      -- }
      -- for option, value in pairs(powershell_options) do
      --   vim.opt[option] = value
      -- end
      require("snacks").setup(opts)
      vim.keymap.set({"n", "t"}, "<c-_>", function()
        -- for option, value in pairs(powershell_options) do
        --   vim.opt[option] = value
        -- end
        Snacks.terminal("pwsh")
      end, { desc = "which_key_ignore", silent = true })
      -- require("snacks.toggle").new(toggle_rnu):map(toggle_rnu.keys, { mode = { "n" } })
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tor")
      Snacks.toggle.inlay_hints():map("<leader>toih")
    end,
  }
  return data
end

return M
