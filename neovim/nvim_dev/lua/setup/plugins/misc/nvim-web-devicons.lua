local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "nvim-tree/nvim-web-devicons",
    opts = {}
  }
  return data
end

return M
