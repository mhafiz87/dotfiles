return {
  -- enabled = false,
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
      mode = {"n"},
      {"<leader>b", group = "buffer"},
      -- {"<leader>c", group = "highlight"},
      -- {"<leader>d", group = "debugger/diagnostics/docstring"},
      {"<leader>d", group = "diagnostics"},
      {"<leader>dg", group = "diagnostics"},
      {"<leader>f", group = "+find"},
      {"<leader>g", group = "+git"},
      {"<leader>gh", group = "+git hunk"},
      -- {"<leader>m", group = "+markdown"},
      -- {"<leader>md", group = "+markdown"},
      -- {"<leader>t", group = "+toggle"},
      -- {"<leader>tr", group = "relative number"},
      -- {"<leader>ti", group = "inlay hint"},
      {"<leader><leader>", group = "+flash"},
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
    {
      "<C-w>.",
      function()
        require("which-key").show(
          {
            keys = "<C-w>",
            loop = true
          }
        )
      end,
      desc = "Enable hydra mode",
    },
    {
      "].",
      function()
        require("which-key").show(
          {
            keys = "]",
            loop = true
          }
        )
      end,
      desc = "Enable hydra mode",
    },
    {
      "[.",
      function()
        require("which-key").show(
          {
            keys = "[",
            loop = true
          }
        )
      end,
      desc = "Enable hydra mode",
    },
  },
}
