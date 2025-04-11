local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "chentoast/marks.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("marks").setup({

      })
    end
  }
  return data
end

return M
