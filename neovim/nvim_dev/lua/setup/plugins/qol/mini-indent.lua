local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "echasnovski/mini.indentscope",
    version = false,
    event = "BufEnter",
    config = function()
      require("mini.indentscope").setup({
        draw = { animation = require("mini.indentscope").gen_animation.none() },
        symbol = "│",
        options = { try_as_border = true },
      })
    end,
  }
  return data
end

return M