local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "tzachar/local-highlight.nvim",
    event = {"BufReadPost", "BufNewFile"},
    config = function()
      require("local-highlight").setup()
    end
  }
  return data
end

return M
