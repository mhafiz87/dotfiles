local M = {}

function M.init (args)
  setmetatable(args, {__index={enable=true}})
  local data = {
    enabled = args.enable,
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
  }
  return data
end

return M
