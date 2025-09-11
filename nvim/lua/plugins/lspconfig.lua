return {
  enabled = true,
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
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
  config = function()
    local lsp_list = { "lua_ls", "basedpyright", "ruff", "marksman", "taplo" , "bashls"}
    for index = 1, #lsp_list do
      vim.lsp.enable(lsp_list[index])
    end
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp_buf_conf", { clear = true }),
      callback = function(event_context)
        local client = vim.lsp.get_client_by_id(event_context.data.client_id)
        -- vim.print(client.name, client.server_capabilities)

        if not client then
          return
        end

        local bufnr = event_context.buf

        -- The below command will highlight the current variable and its usages in the buffer.
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
  end,
}
