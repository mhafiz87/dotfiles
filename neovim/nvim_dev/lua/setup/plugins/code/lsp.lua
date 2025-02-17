local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim", -- manage / auto-install LSP server
      "j-hui/fidget.nvim", -- to show LSP progress
      "hrsh7th/nvim-cmp", -- completion engine plugin
      "hrsh7th/cmp-nvim-lsp", -- completion source for neovim
    },
    event = "BufReadPre",
    config = function()
      local tools = require("tools")
      local lspconfig = require("lspconfig")
      local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities())
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }
      local on_attach = function(client, bufnr)
      end
      require("fidget").setup()
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = {
          "lua_ls",
          "basedpyright",
          -- "pyright",
          "powershell_es",
          "marksman",
          "ruff",
        },
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                  hint = {
                    enable = true,
                  },
                },
              },
            })
          end,
          -- https://github.com/LazyVim/LazyVim/discussions/3350#discussioncomment-9584985
          ["basedpyright"] = function()
            lspconfig.basedpyright.setup({
              on_attach = on_attach,
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
          end,
          ["marksman"] = function()
            lspconfig.marksman.setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,
        },
      })
    end,
  }
  return data
end

return M