# Config shortcuts
alias src="source ~/dotfiles/zsh/.zshrc && echo 'Reloaded'"
alias setup="~/dotfiles/setup.sh"

# Navigation
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ~="cd ~"

# eza
alias ls='eza -a --icons'
alias ll='eza -al --icons'
alias lt='eza -a --tree --level=3 --icons'
alias l.='eza -d .* --color=auto'

# grep
alias grep='grep --color=auto'