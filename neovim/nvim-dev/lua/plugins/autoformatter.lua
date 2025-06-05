local utils = require("utils")

local dependent = function()
  local plugins = {}
  if utils.is_linux or utils.is_windows or utils.is_mac then
    table.insert(plugins, "williamboman/mason.nvim")
    table.insert(plugins, "williamboman/mason-lspconfig.nvim")
    table.insert(plugins, "zapling/mason-conform.nvim")
  end
  return plugins
end

return {
  "stevearc/conform.nvim",
  dependencies = {
    -- "williamboman/mason.nvim",
    -- "williamboman/mason-lspconfig.nvim",
    -- {
    --   "zapling/mason-conform.nvim",
    --   opts = {
    --     ensure_installed = {
    --         "black",
    --         "isort",
    --         "markdownlint",
    --         "markdown-toc",
    --         "prettier",
    --         "stylua"
    --       },
    --       automatic_installation = {},
    --       ignore_install = {},
    --   },
    -- }
  },
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
      -- Use a sub-list to run only the first available formatter
      -- javascript = { { "prettierd", "prettier" } },
      markdown = { "prettier" },
      toml = { "taplo" },
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
  },
  keys = {
    { "<leader>mp", function ()
      require("conform").format({
        lsp_fallback = true,
        async = true,
        timeout_ms = 2000,
      })
      end,
      desc = "Format file or range (in visual mode)",
    },
  },
}
