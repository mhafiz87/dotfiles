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

        map( "n", "K", function() vim.lsp.buf.hover { border = "rounded", max_height = 25, max_width = 120 } end)
        if (snacks_exist) then
          map( "n", "gd", function() snacks.picker.lsp_definitions() end, { desc = "go to definition" })
        end
      end
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
