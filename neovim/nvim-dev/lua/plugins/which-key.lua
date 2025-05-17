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
  triggers = {
    { "<auto>", mode = "nxso" },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
    -- {
    --   "<c-w>.",
    --   function()
    --     require("which-key").show({
    --       keys = "<c-w>",
    --       loop = true
    --     })
    --   end,
    --   desc = "Window Navigation"
    -- },
    -- { "<c-w>h", "<c-w>h", desc = "Go to left window" },
    -- { "<c-w>l", "<c-w>l", desc = "Go to right window" },
    -- { "<c-w>+", "<c-w>+", desc = "Increase height" },
    -- { "<c-w>-", "<c-w>-", desc = "Decrease height" },
    -- { "<c-w>_", "<c-w>-", desc = "Max height" },
    -- { "<c-w>>", "<c-w>>", desc = "Increase width" },
    -- { "<c-w><", "<c-w><", desc = "Decrease width" },
    -- { "<c-w>|", "<c-w>|", desc = "Max width" },
    -- { "<c-w>=", "<c-w>=", desc = "Equally high and wide" },
  },
}
