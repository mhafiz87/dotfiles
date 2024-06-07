local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
    config = function()
      require("markdown").setup({

      })
    end
  }
  return data
end

return M
