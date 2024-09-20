local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    keys = { { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" } },
    config = function()
      require("undotree").setup({
        window = { winblend = 0 },
      })
    end,
  }
  return data
end

return M
