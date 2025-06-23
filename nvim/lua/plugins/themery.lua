return {
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {},
  },
  {
    'loctvl842/monokai-pro.nvim',
    priority = 1001,
    opts = {},
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1002,
    config = function()
      -- vim.cmd("colorscheme rose-pine")
    end
  },
  {
    'zaldih/themery.nvim',
    lazy = false,
    priority = 2000,
    config = function ()
      require("themery").setup({
        globalBefore = [[]],
        globalAfter = [[]],
        themes = {
          {
            name = "tokyonight night",
            colorscheme = "tokyonight-night", 
          },
          {
            name = "tokyonight storm",
            colorscheme = "tokyonight-storm", 
          },
          {
            name = "tokyonight day",
            colorscheme = "tokyonight-day", 
          },
          {
            name = "tokyonight moon",
            colorscheme = "tokyonight-moon", 
          },
          {
            name = "monokai pro",
            colorscheme = "monokai-pro",

          },
          {
            name = "monokai pro classic",
            colorscheme = "monokai-pro-classic",
          },
          {
            name = "rose pine",
            colorscheme = "rose-pine-main",
          },
          {
            name = "rose pine moon",
            colorscheme = "rose-pine-moon",
          },
          {
            name = "rose pine dawn",
            colorscheme = "rose-pine-dawn",
          },
        },
        livePreview = true,
      })
    end
  }
}
