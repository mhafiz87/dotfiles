local M = {}
local global = require("global")

local dependent = function()
  local plugins = {}
  if global.is_linux then
    table.insert(plugins, "williamboman/mason.nvim")
    table.insert(plugins, "zapling/mason-conform.nvim")
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
      if global.is_windows then
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

        lspconfig.powershell_es.setup({
          -- on_attach = on_attach,
          capabilities = capabilities,
          filetypes = {"ps1", "psm1", "psd1"},
          bundle_path = os.getenv("USERPROFILE") .. "\\lsp\\PowerShellEditorServices",
          settings = { powershell = { codeFormatting = { Preset = 'OTBS' } } },
          init_options = {
            enableProfileLoading = false,
          },
        })

      else
        require("mason").setup()
        require("mason-lspconfig").setup({
          automatic_installation = true,
          ensure_installed = {
            "lua_ls",
            "basedpyright",
            "powershell_es",
            "marksman",
            "ruff",
            "bashls",
          },
          handlers = {
            function(server_name)
              lspconfig[server_name].setup({
                -- on_attach = on_attach,
                capabilities = capabilities,
              })
            end,
          }
        })
      end
    end,
  }
  return data
end

return M
