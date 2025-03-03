local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
    config = function()
      require("markdown").setup({
        on_attach = function(bufnr)
          local function toggle(key)
            return "<Esc>gv<Cmd>lua require'markdown.inline'"
                .. ".toggle_emphasis_visual'" .. key .. "'<CR>"
          end
          vim.keymap.set("n", "<leader>mci", "<cmd>MDInsertToc<cr>", { desc = "Insert table of content", buffer = bufnr })
          vim.keymap.set("n", "<leader>mcl", "<cmd>MDToc<cr>", { desc = "View table of content content", buffer = bufnr })
          vim.keymap.set("n", "<leader>mtt", "<cmd>MDTaskToggle<cr>", { desc = "Toggle task", buffer = bufnr })
          vim.keymap.set("x", "<leader>mtt", ":TaskToggle<cr>", { desc = "Toggle task", buffer = bufnr })
          vim.keymap.set("x", "<c-b>", toggle("b"), { buffer = bufnr })
          vim.keymap.set("x", "<c-i>", toggle("i"), { buffer = bufnr })
          vim.keymap.set("x", "<c-s>", toggle("s"), { buffer = bufnr })
          vim.keymap.set("x", "<c-c>", toggle("c"), { buffer = bufnr })
        end
      })
    end
  }
  return data
end

return M
