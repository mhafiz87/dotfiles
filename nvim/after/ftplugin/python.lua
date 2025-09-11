local set = vim.opt_local

local M = {}

-- https://github.com/camAtGitHub/pydochide.nvim/blob/master/lua/pydochide/init.lua
function M.PyDocHide()
    -- Ensure the current buffer is a Python file
    if vim.bo.filetype ~= 'python' then
        vim.api.nvim_echo({{"[PyDocHide] Not a Python file.", "WarningMsg"}}, false, {})
        return
    end

    -- Set foldmethod to manual
    vim.wo.foldmethod = 'manual'

    -- Clear existing manual folds
    vim.cmd('normal! zE')

    -- Get the parser for the current buffer
    local parser = vim.treesitter.get_parser(0, 'python')
    if not parser then
        vim.api.nvim_echo({{"[PyDocHide] Tree-sitter parser not found for Python.", "ErrorMsg"}}, false, {})
        return
    end

    local tree = parser:parse()[1]
    if not tree then
        vim.api.nvim_echo({{"[PyDocHide] Failed to parse the buffer.", "ErrorMsg"}}, false, {})
        return
    end

    local root = tree:root()

    -- Function to recursively traverse the tree and find docstrings
    local function traverse(node)
        local node_type = node:type()

        if node_type == 'function_definition' or node_type == 'class_definition' then
            -- Get the body of the function or class
            local body = nil
            for child in node:iter_children() do
                if child:type() == 'block' then
                    body = child
                    break
                end
            end

            if body then
                -- The first child of the body might be the docstring
                local first_child = body:child(0)
                if first_child and first_child:type() == 'expression_statement' then
                    local string_node = first_child:child(0)
                    if string_node and string_node:type() == 'string' then
                        -- Get the range of the docstring
                        local start_row, _, end_row, _ = string_node:range()

                        -- Tree-sitter uses 0-based indexing for rows
                        local start_line = start_row + 1
                        local end_line = end_row + 1

                        -- Create a fold from start_line to end_line
                        -- Ensure start_line is less than end_line
                        if start_line < end_line then
                            vim.cmd(string.format('%d,%dfold', start_line, end_line))
                        end
                    end
                end
            end
        end

        -- Recursively traverse children
        for child in node:iter_children() do
            traverse(child)
        end
    end

    -- Start traversal from the root
    traverse(root)
end

-- Define the :PyDocHide command
vim.api.nvim_create_user_command('PyDocHide', M.PyDocHide, {})

-- Optionally, you can disable the automatic runnning of PyDocHide when a Python file is opened
-- Comment the following lines if desired

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        M.PyDocHide()
    end
})

-- https://influentcoder.com/posts/nvim-diagnostics/
-- local nvim_bqf_exist, _ = utils.is_plugin_installed("nvim-bqf")
local nvim_bqf_exist, nvim_bqf = pcall(require, "bqf")
nvim_bqf.enable()

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


-- LSPAttach Auto Command
-- vim.api.nvim_create_autocmd("LSPAttach", {
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function ()
    local clients = vim.lsp.get_clients({bufnr = 0})
    for key, client in pairs(clients) do
      if client["name"] == "ruff" then
        vim.lsp.buf.code_action({
          context = {
            only = { "source.organizeImports" }
          },
          apply = true,
        })
        vim.lsp.buf.format {
          async = true,
          name = "ruff"
        }
      end
    end
  end
})


set.expandtab = true
set.autoindent = true
set.smarttab = true
set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4
set.colorcolumn = "80,88,120"


