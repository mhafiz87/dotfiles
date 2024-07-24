local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require("tokyonight").setup({})
      end,
    },
    {
      "tiagovla/tokyodark.nvim",
      opts = {
        transparent_background = false,                                        -- set background to transparent
        gamma = 1.00,                                                          -- adjust the brightness of the theme
        styles = {
          comments = { italic = true },                                        -- style for comments
          keywords = { italic = true },                                        -- style for keywords
          identifiers = { italic = true },                                     -- style for identifiers
          functions = {},                                                      -- style for functions
          variables = {},                                                      -- style for variables
        },
        custom_highlights = {} or function(highlights, palette) return {} end, -- extend highlights
        custom_palette = {} or function(palette) return {} end,                -- extend palette
        terminal_colors = true,                                                -- enable terminal colors      },
      },
      config = function(_, opts)
        require("tokyodark").setup(opts) -- calling setup is optional
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
      'projekt0n/github-nvim-theme',
      config = function()
        require('github-theme').setup({
          -- ...
        })
      end
    },
    {
      "zaldih/themery.nvim",
      config = function()
        require("themery").setup({
          themes = {
            "catppuccin-frappe",
            -- "catppuccin-latte",
            "catppuccin-macchiato",
            "catppuccin-mocha",
            "github_dark",
            "github_dark_dimmed",
            "github_dark_default",
            "kanagawa-dragon",
            -- "kanagawa-lotus",
            "kanagawa-wave",
            "monokai_pro",
            -- "monokai_ristretto",
            "monokai_soda",
            "monokai",
            "tokyodark",
            -- "tokyonight-day",
            "tokyonight-moon",
            "tokyonight-night",
            "tokyonight-storm",
            "vscode",
          },
          livePreview = true,
        })
        vim.keymap.set("n", "<leader>ft", "<cmd>Themery<cr>", { desc = "[f]ind [t]hemes", noremap = true, silent = true })
      end,
    },
  }
  return data
end

return M
