local M = {}

function M.init (args)
  setmetatable(args, {__index={enable=true}})
  local data = {
    enabled = args.enable,
    "echasnovski/mini.align",
    event = { "VeryLazy", "BufEnter" },
    version = false,
    config = function()
      local align = require("mini.align")
      align.setup()
    end,
  }
  return data
end

return M

