return {
  'zaldih/themery.nvim',
  lazy = false,
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