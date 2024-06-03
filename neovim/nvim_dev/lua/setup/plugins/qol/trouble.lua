local M = {}

function M.init (args)
  setmetatable(args, {__index={enable=true}})
  local data = {
    enabled = args.enable,
    "folke/trouble.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
      require("trouble").setup({})
      vim.keymap.set("n", "<leader>tr", "<cmd>TroubleToggle<cr>", { desc = "[t]oggle t[r]ouble"})
    end
  }
  return data
end

return M

