if os.getenv("userprofile") ~= nil then
  load(io.popen('oh-my-posh --config="' .. os.getenv('userprofile') .. '/.config/ohmyposh/zen.toml" init cmd'):read("*a"))()
end

