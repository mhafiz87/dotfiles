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

M.is_buf_keymap_set = function (bufnr, mode, lhs)
  local keymaps = vim.api.nvim_buf_get_keymap(bufnr, mode)
  for _, map in ipairs(keymaps) do
    if map.lhs == lhs then
      return true
    end
  end
  return false
end

M.update_theme_hl = function (name, tbl)
  local old_tbl = vim.api.nvim_get_hl(0, { name = name })
  local new_tbl = vim.tbl_extend("force", old_tbl, tbl)
  vim.api.nvim_set_hl(0, name, new_tbl)
end

return M
