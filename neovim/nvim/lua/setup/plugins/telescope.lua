local M = {}

---comment
---@param args any
---@return table
function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    enabled = args.enable,
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
    },

    config = function()
      local actions = require("telescope.actions")

      require("telescope").setup({
        defaults = {
          path_display = { "truncate" },
          mappings = {
            n = {
              ["<C-d>"] = actions.delete_buffer,
            },
            i = {
              ["<C-k>"] = actions.move_selection_previous, -- move to prev result
              ["<C-j>"] = actions.move_selection_next,     -- move to next result
              ["<C-u>"] = actions.preview_scrolling_down,  -- move to next result
              ["<C-i>"] = actions.preview_scrolling_up,    -- move to next result
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-d>"] = actions.delete_buffer,
              ["<C-h>"] = actions.which_key,
            },
          },
        },
        extensions = {
          "fzf",
          {
            undo = {
              side_by_side = true,
              layout_strategy = "vertical",
              layout_config = {
                preview_height = 0.8,
              },
            },
          },
        },
      })

      require("telescope").load_extension("fzf")

      vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>",
        { desc = "[f]ind file in [b]uffers", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>",
        { desc = "[f]ind [f]ile", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fgf", "<cmd>Telescope git_files<cr>",
        { desc = "[f]ind file in [g]it repo", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",
        { desc = "[f]ind [r]ecent file", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>",
        { desc = "[f]ind [s]tring in current working directory", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fgs", require("telescope.builtin").git_status,
        { desc = "[f]ind [g]it [s]tatus", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fgc", require("telescope.builtin").git_commits,
        { desc = "[f]ind [g]it [c]ommits", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fgb", require("telescope.builtin").git_branches,
        { desc = "[f]ind [g]it [b]ranches", noremap = true, silent = true })
    end
  }
  return data
end

return M
