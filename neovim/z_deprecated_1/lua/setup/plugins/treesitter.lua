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
        },
        auto_install = true,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local ntt = require("nvim-treesitter.textobjects.move")
      vim.keymap.set("n", "mn", function()
        ntt.goto_next_start("@function.outer")
        vim.api.nvim_feedkeys("zz", "n", false)
      end, { desc = "Go to next function/method" })
      vim.keymap.set("n", "cn", function()
        ntt.goto_next_start("@class.outer")
        vim.api.nvim_feedkeys("zz", "n", false)
      end, { desc = "Go to next class" })
      vim.keymap.set("n", "mp", function()
        ntt.goto_previous_start("@function.outer")
        vim.api.nvim_feedkeys("zz", "n", false)
      end, { desc = "Go to previous function/method" })
      vim.keymap.set("n", "cp", function()
        ntt.goto_previous_start("@class.outer")
        vim.api.nvim_feedkeys("zz", "n", false)
      end, { desc = "Go to previous class" })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("treesitter-context").setup({
        max_lines = 3,
      })
    end,
  },
}
