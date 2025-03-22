local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    event = "InsertEnter",
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets',
      {"saghen/blink.compat", opts = {enable_events = true}},
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      {
        "monkoose/neocodeium",
        event = "VeryLazy",
      },
    },
    version = '*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true
          }
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          },
        },
        menu = {
          border = "rounded",
          -- true to automatically show the completion menu
          auto_show = true,

          -- nvim-cmp style menu
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", "source_name", gap = 1 }
            },
          }
        },
        -- Show documentation when selecting a completion item
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "rounded",
          },
        },

        -- Display a preview of the selected item on the current line
        ghost_text = { enabled = true },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
        },
      },
      keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show_and_insert', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<Esc>'] = { 'cancel', 'fallback' },
        ['<Enter>'] = { 'select_and_accept', 'fallback' },

        ['<C-y>'] = { 'select_and_accept' },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev' },
        ['<C-n>'] = { 'select_next' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },
      cmdline = {
        completion = {
          menu = {
            auto_show = true
          }
        },
        keymap = {
          preset = "cmdline",
          -- ['<C-e>'] = { 'hide' },
          -- ['<Esc>'] = { 'cancel', 'fallback' },
          -- ['<Enter>'] = { 'select_and_accept', 'fallback' },
          -- ['<C-y>'] = { 'select_and_accept' },
          -- ['<Up>'] = { 'select_prev', 'fallback' },
          -- ['<Down>'] = { 'select_next', 'fallback' },
          -- ['<C-p>'] = { 'select_prev' },
          -- ['<C-n>'] = { 'select_next' },
          -- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
          -- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
          -- ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
          -- ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        }
      },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
          lsp = {
            name = "lsp",
            module = "blink.cmp.sources.lsp",
            score_offset = 99,
          },
          path = {
            name = "path",
            module = "blink.cmp.sources.path",
            score_offset = 98,
          },
          buffer = {
            name = "buffer",
            module = "blink.cmp.sources.buffer",
            score_offset = 97,
          },
          snippets = {
            name = "snippets",
            module = "blink.cmp.sources.snippets",
            score_offset = 96,
          },
        }
      },
    },
    opts_extend = { "sources.default" },
    config = function (_, opts)
      local neocodeium = require("neocodeium")
      local blink = require("blink.cmp")
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        callback = function()
          neocodeium.clear()
        end,
      })
      neocodeium.setup({
        filter = function()
          return not blink.is_visible()
        end,
      })
      vim.keymap.set("i", "<A-f>", function()
          require("neocodeium").accept()
      end)
      vim.keymap.set("i", "<A-w>", function()
          require("neocodeium").accept_word()
      end)
      vim.keymap.set("i", "<A-a>", function()
          require("neocodeium").accept_line()
      end)
      vim.keymap.set("i", "<A-e>", function()
          require("neocodeium").cycle_or_complete()
      end)
      vim.keymap.set("i", "<A-r>", function()
          require("neocodeium").cycle_or_complete(-1)
      end)
      vim.keymap.set("i", "<A-c>", function()
          require("neocodeium").clear()
      end)
      require("blink.compat").setup({})
      blink.setup(opts)
    end
  }
  return data
end

return M

