return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({})
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({})
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({})
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local c = require("vscode.colors").get_colors()
      require("vscode").setup({
        italic_comments = true,
      })
    end,
  },
  {
    "tanvirtin/monokai.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("monokai").setup({})
    end,
  },
  {
    "zaldih/themery.nvim",
    config = function()
      require("themery").setup({
        themes = {
          "catppuccin-frappe",
          "catppuccin-latte",
          "catppuccin-macchiato",
          "catppuccin-mocha",
          "kanagawa-dragon",
          "kanagawa-lotus",
          "kanagawa-wave",
          "monokai_pro",
          "monokai_ristretto",
          "monokai_soda",
          "monokai",
          "tokyonight-day",
          "tokyonight-moon",
          "tokyonight-night",
          "tokyonight-storm",
          "vscode",
        },
        themeConfigFile = vim.fn.stdpath("config") .. "/lua/setup/plugins/themes.lua",
        livePreview = true,
      })
      vim.keymap.set("n", "<leader>ft", "<CMD>Themery<CR>", { desc = "[F]ind [T]hemes" })
      -- Themery block
      -- This block will be replaced by Themery.
      vim.cmd("colorscheme vscode")
      vim.g.theme_id = 16
      -- end themery block
    end,
  },
}

