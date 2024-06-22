local M = {}

function M.init (args)
  setmetatable(args, {__index={enable=true}})
  local data = {
    enabled = args.enable,
    "stevearc/oil.nvim",
    config = function ()
      require("oil").setup({
        view_options = {
          show_hidden = true,
        },
      })
      vim.keymap.set("n", "-", "<cmd>Oil<cr>", { noremap = true, desc = "which_key_ignore", silent = true})
    end,
  }
  return data
end

return M

