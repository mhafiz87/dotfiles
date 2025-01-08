local M = {}
local global = require("global")

local dependent = function()
  plugins = {
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    "saghen/blink.cmp"
  }
  if global.is_linux then
    table.insert(plugins, "williamboman/mason.nvim")
    table.insert(plugins, "williamboman/mason-lspconfig.nvim")
  end
  return plugins
end

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "neovim/nvim-lspconfig",
    dependencies = dependent(),
    event = "BufReadPre",
    config = function()
      local tools = require("tools")
      local lspconfig = require("lspconfig")
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      lspconfig.lua_ls.setup({})

      -- https://github.com/LazyVim/LazyVim/discussions/3350#discussioncomment-9584985
      lspconfig.basedpyright.setup({
        -- on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
              reportOptionalMemberAccess = "none",
            },
          },
        },
      })

      lspconfig.bashls.setup({
        -- on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "sh", "bash", "zsh" },
      })

      lspconfig.ruff.setup({
        -- on_attach = on_attach,
        capabilities = capabilities,
      })

      lspconfig.marksman.setup({
        -- on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
  }
  return data
end

return M
