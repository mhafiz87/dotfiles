return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter.configs")
      treesitter.setup({
        highlight = { enable = true }, -- enable syntax highlighting
        indent = { enable = true }, -- enable indentation
        ensure_installed = {
          "comment",
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
          "xml",
          "yaml",
        },
        auto_install = true,
      })
    end
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter-context",
  --   event = { "BufReadPost", "BufNewFile" },
  --   config = function()
  --     require("treesitter-context").setup({
  --       max_lines = 3,
  --     })
  --   end,
  -- }
}

