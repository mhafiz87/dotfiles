return {
  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local lualine = require("lualine")
      local lazy_status = require("lazy.status") -- to configure lazy pending updates count
      lualine.setup({
        options = {
          theme = "auto",
        },
        sections = {
          lualine_c = {
            {
              -- Customize the filename part of lualine to be parent/filename
              "filename",
              file_status = true, -- Displays file status (readonly status, modified status)
              newfile_status = false, -- Display new file status (new file means no write after created)
              path = 4, -- 0: Just the filename
              -- 1: Relative path
              -- 2: Absolute path
              -- 3: Absolute path, with tilde as the home directory
              -- 4: Filename and parent dir, with tilde as the home directory
              symbols = {
                modified = "[+]", -- Text to show when the file is modified.
                readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
              },
            },
          },
          lualine_x = {
            { "encoding" },
            { "fileformat" },
            { "filetype" },
          },
        },
      })
    end,
  },

  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    },
    config = function()
      local api = require("nvim-tree.api")
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, noremap = true, silent = true, nowait = true }
      end
      require("nvim-tree").setup({
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
        view = {
          number = true,
          relativenumber = true,
        },
        update_focused_file = {
          enable = true,
        },
        git = {
          enable = true,
          timeout = 5000,
        },
      })
      vim.keymap.set("n", "<leader>fe", api.tree.toggle, opts("Toggle [f]ile [e]xplorer"))
    end,
  },

  -- Windows Buffer
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    config = function()
      require("bufferline").setup({
        options = {
          themable = True,
        },
      })
      vim.keymap.set("n", "<S-h>", "<CMD>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
      vim.keymap.set("n", "<S-l>", "<CMD>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    end,
  },

  -- Terminal Advance
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })
      vim.keymap.set("n", "<leader>tt", "<CMD>ToggleTerm<CR>", { desc = "[t]oggle [t]erminal" })
    end,
  },
}
