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
        opts.desc = "[l]sp toggle [i]nlay hint"
        map("n", "<leader>lih", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr })
        end, opts)

        opts.desc = "[l]sp [g]o to [d]efinitions (Telescope)"
        map("n", "<leader>lgd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "[l]sp [g]o to [r]eferences (Telescope)"
        map("n", "<leader>lgr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "[l]sp [g]o to [i]mplementations (Telescope)"
        map("n", "<leader>lgi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "[l]sp show do[k]umentation under cursor"
        map("n", "<leader>lk", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "[l]sp show [d]iagnostic for current [l]ine"
        map("n", "<leader>ldl", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "[lsp] show [d]iagnostics for current [b]uffer (Telescope)"
        map("n", "<leader>ldb", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "[l]sp [c]ode [a]ctions"
        if tools.is_plugin_installed("tiny-code-action.nvim") then
          map({ "n", "v" }, "<leader>lca", function()
            require("tiny-code-action").code_action()
          end, opts) -- see available code actions, in visual mode will apply to selection
        else
          map({ "n", "v" }, "<leader>lca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
        end

        opts.desc = "[l]sp [r]e[n]ame"
        map("n", "<leader>lrn", vim.lsp.buf.rename, opts) -- smart rename
      end
      vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(vim.lsp.status(), "info", {
            id = "lsp_progress",
            title = "LSP Progress",
            opts = function(notif)
              notif.icon = ev.data.params.value.kind == "end" and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })
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
