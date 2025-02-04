local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "DNLHC/glance.nvim",
    config = function()
      require("glance").setup({})
    end,
  }
  return data
end

return M
