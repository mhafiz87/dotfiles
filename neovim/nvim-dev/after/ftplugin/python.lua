local set = vim.opt_local

local M = {}

-- https://influentcoder.com/posts/nvim-diagnostics/
local nvim_bqf_exist, nvim_bqf = pcall(require, "bqf")

vim.api.nvim_create_namespace("ns_refurb")

function M.Refurb()
    -- Ensure the current buffer is a Python file
    if vim.bo.filetype ~= 'python' then
        vim.api.nvim_echo({{"[Refurb} Not a Python file.", "WarningMsg"}}, false, {})
        return
    end

    local refurb_qf_list = {}

    local filepath = vim.api.nvim_buf_get_name(0)
    local lines = {}
    local check_refurb = vim.fn.system("refurb --quiet " .. filepath, true)
    for line in check_refurb:gmatch("([^\n]*)") do
      table.insert(lines, line)
    end
    for i, line in ipairs(lines) do
      if #line == 0 then
        goto continue
      end
      local row = line:match(":(%d+):")
      local column = line:match(":(%d+) ")
      local text = line:match(":%d+:%d+ (.+)")
      -- print(row .. " : " .. column .. " : " .. text)
      vim.diagnostic.set(vim.api.nvim_get_namespaces()["ns_refurb"], 0, {{
        lnum = tonumber(row - 1),
        endnum = tonumber(row - 1),
        col = tonumber(column),
        severity = vim.diagnostic.severity.HINT,
        message = text,
        source = "Refurb",
      }})
      table.insert(refurb_qf_list, {
        bufnr = 0,
        filename = filepath,
        lnum = tonumber(row),
        col = tonumber(column),
        text = text
      })
      ::continue::
    end

    if nvim_bqf_exist then
      vim.fn.setqflist({}, "r", { items = refurb_qf_list })
      vim.cmd("copen")
    end

  -- vim.cmd("cexpr system('refurb --quiet ' . shellescape(expand('%'))) | copen")

end

-- Define the :Refurb command
vim.api.nvim_create_user_command('Refurb', M.Refurb, {})


-- local conform_exist, conform = pcall(require, "conform")
-- if conform_exist then
--   vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*.py",
--     callback = function(args)
--       conform.format({ bufnr = args.buf })
--     end,
--   })
-- end

set.expandtab = true
set.autoindent = true
set.smarttab = true
set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4
set.colorcolumn = "80,88,120"


