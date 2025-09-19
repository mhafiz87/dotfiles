-- References:
-- 1. https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/blink-cmp.lua

local trigger_text = ";"
local sources_list = { 'lsp', 'path', 'snippets', 'buffer' }
local lazydev_exist, _ = pcall(require, "lazydev")
if lazydev_exist then
  table.insert(sources_list, 1, "lazydev")
end

return {
  enabled = true,
  'saghen/blink.cmp',
  event = { "InsertEnter", "CmdlineEnter" },
  -- optional: provides snippets for the snippet source
  dependencies = {
    { "saghen/blink.compat", opts = { enable_events = true } },
    'hrsh7th/cmp-cmdline',
    'rafamadriz/friendly-snippets',
    "xzbdmw/colorful-menu.nvim",
    {
      enabled = true,
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
  -- use a release tag to download pre-built binaries
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'none',
      -- show/hide/select completion
      ["<C-space>"] = { 'show_and_insert', 'show_documentation', 'hide_documentation'},
      ["<C-e>"] = { 'hide' },
      ["<Esc>"] = { 'cancel', 'fallback' },
      ["<Enter>"] = { 'select_and_accept', 'fallback' },
      ["<C-y>"] = { 'select_and_accept' },
      -- navigate options
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev' },
      ['<C-n>'] = { 'select_next' },
      ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      -- navigate documentation
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },

    appearance = {
      nerd_font_variant = 'normal'  -- 'mono'(default) | 'normal'(Nerd Font)
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = true
        }
      },
      -- 'prefix' will fuzzy match on the text before the cursor
      -- 'full' will fuzzy match on the text before _and_ after the cursor
      -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
      keyword = { range = "full" },
      documentation = {
        auto_show = true
      },
      ghost_text = { enabled = true },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        }
      },
      menu = {
        auto_show = true,
        draw = {
          -- without 'colorful-menu'
          -- columns = {
          --   { "label", "label_description", gap = 1 },
          --   { "kind_icon", "kind", "source_name", gap = 1 }
          -- },
          -- with 'colorful-menu'
          -- We don't need label_description now because label and label_description are already
          -- combined together in label by colorful-menu.nvim.
          columns = {
            { "kind_icon" },
            { "label", "source_name" ,gap = 1 },
          },
          components = {
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
    },
    signature = { enabled = true },
    cmdline = {
      completion = {
        menu = {
          auto_show = true
        },
        ghost_text = { enabled = true },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        }
      },
      keymap = {
        -- navigating options
        ['<Tab>'] = {
          function(cmp)
            if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then return cmp.accept() end
          end,
          'show_and_insert',
          'select_next',
        },
        ['<S-Tab>'] = { 'show_and_insert', 'select_prev' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<Right>'] = { 'select_next', 'fallback' },
        ['<Left>'] = { 'select_prev', 'fallback' },
        -- show|hide|accept completion
        ['<C-space>'] = { 'show', 'fallback' },
        ['<C-y>'] = { 'select_and_accept' },
        ['<C-e>'] = { 'cancel' },
        -- #TODO: WIP
        -- ['<Enter>'] = { 'select_accept_and_enter' },:
        -- ['<Enter>'] = {
        --   function(cmp)
        --     if cmp.is_menu_visible() then
        --       return cmp.select_and_accept()
        --     end
        --   end,
        --   "fallback",
        -- },
      },
      sources = { "buffer", "cmdline" },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = sources_list,
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
        cmdline = {
          name = "cmdline",
          module = "blink.compat.source",
          score_offset = 95,
          enabled = function ()
            return vim.fn.getcmdtype() == ":"
          end
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
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" }
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
