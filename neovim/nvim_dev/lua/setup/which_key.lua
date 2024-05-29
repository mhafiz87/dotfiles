which_key = require("which-key")
which_key.register({
  ["<leader>f"] = {
    name = "+find (files/themes/buffer)",
    f = { "<cmd>Telescope find_files<cr>", "[f]ind [f]ile" },
    g = { require("telescope.builtin").git_files, "[f]ind file in [g]it repo"},
    r = { "<cmd>Telescope oldfiles<cr>", "[f]ind [r]ecent file" },
    s = { "<cmd>Telescope live_grep<cr>", "[f]ind [s]tring in current working directory"},
    t = { "<CMD>Themery<CR>", "[f]ind [t]hemes"},
  },
})
