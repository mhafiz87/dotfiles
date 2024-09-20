local M = {}

function M.init (args)
  setmetatable(args, {__index={enable=true}})
  local data = {
    enabled = args.enable,
    "nvim-tree/nvim-tree.lua",
    config = function ()
      require("nvim-tree").setup({
        actions = {
          open_file = {
            quit_on_open = true
          }
        }
      })
      vim.keymap.set("n", "<leader>fe", "<CMD>NvimTreeToggle<CR>", { desc = "[F]ile [E]xplorer" })
    end
  }
  return data
end

return M
