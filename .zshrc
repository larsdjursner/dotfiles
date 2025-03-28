##########################
#     Startup Message    #
##########################
printf '\n%.0s' {1..100}

# echo "$(whoami)"
# echo "
#      .---.
#     @ @   )   
#     ^     |
#    [|]    | ##
#    /      |####
#   (       |####      
#    \| /   |#BP#
#   / |.'   |### 
#  _\ ``\   )##
# /,,_/,,____#
# "


##########################
#         Hooks          #
##########################
autoload -Uz add-zsh-hook

preexec_hook() {echo "";}
add-zsh-hook preexec preexec_hook

##########################
#        Starship        #
##########################
eval "$(starship init zsh)"


##########################
#       Oh-My-Zsh        #
##########################
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

plugins=(
  git
  z
  zsh-autosuggestions
)

source $ZSH/custom/plugins/z/z.sh
source $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


##########################
#     External Tools     #
##########################
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# fzf
source <(fzf --zsh)
alias fzf="fzf; tput cup $(tput lines) 0"

# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" # Load NVM
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # Load bash completion

# Go environment
export PATH=$PATH:$(go env GOPATH)/bin


##########################
#        Aliases         #
##########################
# Easier navigation
alias ..="cd .."        # Go up one directory
alias ..2="cd ../.."    # Go up two directories
alias ..3="cd ../../.." # Go up three directories
alias ..4="cd ../../../.." # Go up three directories
alias ~="cd ~"          # Go to home directory



# Quick file editing
alias zshrc="code ~/.zshrc"  
alias dotf="code ~/dotfiles"  
alias src="echo 'Reloading ~/.zshrc'; source ~/.zshrc"  # Reload `.zshrc`

# Push everything to the bottom
alias clear="printf '\n%.0s' {1..100}"

# EZA
# alias ls='ls --color=auto'                        # color ls
alias grep='grep --color=auto'                    # color grep
alias ls='eza -a --icons'                         # list all files with icons
alias ll='eza -al --icons'                        # list all files with icons 
alias lt='eza -a --tree --level=3 --icons'        # list tree view with icons
alias l.='eza -d .* --color=auto'                 # list hidden files

# Directory listing
alias ll="ls -alF"      # Detailed list with file types
alias la="ls -A"        # List all files, excluding `.` and `..`
alias l="ls -CF"        # Compact list format

##########################
#   Shortcut Functions   #
##########################
function ix() {
  local path=~/Documents/ix/
  echo "Changing to $path"
  cd "$path" || return
}

function dev() {
  local path=~/Documents/dev/
  echo "Changing to $path"
  cd "$path" || return
}


##########################
#    Custom Functions    #
##########################

# Add any reusable scripts or functions
function mkcd() {
  # Create a directory and move into it
  mkdir -p "$1" && cd "$1"
}

function extract() {
  # Extract various archive types
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *.7z) 7z x "$1" ;;
      *) echo "Cannot extract '$1'" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


##########################
#     PATH Updates       #
##########################
# Add custom binaries or scripts here
export PATH=$PATH:$HOME/bin:$HOME/scripts
