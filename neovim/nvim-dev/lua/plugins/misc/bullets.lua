local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "bullets-vim/bullets.vim",
    config = function ()
      vim.g.bullets_delete_last_bullet_if_empty = 1
    end
  }
  return data
end

return M
