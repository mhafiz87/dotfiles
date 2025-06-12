local M = {}

M.plugins_path = vim.fn.stdpath("data") .. "/lazy/"

M.is_plugin_installed = function(plugins_name)
  if vim.fn.empty(vim.fn.glob(M.plugins_path .. plugins_name)) > 0 then
    return false
  else
    return true
  end
end

M.is_windows = function ()
    return vim.loop.os_uname().sysname == "Windows_NT"
end

M.is_linux = function ()
    return vim.loop.os_uname().sysname == "Linux"
end
M.is_mac = function ()
    return vim.loop.os_uname().sysname == "Darwin"
end

M.toggle_all_python_docstring = function()
  local current_line_number = vim.api.nvim_win_get_cursor(0)[1]

  vim.api.nvim_feedkeys("gg", "n", false)
  vim.api.nvim_command('/"""')
  local total = vim.fn.searchcount().total
  for i = total, 2, -1 do
    vim.api.nvim_feedkeys("n", "n", false)
    vim.api.nvim_feedkeys("za", "n", false)
  end
  vim.api.nvim_command("nohl")

  vim.api.nvim_feedkeys(current_line_number .. "gg", "n", false)
  vim.api.nvim_command("nohl")
end

M.format_selected_lines_using_black = function()
  local start_line = vim.api.nvim_buf_get_mark(0, "<")[1]
  local end_line = vim.api.nvim_buf_get_mark(0, ">")[1]
  local current_buffer_path = vim.fn.expand("%:p")
  local cmd = "!black --line-ranges=" .. start_line .. "-" .. end_line .. " " .. "%:p"
  local keys = vim.api.nvim_replace_termcodes('<ESC>',true,false,true)
  vim.api.nvim_feedkeys(keys,'n',false)
  vim.api.nvim_command(cmd)
  -- vim.keymap.set("n", "<leader>mb", cmd, { noremap = true, desc = "For[m]at selected lines using [b]lack", silent = true })
end

return M
