local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    'echasnovski/mini.pairs',
    version = '*',
    event = "InsertEnter",
    config = function ()
      require("mini.pairs").setup()
    end,
  }
  return data
end

return M

