# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"
plugins=(git z zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/z/z.sh
source $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf
source <(fzf --zsh)

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Starship
eval "$(starship init zsh)"

# Zoxide (not really used)
# eval "$(zoxide init zsh)"

