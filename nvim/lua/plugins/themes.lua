return {
    enabled = true,
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
        -- vim.cmd.colorscheme("rose-pine")
        require("rose-pine").setup({
          highlight_groups = {
            Cursor = { fg = "#fcf0ea", bg = "#fcf0ea" },
          },
        })
        vim.cmd [[colorscheme rose-pine]]
    end
}
