local M = {}

function M.init (args)
  setmetatable(args, {__index={enable=true}})
  local data = {
    enabled = args.enable,
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPost",
    config = function ()
      require("colorizer").setup({})
    end
  }
  return data
end

return M
