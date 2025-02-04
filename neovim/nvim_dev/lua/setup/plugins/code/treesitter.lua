local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    {
      enabled = args.enable,
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = "BufReadPre",
      config = function()
        require'nvim-treesitter.configs'.setup {
          ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
          -- Install parsers synchronously (only applied to `ensure_installed`)
          sync_install = false,

          -- Automatically install missing parsers when entering buffer
          -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
          auto_install = true,
          highlight = {
            enable = true,
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            additional_vim_regex_highlighting = false,
          },
        }
      end,
    },
    {
      enabled = args.enable,
      "nvim-treesitter/nvim-treesitter-context",
      event = { "BufReadPost", "BufNewFile" },
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("treesitter-context").setup({
          max_lines = 5,
        })
      end,
    },
    {
      enabled = args.enable,
      "nvim-treesitter/nvim-treesitter-textobjects",
      event = { "BufReadPost", "BufNewFile" },
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      config = function ()
        local ntt = require("nvim-treesitter.textobjects.move")
        vim.keymap.set(
          "n", "]-", function ()
            ntt.goto_next_start("@function.outer")
            vim.cmd(":sleep 100m")
            vim.cmd("norm! zz")
          end,
          { desc = "Go to next function", noremap = true, silent = true }
        )
        vim.keymap.set(
          "n", "[-", function ()
            ntt.goto_previous_start("@function.outer")
            vim.cmd(":sleep 100m")
            vim.cmd("norm! zz")
          end,
          { desc = "Go to previous function", noremap = true, silent = true }
        )
        vim.keymap.set(
          "n", "}", function ()
            ntt.goto_next_start("@block.outer")
            vim.cmd(":sleep 100m")
            vim.cmd("norm! zz")
          end,
          { desc = "Go to next block", noremap = true, silent = true }
        )
        vim.keymap.set(
          "n", "{", function ()
            ntt.goto_previous_start("@block.outer")
            vim.cmd(":sleep 100m")
            vim.cmd("norm! zz")
          end,
          { desc = "Go to previous block", noremap = true, silent = true }
        )
      end
    }
  }
  return data
end

return M

