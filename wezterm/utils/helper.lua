local nvim_process = { "nvim", "lua-language-server.exe", "node.exe", "taplo.exe" }
local M = {}

function M.basename(s)
  return string.match(string.gsub(s, '(.*[/\\])(.*)', '%2'), "[a-zA-Z0-9_-]+")
end

function M.table_length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function M.remove_exe(s)
  local temp = string.gmatch(s, "%.")
  for i in temp do
    print(i)
  end
end

-- https://github.com/letieu/dotfiles/blob/master/dot_config/wezterm/key.lua
function M.is_vim(pane)
  local process_info = pane:get_foreground_process_info()
  local process_name = ""
  for i = 1, #nvim_process do
    if string.find(process_info.executable, nvim_process[i]) then
      return true
    end
  end
  return false
end

function M.find_vim_pane(tab)
  for _, pane in ipairs(tab:panes()) do
    if M.is_vim(pane) then
      return pane
    end
  end
end

function M.TableConcat(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

return M
