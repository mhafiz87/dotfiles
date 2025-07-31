return {
  {
    enabled = true,
    event = { "InsertEnter", "CmdlineEnter" },
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    version = "*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        nerd_font_variant = 'Nerd Font'
      },
      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
      completion = {
        documentation = { auto_show = true },
        -- auto insert brackets
        accept = { auto_brackets = { enabled = true } },
        -- don't select by default, auto insert on selection
        list = { selection = { preselect = false, auto_insert = true } },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)
    end
  },
}
