local M = {}
local global = require("global")

local dependent = function()
  local plugins = {}
  if global.is_linux then
    table.insert(plugins, "williamboman/mason.nvim")
    table.insert(plugins, "williamboman/mason-lspconfig.nvim")
    table.insert(plugins, "zapling/mason-conform.nvim")
  end
  return plugins
end

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "stevearc/conform.nvim",
    dependencies = dependent(),
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          -- Conform will run multiple formatters sequentially
          python = { "isort", "black" },
          -- Use a sub-list to run only the first available formatter
          -- javascript = { { "prettierd", "prettier" } },
          markdown = { "prettier" },
        },
        -- format_after_save = {
        --   lsp_fallback = true,
        --   async = true,
        --   timeout_ms = 500,
        -- },
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
      if global.is_linux then
        require("mason-conform").setup({
          ensure_installed = {
              "black",
              "isort",
              "markdownlint",
              "markdown-toc",
              "prettier",
              "stylua"
            },
            automatic_installation = {},
            ignore_install = {},
          })
      end
    end,
  }
  return data
end

return M
