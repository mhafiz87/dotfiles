-- References:
-- 1. https://www.youtube.com/watch?v=tdhxpn1XdjQ
-- 2. https://github.com/mplusp/minimal-nvim-0.11-lsp-setup
-- 3. https://www.youtube.com/watch?v=IZnhl121yo0
-- 4. https://github.com/adibhanna/minimal-vim

-- TODO: list all files in ../lsp directory and auto enable LSPs

vim.lsp.enable("lua_ls")

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end)
    end
  end,
})
