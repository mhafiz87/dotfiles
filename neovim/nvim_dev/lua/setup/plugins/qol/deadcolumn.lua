local M = {}

function M.init (args)
  setmetatable(args, {__index={enable=true}})
  local data = {
    enabled = args.enable,
    "Bekaboo/deadcolumn.nvim",
    event = "BufReadPost",
    config = function ()
      require("deadcolumn").setup({
        scope = "line", -- Default to "line"
        modes = { "n", "i", "ic", "ix", "R", "Rc", "Rx", "Rv", "Rvc", "Rvx" },
        blending = {
            threshold = 0.1,
            colorcode = '#000000',
            hlgroup = { 'Normal', 'bg' },
        },
        warning = {
            alpha = 0.4,
            offset = 0,
            colorcode = '#FF0000',
            hlgroup = { 'Error', 'bg' },
        },
      })
    end
  }
  return data
end

return M

