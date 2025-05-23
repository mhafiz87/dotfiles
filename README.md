# dotfiles

- My own application configuration. Currently only support windows operating system.

## Windows

Create symbolic link.

```bash
# gitconfig
if(test-path -path "$env:userprofile/.gitconfig"){remove-item -path "$env:userprofile/.gitconfig" -force}
new-item -itemtype symboliclink -path $env:userprofile/.gitconfig -target "$env:userprofile/.config/.gitconfig" -force

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
if(test-path -path $env:localappdata/nvim-dev){remove-item -path "$env:localappdata/nvim-dev" -recurse -force}
new-item -itemtype symboliclink -path "$env:localappdata/nvim-dev" -target "$env:userprofile/.config/neovim/nvim-dev" -force
if(test-path -path $env:localappdata/nvim-lazy){remove-item -path "$env:localappdata/nvim-lazy" -recurse -force}
new-item -itemtype symboliclink -path "$env:localappdata/nvim-lazy" -target "$env:userprofile/.config/neovim/nvim-lazy" -force
if(test-path -path $env:localappdata/nvim_dev){remove-item -path "$env:localappdata/nvim_dev" -recurse -force}
new-item -itemtype symboliclink -path "$env:localappdata/nvim_dev" -target "$env:userprofile/.config/neovim/nvim_dev" -force

# Clink Settings
if(test-path -path $env:userprofile/.inputrc){remove-item -path "$env:userprofile/.inputrc" -force}
new-item -itemtype symboliclink -path "$env:userprofile/.inputrc" -target "$env:userprofile/.config/clink/.inputrc" -force
if(test-path -path $env:localappdata/clink/oh-my-posh.lua){remove-item -path "$env:localappdata/clink/oh-my-posh.lua" -force}
new-item -itemtype symboliclink -path "$env:localappdata/clink/oh-my-posh.lua" -target "$env:userprofile/.config/clink/oh-my-posh.lua" -force
if(test-path -path $env:localappdata/clink/clink_start.cmd){remove-item -path "$env:localappdata/clink/clink_start.cmd" -force}
new-item -itemtype symboliclink -path "$env:localappdata/clink/clink_start.cmd" -target "$env:userprofile/.config/clink/clink_start.cmd" -force

# .wslconfig
if(test-path -path $env:userprofile/.wslconfig){remove-item -path "$env:userprofile/.wslconfig" -force}
new-item -itemtype symboliclink -path "$env:userprofile/.wslconfig" -target "$env:userprofile/.config/.wslconfig" -force

```

## Linux - Ubuntu

```bash
ln -s ~/.config/bash/.bash_aliases ~/.bash_aliases
ln -s ~/.config/bash/.bash_profile ~/.bash_profile
```
