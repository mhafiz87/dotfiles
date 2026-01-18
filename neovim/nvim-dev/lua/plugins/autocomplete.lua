local trigger_text = ";"
local sources_list = { 'lsp', 'path', 'snippets', 'buffer' }
local lazydev_exist, _ = pcall(require, "lazydev")
local copilot_exist, _ = pcall(require, "copilot")
if copilot_exist then
  table.insert(sources_list, 1, "copilot")
end
if lazydev_exist then
  table.insert(sources_list, 1, "lazydev")
end

return {
  enabled = true,
  "saghen/blink.cmp",
  -- use a release tag to download pre-built binaries
  version = '1.*',
  event = { "InsertEnter", "CmdlineEnter" },
  -- optional: provides snippets for the snippet source
  dependencies = {
    {
      "saghen/blink.compat",
      opts = { enable_events = true }
    },
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
    "fang2hou/blink-copilot",
  },
  opts = {
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
    sources = {
      default = sources_list,
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 1000,
          async = true,
        },
      },
    }
  }
}