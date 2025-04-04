return {
  "nvim-treesitter/nvim-treesitter",
  priority = 996,
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  opts = function()
    local treesitter = require("nvim-treesitter.configs")
    local opts = {
      treesitter.setup({
        highlight = { enable = true }, -- enable syntax highlighting
        indent = { enable = true },    -- enable indentation
        ensure_installed = {
          -- "comment",
          "dockerfile",
          "gitcommit",
          "gitignore",
          "json",
          "jsonc",
          "markdown",
          "markdown_inline",
          "lua",
          "python",
          "toml",
          "vim",
          "vimdoc",
          "query",
          "xml",
          "yaml",
        },
        auto_install = true,
      })
    }
    return opts
  end
}