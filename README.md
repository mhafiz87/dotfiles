# dotfiles

- My own application configuration. Currently only support windows operating system.

## Windows

Create symbolic link.

```bash
# Powershell Profile
if(test-path -path "$profile"){remove-item -path "$profile" -force}
new-item -itemtype symboliclink -path $profile -target "$env:userprofile/.config/.powershell_profile.ps1" -force

# VSCode Settings
if(test-path -path "$env:appdata/code/user/keybindings.json"){remove-item -path "$env:appdata/code/user/keybindings.json" -force}
new-item -itemtype symboliclink -path "$env:appdata/code/user/keybindings.json" -target "$env:userprofile/.config/vscode/keybindings.json" -force
if(test-path -path "$env:appdata/code/user/settings.json"){remove-item -path "$env:appdata/code/user/settings.json" -force}
new-item -itemtype symboliclink -path "$env:appdata/code/user/settings.json" -target "$env:userprofile/.config/vscode/settings.json" -force

# Neovim Settings
if(test-path -path $env:localappdata/nvim){remove-item -path "$env:localappdata/nvim" -recurse -force}
new-item -itemtype symboliclink -path "$env:localappdata/nvim" -target "$env:userprofile/.config/nvim" -force
if(test-path -path $env:localappdata/nvim_dev){remove-item -path "$env:localappdata/nvim_dev" -recurse -force}
new-item -itemtype symboliclink -path "$env:localappdata/nvim_dev" -target "$env:userprofile/.config/neovim/nvim_dev" -force

# Clink Settings
if(test-path -path $env:userprofile/.inputrc){remove-item -path "$env:userprofile/.inputrc" -force}
new-item -itemtype symboliclink -path "$env:userprofile/.inputrc" -target "$env:userprofile/.config/clink/.inputrc" -force
if(test-path -path $env:localappdata/clink/oh-my-posh.lua){remove-item -path "$env:localappdata/clink/oh-my-posh.lua" -force}
new-item -itemtype symboliclink -path "$env:localappdata/clink/oh-my-posh.lua" -target "$env:userprofile/.config/clink/oh-my-posh.lua" -force
if(test-path -path $env:localappdata/clink/clink_start.cmd){remove-item -path "$env:localappdata/clink/clink_start.cmd" -force}
new-item -itemtype symboliclink -path "$env:localappdata/clink/clink_start.cmd" -target "$env:userprofile/.config/clink/clink_start.cmd" -force

```

## Linux - Ubuntu

```bash
ln -s ~/.config/bash/.bash_aliases ~/.bash_aliases
ln -s ~/.config/bash/.bash_profile ~/.bash_profile
```
