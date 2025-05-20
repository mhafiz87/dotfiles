return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    win = {
      border = "rounded",
      wo = {
        winblend = 50
      }
    },
    spec = {
      mode = {"n", "v"},
      {"<leader>b", group = "buffer"},
      {"<leader>c", group = "highlight"},
      {"<leader>d", group = "debugger/diagnostics/docstring"},
      {"<leader>dg", group = "diagnostics"},
      {"<leader>g", group = "git"},
      {"<leader>m", group = "format"},
      {"<leader>t", group = "toggle"},
      {"<leader>tr", group = "relative number"},
      {"<leader>ti", group = "inlay hint"},
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}