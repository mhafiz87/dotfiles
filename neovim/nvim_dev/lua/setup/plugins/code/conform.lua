local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "zapling/mason-conform.nvim",
    },
    config = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          -- Conform will run multiple formatters sequentially
          python = { "isort", "black" },
          -- Use a sub-list to run only the first available formatter
          -- javascript = { { "prettierd", "prettier" } },
        },
        format_after_save = {
          lsp_fallback = true,
          async = true,
          timeout_ms = 500,
        },
        formatters = {
          isort = {
            include_trailing_comma = true,
            command = "isort",
            args = {
              "--profile",
              "black",
              "-",
            },
          },
        },
      })
      vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        conform.format({
          lsp_fallback = true,
          async = true,
          timeout_ms = 2000,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  }
  return data
end

return M
