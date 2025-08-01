-- References:
-- 1. https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/blink-cmp.lua


local trigger_text = ";"

return {
  enabled = true,
  'saghen/blink.cmp',
  event = {"InsertEnter", "CmdlineEnter"},
  -- optional: provides snippets for the snippet source
  dependencies = {
    'rafamadriz/friendly-snippets',
    'hrsh7th/cmp-cmdline',
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
        },
        ghost_text = { enabled = true },
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          },
        }
      },
      keymap = {
        ['<Tab>'] = {
          function(cmp)
            if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then return cmp.accept() end
          end,
          'show_and_insert',
          'select_next',
        },
        ['<S-Tab>'] = { 'show_and_insert', 'select_prev' },

        ['<C-space>'] = { 'show', 'fallback' },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<Right>'] = { 'select_next', 'fallback' },
        ['<Left>'] = { 'select_prev', 'fallback' },

        ['<C-y>'] = { 'select_and_accept' },
        ['<C-e>'] = { 'cancel' },
      }
    },
    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'cmdline' },
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
        -- https://github.com/linkarzu/dotfiles-latest/blob/a12375c8b4976efc23454f5c15473277c1d277ed/neovim/neobean/lua/plugins/blink-cmp.lua#L91 ⤵
        snippets = {
          name = "snippets",
          module = "blink.cmp.sources.snippets",
          score_offset = 96,
          -- Only show snippets if I type the trigger_text characters, so
          -- to expand the "bash" snippet, if the trigger_text is ";" I have to
          should_show_items = function()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
            -- NOTE: remember that `trigger_text` is modified at the top of the file
            return before_cursor:match(trigger_text .. "%w*$") ~= nil
          end,
          transform_items = function(_, items)
            local line = vim.api.nvim_get_current_line()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = line:sub(1, col)
            local start_pos, end_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
            if start_pos then
              for _, item in ipairs(items) do
                if not item.trigger_text_modified then
                  ---@diagnostic disable-next-line: inject-field
                  item.trigger_text_modified = true
                  item.textEdit = {
                    newText = item.insertText or item.label,
                    range = {
                      start = { line = vim.fn.line(".") - 1, character = start_pos - 1 },
                      ["end"] = { line = vim.fn.line(".") - 1, character = end_pos },
                    },
                  }
                end
              end
            end
            return items
          end,
        },
        cmdline = {
          name = "cmdline",
          module = "blink.compat.source",
          score_offset = 95,
          enabled = function ()
            return vim.fn.getcmdtype() == ":"
          end
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
    end, {desc="[neocodeium] accept"})
    vim.keymap.set("i", "<A-w>", function()
        require("neocodeium").accept_word()
    end, {desc="[neocodeium] accept word"})
    vim.keymap.set("i", "<A-a>", function()
        require("neocodeium").accept_line()
    end, {desc="[neocodeium] accept line"})
    vim.keymap.set("i", "<A-e>", function()
        require("neocodeium").cycle_or_complete()
    end, {desc="[neocodeium] cycle or complete"})
    vim.keymap.set("i", "<A-r>", function()
        require("neocodeium").cycle_or_complete(-1)
    end, {desc="[neocodeium] cycle or complete"})
    vim.keymap.set("i", "<A-c>", function()
        require("neocodeium").clear()
    end, {desc="[neocodeium] clear"})
    require("blink.compat").setup({})
    blink.setup(opts)
  end
}
