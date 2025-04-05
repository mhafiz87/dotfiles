return {
  {
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
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    priority = 995,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      max_lines = 5,
    }
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    priority = 994,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local ntt = require("nvim-treesitter.textobjects.move")
      vim.keymap.set(
        "n", "]-", function ()
          ntt.goto_next_start("@function.outer")
          vim.cmd(":sleep 100m")
          vim.cmd("norm! zz")
        end,
        { desc = "Go to next function", noremap = true, silent = true }
      )
      vim.keymap.set(
        "n", "[-", function ()
          ntt.goto_previous_start("@function.outer")
          vim.cmd(":sleep 100m")
          vim.cmd("norm! zz")
        end,
        { desc = "Go to next function", noremap = true, silent = true }
      )
      vim.keymap.set(
        "n", "}", function ()
          ntt.goto_next_start("@block.outer")
          vim.cmd(":sleep 100m")
          vim.cmd("norm! zz")
        end,
        { desc = "Go to next block", noremap = true, silent = true }
      )
      vim.keymap.set(
        "n", "{", function ()
          ntt.goto_previous_start("@block.outer")
          vim.cmd(":sleep 100m")
          vim.cmd("norm! zz")
        end,
        { desc = "Go to next block", noremap = true, silent = true }
      )
    end
  }
}