local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    'echasnovski/mini.surround',
    event = "VeryLazy",
    version = false,
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = '<leader>ra',            -- Add surrounding in Normal and Visual modes
          delete = '<leader>rd',         -- Delete surrounding
          find = '<leader>rf',           -- Find surrounding (to the right)
          find_left = '<leader>rF',      -- Find surrounding (to the left)
          highlight = '<leader>rh',      -- Highlight surrounding
          replace = '<leader>rr',        -- Replace surrounding
          update_n_lines = '<leader>rn', -- Update `n_lines`
        },
      })
    end
  }
  return data
end

return M