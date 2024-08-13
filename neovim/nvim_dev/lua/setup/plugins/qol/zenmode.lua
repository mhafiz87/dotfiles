local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        window = {
          width = 150,
        },
        options = {
          signcolumn = "true", -- disable signcolumn
          number = true, -- disable number column
          relativenumber = true, -- disable relative numbers
          cursorline = true, -- disable cursorline
          cursorcolumn = true, -- disable cursor column
          foldcolumn = "999", -- disable fold column
          list = true, -- disable whitespace characters
        },
        plugins = {
          options = {
            ruler = true,
            showcmd = true,
            laststatus = 3,
          },
          gitsigns = { enabled = false }, -- False to enable gitsigns
          todo = { enabled = false }, -- False to enable todo highlight
        },
      })
    end,
  }
  return data
end

return M
