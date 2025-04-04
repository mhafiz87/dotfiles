local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    event = "BufReadPost",
    "nvim-colortils/colortils.nvim",
    cmd = "Colortils",
    config = function()
      require("colortils").setup({

      })
    end
  }
  return data
end

return M

