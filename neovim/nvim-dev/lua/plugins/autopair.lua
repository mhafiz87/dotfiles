  return{
    {
      enabled = false,
      'echasnovski/mini.pairs',
      version = '*',
      event = "InsertEnter",
      opts = {},
    },
    {
      enabled = true,
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true
    },
  }
