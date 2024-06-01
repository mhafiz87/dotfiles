return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre" },
    dependencies = {
      "jay-babu/mason-null-ls.nvim",
    },
    config = function() -- import null-ls plugin
      local null_ls = require("null-ls")
      local null_ls_utils = require("null-ls.utils")
      local formatting = null_ls.builtins.formatting -- to setup formatters
      local diagnostics = null_ls.builtins.diagnostics -- to setup linters
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      require("mason-null-ls").setup({
        ensure_installed = {
          "black", -- python formatter
          "shfmt", -- shell formatter
          "stylua", -- lua formatter
          "prettierd", -- faster prettier formatter
          "markdownlint", -- markdown linter
          "isort", -- python import sorter
        },
      })

      null_ls.setup({
        sources = {
          -- diagnostics.ruff.with({
          --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          -- }),
          diagnostics.markdownlint.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          })
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black", "isort" },
          markdown = { "prettierd" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      })

      vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
}
