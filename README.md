# dotfiles

- My own application configuration. Currently only support windows operating system.

## Symbolic Link

```powershell
# Powershell Profile
new-item -itemtype symboliclink -path $profile -target "$env:userprofile/.config/.powershell_profile.ps1"

# VSCode Settings
new-item -itemtype symboliclink -path "$env:appdata/code/user/keybindings.json" -target "$env:userprofile/.config/vscode/keybindings.json" -force
new-item -itemtype symboliclink -path "$env:appdata/code/user/settings.json" -target "$env:userprofile/.config/vscode/settings.json" -force

# Neovim Settings
new-item -itemtype symboliclink -path "$env:localappdata/nvim" -target "$env:userprofile/.config/neovim/nvim" -force
new-item -itemtype symboliclink -path "$env:localappdata/nvim_dev" -target "$env:userprofile/.config/neovim/nvim_dev" -force

```
