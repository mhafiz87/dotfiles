local lsp_list = {
  "bash",
  "c",
  "cpp",
  "css",
  "dockerfile",
  -- "gitcommit",
  "gitignore",
  "html",
  "javascript",
  "json",
  -- "latex",
  "lua",
  "markdown_inline",
  "markdown",
  "python",
  "query",
  "rust",
  "toml",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

return {
  {
    enabled = true,
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      ensure_installed = lsp_list,
    },
    config = function(_, opts)
      require("nvim-treesitter").install( lsp_list ):wait(60000)
      -- require("nvim-treesitter.configs").setup({
      --   ensure_installed = lsp_list,
      -- })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = lsp_list,
        callback = function()
          -- syntax highlighting, provided by Neovim
          vim.treesitter.start()
          -- folds, provided by Neovim
          -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          -- vim.wo.foldmethod = 'expr'
          -- indentation, provided by nvim-treesitter
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
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
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    priority = 994,
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      -- vim.g.no_plugin_maps = true

      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
      -- vim.g.no_ruby_maps = true
      -- vim.g.no_rust_maps = true
      -- vim.g.no_go_maps = true
    end,
    config = function()
      local ts_repeat_move =
        require("nvim-treesitter-textobjects.repeatable_move")

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set( { "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set( { "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

      -- vim way: ; goes to the direction you were moving.
      -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set( { "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set( { "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set( { "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set( { "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "]m", function()
        require("nvim-treesitter-textobjects.move").goto_next_start(
          "@function.outer",
          "textobjects"
        )
        vim.cmd(":sleep 100m")
        vim.cmd("norm! zz")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]-", function()
        require("nvim-treesitter-textobjects.move").goto_next_start(
          "@function.outer",
          "textobjects"
        )
        vim.cmd(":sleep 100m")
        vim.cmd("norm! zz")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[m", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start(
          "@function.outer",
          "textobjects"
        )
        vim.cmd(":sleep 100m")
        vim.cmd("norm! zz")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[-", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start(
          "@function.outer",
          "textobjects"
        )
        vim.cmd(":sleep 100m")
        vim.cmd("norm! zz")
      end)
    end,
  },
}
