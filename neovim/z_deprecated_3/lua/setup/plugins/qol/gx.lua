local M = {}

function M.init (args)
  setmetatable(args, {__index={enable=true}})
  local data = {
    enabled = args.enable,
    "chrishrb/gx.nvim",
    event = "VeryLazy",
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    submodules = false, -- not needed, submodules are required only for tests
    config = function()
      require("gx").setup({})
      vim.keymap.set({ "n", "x" }, "gx", "<cmd>Browse<cr>", { desc = "Browse link in browser", noremap = true, silent = true })
    end,
  }
  return data
end

return M

