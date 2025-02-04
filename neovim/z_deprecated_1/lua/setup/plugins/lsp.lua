return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "folke/neodev.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "j-hui/fidget.nvim",
  },
  config = function()
    local tools = require("tools")
    local lspconfig = require("lspconfig") -- nvim-lspconfig
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }
    local on_attach = function(client, bufnr)
      opts.buffer = bufnr
      opts.desc = "Show LSP [r]eferences"
      map("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

      opts.desc = "Go to [D]eclaration"
      map("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

      opts.desc = "Show LSP [d]efinitions"
      map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

      opts.desc = "Show LSP [i]mplementations"
      map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

      opts.desc = "Show LSP [t]ype definitions"
      map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

      opts.desc = "See available [c]ode [a]ctions"
      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

      opts.desc = "Smart [r]e[n]ame"
      map("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

      opts.desc = "Show buffer [D]iagnostics"
      map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

      opts.desc = "Show line [d]iagnostics"
      map("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

      opts.desc = "Go to [[]revious [d]iagnostic"
      map("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

      opts.desc = "Go to []]ext [d]iagnostic"
      map("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

      opts.desc = "Show do[K]umentation for what is under cursor"
      map("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

      opts.desc = "[r]e[s]tart LSP"
      map("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
    end

    require("fidget").setup({})
    require("neodev").setup()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-server
        "lua_ls",
        "pyright",
        "powershell_es",
        "marksman"
      },
      automatic_installation = true,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if tools.is_plugin_installed("cmp-nvim-lsp") == true then
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    end

    -- Call setup on each LSP server
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        lspconfig[server_name].setup({
          on_attach = on_attach,
          capabilities = capabilities,
          handlers = {
            -- Add borders to LSP popups
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
          },
        })
      end,
    })

    lspconfig["ruff_lsp"].setup({
      init_options = {
        settings = {
          args = {}
        }
      }
    })

    -- configure Lua Server
    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          workspace = {
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
        },
      },
    })
  end,
}
