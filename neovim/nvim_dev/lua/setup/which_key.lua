which_key = require("which-key")
which_key.register({
  -- Base
  -- Map Esc to 
  j = { mode = "i", k = { "<Esc>", "which_key_ignore" }},
  -- Exit terminal mode
  j = { mode = "t", k = { "<C-\\><C-n>" , "which_key_ignore" }},
  -- Keep cursor in middle when moving half a screen
  ["<c-d>"] = { "<c-d>zz", "which_key_ignore"},
  ["<c-u>"] = { "<c-u>zz", "which_key_ignore"},
  -- Keep search term in the middle of the screen
  n = { "nzzzv", "which_key_ignore" },
  N = { "Nzzzv", "which_key_ignore" },
  -- Keep cursor in the column 0 when [J]oining line below with current one
  J = { mode = "n", k = { "mzJ`z", "which_key_ignore" }},
  -- Move current line with context aware
  J = { mode = "v", k = { ":m '>+1<CR>gv=gv", "which_key_ignore" }},
  K = { mode = "v", k = { ":m '<-2<CR>gv=gv", "which_key_ignore" }},

  -- Buffers Controls
  ["<leader>b"] = {
    name = "+buffer controls",
    b = { "<cmd>e #<cr>", "[b]uffer switch with previous"},
    -- Reference "https://tech.serhatteker.com/post/2020-06/close-all-buffers-but-current-in-vim/"
    d = { "<cmd>%bd|e#|bd#<cr>", "[d]elete other buffers"},
    n = { "<cmd>bnext<cr>", "[b]uffer [n]ext"},
    p = { "<cmd>bprevious<cr>", "[b]uffer [p]revious"},
  },

  -- Don't copy replaced text after pasting
  p = { mode = "v", {'"_dP', "which_key_ignore"}},

  -- Indent multiple times
  [">"] = { mode = "v", {">gv", "which_key_ignore"}},
  ["<"] = { mode = "v", {"<gv", "which_key_ignore"}},

  -- Window
  ["<c-up>"] = { "<cmd>resize +2<cr>", "Increase window height by 2" },
  ["<c-down>"] = { "<cmd>resize -2<cr>", "Decrease window height by 2" },
  ["<c-left>"] = { "<cmd>vertical resize -2<cr>", "Increase window width by 2" },
  ["<c-right>"] = { "<cmd>vertical resize +2<cr>", "Decrease window width by 2" },
  
  -- Find files/themes/buffer using telescope
  ["<leader>f"] = {
    mode = "n",
    name = "+find (files/themes/buffer)",
    b = { "<cmd>Telescope buffers<cr>", "[f]ind file in [b]uffers" },
    f = { "<cmd>Telescope find_files<cr>", "[f]ind [f]ile" },
    g = { require("telescope.builtin").git_files, "[f]ind file in [g]it repo"},
    r = { "<cmd>Telescope oldfiles<cr>", "[f]ind [r]ecent file" },
    s = { "<cmd>Telescope live_grep<cr>", "[f]ind [s]tring in current working directory"},
    t = { "<cmd>Themery<cr>", "[f]ind [t]hemes"},
  },
})
