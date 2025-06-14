return {
  enabled = false,
  'echasnovski/mini.clue',
  version = '*',
  config = function ()
    local miniclue = require('mini.clue')
    miniclue.setup({
      window = {
        delay = 0,
        config = {
          width = "auto"
        }
      },
      triggers = {
        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },

        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },

        -- Window commands
        { mode = 'n', keys = '<C-w>' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },

        -- git hunk
        { mode = 'n', keys = '<leader>g' },
      },

      clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
        -- Git Hunk
        { mode = "n", keys = "<leader>ghp", postkeys = "<leader>gh" },
        { mode = "n", keys = "<leader>ghn", postkeys = "<leader>gh" },
        { mode = "n", keys = "<leader>ghr", postkeys = "<leader>gh" },
        -- LSP
        { mode = "n", keys = "gr", desc = "[g]o to [r]eferences"},
      },
    })
  end
}