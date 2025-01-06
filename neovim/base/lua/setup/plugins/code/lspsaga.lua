local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional lspsaga
      "nvim-tree/nvim-web-devicons", -- optional lspsaga
    },
    event = "VeryLazy",
    config = function()
      require("lspsaga").setup({
        symbol_in_winbar = {  -- breadcrumbs
          enable = false,
        },
        lightbulb = {
          enable = true,
          sign = false,
          virtual_text = true,
          debounce = 10,
          sign_priority = 40,
        },
        outline = {
          auto_preview = false, -- default to true
          close_after_jump = false, -- default to true
          detail = false, -- default to true
          layout = "normal", -- default to normal
          max_height = 0.9, -- default to 0.9
          left_width = 0.3, -- default to 0.3
        },
        finder = {
          left_width = 0.3,
          right_width = 0.7,
          layout = "float",
        },
      })
      vim.keymap.set("n", "<S-k>", "<cmd>Lspsaga hover_doc<cr>", { desc = "Show documentation", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>lca", "<cmd>Lspsaga code_action<cr>", { desc = "List code action", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>ldn", "<cmd>Lspsaga diagnostic_jump_next<cr>", { desc = "Jump to next diagnostic", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>ldp", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { desc = "Jump to previous diagnostic", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>ls", "<cmd>Lspsaga outline<cr>", { desc = "List symbols using LSP saga", noremap = true, silent = true })
      vim.keymap.set("n", "gd", "<cmd>Lspsaga finder def+ref+imp<cr>", { desc = "List references and implementation", noremap = true, silent = true })
    end
  }
  return data
end

return M
