return {
  -- Show code context at winbar
  -- {
  --   "LunarVim/breadcrumbs.nvim",
  --   dependencies = { "SmiteshP/nvim-navic" },
  --   config = function ()
  --     require("nvim-navic").setup({
  --       lsp = {
  --         auto_attach = true,
  --       },
  --     })
  --     require("breadcrumbs").setup()
  --   end
  -- },
  -- Show code context at winbar
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
    config = function()
      require("barbecue").setup({
        create_autocmd = false, -- prevent barbecue from updating itself automatically
      })

      vim.api.nvim_create_autocmd({
        "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",

        -- include this if you have set `show_modified` to `true`
        -- "BufModifiedSet",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })
    end,
  },

  -- Breadcrumbs navigation
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
      "numToStr/Comment.nvim", -- Optional
      "nvim-telescope/telescope.nvim", -- Optional
    },
    opts = { lsp = { auto_attach = true } },
  },

  -- align functionality
  {
    "echasnovski/mini.align",
    event = { "VeryLazy", "BufEnter" },
    version = false,
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

  -- Autopair
  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local autopair = require("nvim-autopairs")
      autopair.setup({
        check_ts = true,
      })

      local cmp_exist, cmp = pcall(require, "cmp")
      if (cmp_exist) then
        -- import nvim-autopairs completion functionality
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        -- make autopairs and completion work together
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
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

  -- Easier comment/uncomment line
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function ()
      if (vim.version().major == 0 and vim.version().minor < 10)
      then
        require("Comment").setup()
      end
    end,
  },
}

