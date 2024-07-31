local M = {}

function M.init (args)
  setmetatable(args, {__index={enable=true}})
  local data = {
    enabled = args.enable,
    "tpope/vim-fugitive",
    event = "VeryLazy",
  }
  return data
end

return M

