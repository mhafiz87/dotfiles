local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "echasnovski/mini.align",
    version = "*",
    config = function()
      require("mini.align").setup({})
    end,
  }
  return data
end

return M
