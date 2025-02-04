local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "iamcco/markdown-preview.nvim",
    event = "VeryLazy",
    config = function()
      vim.fn["mkdp#util#install"]()
      vim.keymap.set("n", "<leader>md", "<CMD>MarkdownPreviewToggle<CR>")
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = "light"
    end,
  }
  return data
end

return M
