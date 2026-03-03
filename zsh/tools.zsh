# Starship
eval "$(starship init zsh)"

# fzf (add ctrl + r keybinds search etc)
eval "$(fzf --zsh)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Zoxide (not really used)
# eval "$(zoxide init zsh)"

