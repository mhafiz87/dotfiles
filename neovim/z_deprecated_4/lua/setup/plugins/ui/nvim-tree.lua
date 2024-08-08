local M = {}

function M.init (args)
  setmetatable(args, {__index={enable=true}})
  local data = {
    enabled = args.enable,
    "nvim-tree/nvim-tree.lua",
    config = function ()
      require("nvim-tree").setup({})
      vim.keymap.set("n", "<C-k><C-b>", "<CMD>NvimTreeToggle<CR>", { desc = "Toggle Nvim Tree" })
    end
  }
  return data
end

return M
