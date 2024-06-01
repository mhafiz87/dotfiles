return {
  "neovim/nvim-lspconfig",
  dependencies =  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "j-hui/fidget.nvim",
  },
  config = function ()
    local map = vim.keymap.set
    local lspconfig = require("lspconfig")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_lsp.default_capabilities()
    )
    local opts = { noremap = true, silent = true }
    local on_attach = function(client, bufnr)
      opts.buffer = bufnr
      opts.desc = "Show LSP [r]eferences (Telescope)"
      map("n", "<leader>lR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

      opts.desc = "Go to [D]eclaration"
      map("n", "<leader>ld", vim.lsp.buf.declaration, opts) -- go to declaration

      opts.desc = "Show LSP [d]efinitions (Telescope)"
      map("n", "<leader>lD", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

      opts.desc = "Show LSP [i]mplementations (Telescope)"
      map("n", "<leader>lI", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

      opts.desc = "Show LSP [t]ype definitions"
      map("n", "<leader>lT", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

      opts.desc = "See available [c]ode [a]ctions"
      map({ "n", "v" }, "<leader>lca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

      opts.desc = "Smart [r]e[n]ame"
      map("n", "<leader>lrn", vim.lsp.buf.rename, opts) -- smart rename

      opts.desc = "Show buffer [D]iagnostics (Telescope)"
      map("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

      opts.desc = "Show line [d]iagnostics"
      map("n", "<leader>ld", vim.diagnostic.open_float, opts) -- show diagnostics for line

      opts.desc = "Show do[k]umentation for what is under cursor"
      map("n", "<leader>lk", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

      opts.desc = "[r]e[s]tart LSP"
      map("n", "<leader>lrs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

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

  -- TODO: Beautify ui
}

