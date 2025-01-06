# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# To find distro
# if [ $(lsb_release -is) == "Ubuntu"  ]; then
#    echo "Running on Ubuntu"
# fi

if [ "$(dpkg -l | awk '/fastfetch/ {print }'|wc -l)" -ge 1 ]; then
    fastfetch
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/zen.toml)"

