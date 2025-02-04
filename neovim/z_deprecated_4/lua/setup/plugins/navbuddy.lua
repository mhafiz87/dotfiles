local M = {}

function M.init (args)
  setmetatable(args, {__index={enable=true}})
  local data = {
    enabled = args.enable,
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
      "numToStr/Comment.nvim", -- Optional
      "nvim-telescope/telescope.nvim", -- Optional
    },
    opts = { lsp = { auto_attach = true } },
  }
  return data
end

return M

