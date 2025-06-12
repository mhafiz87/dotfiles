return {
  'zaldih/themery.nvim',
  lazy = false,
  priority = 999,
  dependencies = {
    {
      'folke/tokyonight.nvim',
      priority = 1000,
      opts = {},
    },
    {
      'loctvl842/monokai-pro.nvim',
      priority = 1001,
      opts = {},
    }
  },
  opts = {
    themes = {
      'monokai-pro',
      'tokyonight-night',
    },
    livePreview = true,
  }
}
