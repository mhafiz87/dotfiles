local wezterm = require("wezterm")

local platform = {}

platform.is_linux = function ()
  return wezterm.target_triple:find("linux") ~= nil
end

platform.is_windows = function ()
  return wezterm.target_triple:find("windows") ~= nil
end

platform.is_mac = function ()
  return wezterm.target_triple:find("darwin") ~= nil
end


return platform

