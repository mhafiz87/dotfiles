-- References:
-- 1. https://www.youtube.com/watch?v=tdhxpn1XdjQ
-- 2. https://github.com/mplusp/minimal-nvim-0.11-lsp-setup
-- 3. https://www.youtube.com/watch?v=IZnhl121yo0
-- 4. https://github.com/adibhanna/minimal-vim
-- 5. https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- 6. https://github.com/adibhanna/nvim/blob/08642120e45f63d7f07dc1977df80e8213440172/lua/core/lsp.lua

-- auto populate lsp
local lsp_list = {}
local lsp_directory = vim.fn.expand("~/.config/neovim/nvim-min/lsp")
local lsp_files_dir = vim.fn.readdir(lsp_directory)

if lsp_files_dir then
  for _, item_name in ipairs(lsp_files_dir) do
    local lsp = string.gsub(item_name, ".lua", "")
    table.insert(lsp_list, lsp)
  end
end

vim.lsp.enable(lsp_list)

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

