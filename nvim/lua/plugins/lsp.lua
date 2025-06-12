-- References:
-- https://github.com/jdhao/nvim-config/blob/main/lua/config/lsp.lua

local utils = require("utils")
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "j-hui/fidget.nvim", -- to show LSP progress
  },
  event = "BufReadPre",
  config = function()
    require("fidget").setup()
    local snacks_exist, snacks = pcall(require, "snacks")
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp_buf_conf", { clear = true }),
      callback = function(event_context)
        local client = vim.lsp.get_client_by_id(event_context.data.client_id)
        -- vim.print(client.name, client.server_capabilities)

        if not client then
          return
        end

        local bufnr = event_context.buf

        -- Mappings.
        local map = function(mode, l, r, opts)
          opts = opts or {}
          opts.silent = true
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map( "n", "K", function() vim.lsp.buf.hover { border = "rounded", max_height = 25, max_width = 120 } end, { desc = "show do[K]umentation" })
        if (snacks_exist) then
          map( "n", "gd", function() snacks.picker.lsp_definitions() end, { desc = "[g]o to [d]efinition" })
          map("n", "gD", function() snacks.picker.lsp_declarations() end, {desc = "[g]o to [D]eclaration"} )
          map("n", "gr", function() snacks.picker.lsp_references() end, {nowait = true, desc = "[g] to [r]eferences"} )
          map("n", "gI", function() snacks.picker.lsp_implementations() end, {desc = "[g]o to [I]mplementation"} )
          map("n", "gy", function() snacks.picker.lsp_type_definitions() end, { desc = "[g]o to t[y]pe definition" } )
          map("n", "<leader>ss", function() snacks.picker.lsp_symbols() end, {desc = "[s]how [s]ymbols"} )
          map("n", "<leader>sS", function() snacks.picker.lsp_workspace_symbols() end, {desc = "[s]how workspace [S]ymbols"} )
        end
        -- The blow command will highlight the current variable and its usages in the buffer.
        if client.server_capabilities.documentHighlightProvider then
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
      end,
      nested = true,
      desc = "Configure buffer keymap and behavior based on LSP",
    })

    local capabilities = utils.get_default_capabilities()

    vim.lsp.config("*", {
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 500,
      },
    })

    -- A mapping from lsp server name to the executable name
    local enabled_lsp_servers = {
      basedpyright = "basedpyright-langserver",
      ruff = "ruff",
      lua_ls = "lua-language-server",
      yamlls = "yaml-language-server",
      taplo = "taplo"
      -- ltex = "ltex-ls",
      -- clangd = "clangd",
      -- vimls = "vim-language-server",
      -- bashls = "bash-language-server",
      -- yamlls = "yaml-language-server",
    }

    for server_name, lsp_executable in pairs(enabled_lsp_servers) do
      if utils.executable(lsp_executable) then
        vim.lsp.enable(server_name)
      else
        local msg = string.format(
          "Executable '%s' for server '%s' not found! Server will not be enabled",
          lsp_executable,
          server_name
        )
        vim.notify(msg, vim.log.levels.WARN, { title = "Nvim-config" })
      end
    end
  end,
}
