ZDOTDIR_CUSTOM="${HOME}/.dotfiles/zsh"

# Add Homebrew to path first
eval "$(/opt/homebrew/bin/brew shellenv)"

# Oh-My-Zsh + plugins
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
plugins=(git z zsh-autosuggestions)
source $ZSH/custom/plugins/z/z.sh
source $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


# Misc stuff
source "$ZDOTDIR_CUSTOM/tools.zsh"
source "$ZDOTDIR_CUSTOM/path.zsh"
source "$ZDOTDIR_CUSTOM/functions.zsh"
source "$ZDOTDIR_CUSTOM/aliases.zsh"