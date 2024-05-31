return {
  "neovim/nvim-lspconfig",
  dependencies =  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "j-hui/fidget.nvim",
  },
  config = function ()
    local lspconfig = require("lspconfig")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_lsp.default_capabilities()
    )
    local opts = { buffer = bufnr, noremap = true, silent = true }
    local on_attach = function(client, bufnr)

    end

    require("fidget").setup()
    require("mason").setup()
    require("mason-lspconfig").setup({
      automatic_installation = true,
      ensure_installed = {
        "lua_ls",
        "pyright",
        "powershell_es",
        "marksman",
        "ruff_lsp",
      },
      handlers = {
        function(server_name)
          lspconfig[server_name].setup{
            on_attach = on_attach,
            capabilities = capabilities,
          }
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup{
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          }
        end,
      }
    })
  end
}

