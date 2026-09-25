ZDOTDIR_CUSTOM="${HOME}/dotfiles/zsh"

# Add Homebrew to path first
eval "$(/opt/homebrew/bin/brew shellenv)"

# Oh-My-Zsh + plugins
export ZSH="$HOME/.oh-my-zsh"
plugins=(git z zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Misc stuff
source "$ZDOTDIR_CUSTOM/path.zsh"
source "$ZDOTDIR_CUSTOM/functions.zsh"
source "$ZDOTDIR_CUSTOM/aliases.zsh"

# Keyboard navigation
bindkey "^[f" forward-word        # option+right
bindkey "^[b" backward-word       # option+left
bindkey "^[^?" backward-kill-word # option+backspace

# fzf
eval "$(fzf --zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# direnv
eval "$(direnv hook zsh)"

# Syntax highlighting (must be before starship)
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# worktrunk
eval "$(wt config shell init zsh)"

# Starship has to be last
eval "$(starship init zsh)"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
