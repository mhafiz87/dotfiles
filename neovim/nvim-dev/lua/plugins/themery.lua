return {
  'zaldih/themery.nvim',
  lazy = false,
  priority = 999,
  dependencies = {
    {
      'folke/tokyonight.nvim',
      priority = 1000,
      opts = {},
    }
  },
  opts = {
    themes = {
      'tokyonight-night',
    },
    livePreview = true,
  }
}