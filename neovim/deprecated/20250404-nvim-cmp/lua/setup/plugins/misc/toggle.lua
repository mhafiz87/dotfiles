local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "gregorias/toggle.nvim",
    config = function()
      require("toggle").setup()
    end
  }
  return data
end

return M

