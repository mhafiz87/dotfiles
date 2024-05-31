return {
  -- align functionality
  {
     "echasnovski/mini.align",
    event = "VeryLazy",
     version = false,
     event = "BufEnter",
     config = function()
       local align = require("mini.align")
       align.setup()
     end,
  },

  -- open link in browser
  {
    "chrishrb/gx.nvim",
    event = "VeryLazy",
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true, -- default settings
    submodules = false, -- not needed, submodules are required only for tests
    config = function()
      require("gx").setup({})
      vim.keymap.set({ "n", "x" }, "gx", "<cmd>Browse<cr>", { desc = "Browse link in browser", noremap = true, silent = true })
    end,
  },

  -- surround
  {
    'echasnovski/mini.surround',
    event = "VeryLazy",
    version = false,
    config = function ()
      require("mini.surround").setup({
        mappings = {
          add = '<leader>ra', -- Add surrounding in Normal and Visual modes
          delete = '<leader>rd', -- Delete surrounding
          find = '<leader>rf', -- Find surrounding (to the right)
          find_left = '<leader>rF', -- Find surrounding (to the left)
          highlight = '<leader>rh', -- Highlight surrounding
          replace = '<leader>rr', -- Replace surrounding
          update_n_lines = '<leader>rn', -- Update `n_lines`
		},
      })
    end
  },

  -- file explorer
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "which_key_ignore", noremap = true, silent = true })
      })
    end
  },

  -- flash
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {},
    keys = {
      {
        "<leader>hs",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "<leader>hS",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "<leader>hr",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "<leader>hR",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  -- Highlight other uses of the word.
  {
    "tzachar/local-highlight.nvim",
    config = function()
      require("local-highlight").setup()
      vim.api.nvim_create_autocmd("BufRead", {
        pattern = { "*.*" },
        callback = function(data)
          require("local-highlight").attach(data.buf)
        end,
      })
    end,
  },

  -- Visualize indent scope
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = "BufEnter",
    config = function()
      require("mini.indentscope").setup({
        draw = { animation = require("mini.indentscope").gen_animation.none() },
        symbol = "│",
        options = { try_as_border = true },
      })
    end,
  },
}

