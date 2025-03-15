local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local tools = require("tools")
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
      local lspconfig = require("lspconfig")
      local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities())
      local on_attach = function(client, bufnr)
        local map = function(mode, l, r, opts)
          opts = opts or {}
          opts.silent = true
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        vim.api.nvim_create_autocmd("CursorHold", {
          buffer = bufnr,
          callback = function()
            local float_opts = {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
              border = "rounded",
              source = "always", -- show source in diagnostic popup window
              prefix = " ",
            }

            if not vim.b.diagnostics_pos then
              vim.b.diagnostics_pos = { nil, nil }
            end

            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            if
              (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2])
              and #vim.diagnostic.get() > 0
            then
              vim.diagnostic.open_float(nil, float_opts)
            end

            vim.b.diagnostics_pos = cursor_pos
          end,
        })

        -- The blow command will highlight the current variable and its usages in the buffer.
        if client.server_capabilities.documentHighlightProvider then
          vim.cmd([[
            hi! link LspReferenceRead Visual
            hi! link LspReferenceText Visual
            hi! link LspReferenceWrite Visual
          ]])

          local gid = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
          vim.api.nvim_create_autocmd("CursorHold", {
            group = gid,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.document_highlight()
            end,
          })

          vim.api.nvim_create_autocmd("CursorMoved", {
            group = gid,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.clear_references()
            end,
          })
        end
        if tools.is_plugin_installed("snacks.nvim") == true then
          local Snacks = require("snacks")
          Snacks.notify("[lsp] snacks plugin is installed !!!")
          map("n", "gd", function() Snacks.picker.lsp_definitions() end, {desc = "Goto Definition"} )
          map("n", "gD", function() Snacks.picker.lsp_declarations() end, {desc = "Goto Declaration"} )
          map("n", "gr", function() Snacks.picker.lsp_references() end, {nowait = true, desc = "References"} )
          map("n", "gI", function() Snacks.picker.lsp_implementations() end, {desc = "Goto Implementation"} )
          map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" } )
          map("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, {desc = "LSP Symbols"} )
          map("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, {desc = "LSP Workspace Symbols"} )
        end
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

      -- Change diagnostic signs.
      vim.fn.sign_define("DiagnosticSignError", { text = "🆇", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = "⚠️", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = "ℹ️", texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

      -- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })
    end,
  }
  return data
end

return M
