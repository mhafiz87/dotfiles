local M = {}

function M.init (args)
  setmetatable(args, {__index={enable=true}})
  local data = {
    enabled = args.enable,
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    opts = {},
  }
  return data
end

return M

