local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    {
      enabled = args.enable,
      "nvim-treesitter/nvim-treesitter",
      event = { "BufReadPre", "BufNewFile" },
      build = ":TSUpdate",
      config = function()
        local treesitter = require("nvim-treesitter.configs")
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
      end
    },
    {
      enabled = args.enable,
      "nvim-treesitter/nvim-treesitter-context",
      event = { "BufReadPost", "BufNewFile" },
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("treesitter-context").setup({
          max_lines = 5,
        })
      end,
    },
    {
      enabled = args.enable,
      "nvim-treesitter/nvim-treesitter-textobjects",
      event = { "BufReadPost", "BufNewFile" },
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      config = function ()
        local ntt = require("nvim-treesitter.textobjects.move")
        vim.keymap.set(
          "n", "}", function ()
            ntt.goto_next_start("@block.outer")
            vim.cmd(":sleep 100m")
            vim.cmd("norm! zz")
          end,
          { desc = "Go to next symbol", noremap = true, silent = true }
          )
        vim.keymap.set(
          "n", "{", function ()
            ntt.goto_previous_start("@block.outer")
            vim.cmd(":sleep 100m")
            vim.cmd("norm! zz")
          end,
          { desc = "Go to next symbol", noremap = true, silent = true }
          )
      end
    }
  }
  return data
end

return M
