local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "HiPhish/rainbow-delimiters.nvim",
    config = function ()
      require("rainbow-delimiters.setup").setup({

      })
    end
  }
  return data
end

return M

