# Config shortcuts
alias src="source ~/.dotfiles/zsh/.zshrc && echo 'Reloaded zsh'"
alias setup="~/.dotfiles/setup.sh"

# Navigation
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ~="cd ~"

# eza
alias ls='eza -1 -a --icons --classify=auto --color --group-directories-first --sort=extension -A'
alias ll='eza -al --icons'
alias lt='eza -a --tree --level=2 --icons --classify=auto --color --group-directories-first --sort=extension -A'
alias l.='eza -d .* --color=auto'

# grep
alias grep='grep --color=auto'