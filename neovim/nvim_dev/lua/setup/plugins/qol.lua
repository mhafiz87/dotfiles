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
    end,
  },

  -- surround
  {
    'echasnovski/mini.surround',
    event = "VeryLazy",
    version = false,
    config = function ()
      require("mini.surround").setup({})
    end
  },

  -- file explorer
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({ })
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
        "<leader>s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "<leader>S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "<leader>r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "<leader>R",
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

