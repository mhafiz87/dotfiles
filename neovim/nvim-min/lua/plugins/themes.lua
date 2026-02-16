local utils = require("utils")
return {
  {
    enabled = false,
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
        -- vim.cmd.colorscheme("rose-pine")
        require("rose-pine").setup({
          highlight_groups = {
            Cursor = { fg = "#fcf0ea", bg = "#fcf0ea" },
          },
        })
        vim.cmd [[colorscheme rose-pine]]
    end
  },
  {
    enabled = false,
    "folke/tokyonight.nvim",
    name = "tokyonight",
    config = function()
        -- vim.cmd.colorscheme("tokyonight")
        require("tokyonight").setup({
          highlight_groups = {
            Cursor = { fg = "#fcf0ea", bg = "#fcf0ea" },
          },
        })
        vim.cmd [[colorscheme tokyonight]]
    end
  },
  {
    enabled = true,
    "Mofiqul/vscode.nvim",
    name = "vscode",
    config = function()
        local c = require('vscode.colors').get_colors()
        require("vscode").setup({
          -- Enable italic comment
          italic_comments = true,

          -- Enable italic inlay type hints
          italic_inlayhints = true,

          -- Underline `@markup.link.*` variants
          underline_links = true,

          -- Disable nvim-tree background color
          disable_nvimtree_bg = true,

          -- Apply theme colors to terminal
          terminal_colors = true,

          -- Override colors (see ./lua/vscode/colors.lua)
          color_overrides = {
              vscLineNumber = '#FFFFFF',
          },

          -- Override highlight groups (see ./lua/vscode/theme.lua)
          group_overrides = {
              -- this supports the same val table as vim.api.nvim_set_hl
              -- use colors from this colorscheme by requiring vscode.colors!
              Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
          }

          -- highlight_groups = {
          --   Cursor = { fg = "#fcf0ea", bg = "#fcf0ea" },
          -- },
        })
        vim.cmd [[colorscheme vscode]]
        utils.update_theme_hl("@keyword.import", { italic = true })
    end
  }
}
