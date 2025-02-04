local global = require("global")
local M = {}
local build = ""
if global.is_windows then
  build =
  "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
elseif global.is_linux then
  build = "make"
end


---comment
---@param args any
---@return table
function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    enabled = args.enable,
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = build,
      },
      'nvim-telescope/telescope-ui-select.nvim',
      "radyz/telescope-gitsigns"
    },

    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          scroll_strategy = "limit",
          layout_strategy = "horizontal",
          sorting_strategy = "ascending",
          color_devicons = true,
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.7,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.85,
            height = 0.92,
            preview_cutoff = 120,
          },
          file_ignore_pattern = { "%.dll", "%.pyd" },
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
        pickers = {
          find_files = {
            hidden = true,
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--glob=!**/.git/*",
              "--glob=!**/.idea/*",
              "--glob=!**/.vscode/*",
              "--glob=!**/build/*",
              "--glob=!**/dist/*",
              "--glob=!**/yarn.lock",
              "--glob=!**/package-lock.json",
            },
          }
        },
        extensions = {
          ["fzf"] = {
            undo = {
              side_by_side = true,
              layout_strategy = "vertical",
              layout_config = {
                preview_height = 0.8,
              },
            },
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
          },
        },
      })

      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("git_signs")

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
      vim.keymap.set("n", "<leader>fgh", "<cmd>Telescope git_signs<cr>",
        { desc = "[f]ind [g]it [h]unk", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<CR>",
        { desc = "List current buffer diagnostics", noremap = true, silent = true }) -- show  diagnostics for file
    end
  }
  return data
end

return M
