local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
        'nvimtools/hydra.nvim',
    },
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
  }
  return data
end

return M
