local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local tools = require("tools")
  if not tools.is_plugin_installed("telescope.nvim") then
    return {}
  end
  local data = {
    enabled = args.enable,
    "rachartier/tiny-code-action.nvim",
    dependencies = {
        {"nvim-lua/plenary.nvim"},
        {"nvim-telescope/telescope.nvim"},
    },
    event = "LspAttach",
    config = function()
        require('tiny-code-action').setup()
    end
  }
  return data
end

return M


