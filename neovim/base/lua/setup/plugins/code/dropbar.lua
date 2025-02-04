local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "bekaboo/dropbar.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      require("dropbar").setup({})
      vim.keymap.set("n", "<leader>wb", require("dropbar.api").pick, { desc = "Winbar navigation", noremap = true, silent = true })
    end,
  }
  return data
end

return M
