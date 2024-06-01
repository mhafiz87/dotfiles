# dotfiles

- My own application configuration. Currently only support windows operating system.

## Symbolic Link

```powershell
# Powershell Profile
if(test-path -path "$profile"){remove-item -path "$profile" -force}
new-item -itemtype symboliclink -path $profile -target "$env:userprofile/.config/.powershell_profile.ps1"

# VSCode Settings
if(test-path -path "$env:appdata/code/user/keybindings.json"){remove-item -path "$env:appdata/code/user/keybindings.json" -force}
new-item -itemtype symboliclink -path "$env:appdata/code/user/keybindings.json" -target "$env:userprofile/.config/vscode/keybindings.json" -force
if(test-path -path "$env:appdata/code/user/settings.json"){remove-item -path "$env:appdata/code/user/settings.json" -force}
new-item -itemtype symboliclink -path "$env:appdata/code/user/settings.json" -target "$env:userprofile/.config/vscode/settings.json" -force

# Neovim Settings
if(test-path -path $env:localappdata/nvim-data){remove-item -path "$env:localappdata/nvim-data" -recurse -force}
new-item -itemtype symboliclink -path "$env:localappdata/nvim-data" -target "$env:userprofile/.config/neovim/nvim" -force
if(test-path -path $env:localappdata/nvim_dev-data){remove-item -path "$env:localappdata/nvim_dev-data" -recurse -force}
new-item -itemtype symboliclink -path "$env:localappdata/nvim_dev-data" -target "$env:userprofile/.config/neovim/nvim_dev" -force

```
