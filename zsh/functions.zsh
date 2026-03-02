# Functions
# Project dirs
function ix()  { cd ~/Documents/ix/  && echo "→ ix hey" }
function dev() { cd ~/Documents/dev/ && echo "→ dev" }
function dotf() { cd ~/dotfiles && echo "→ dotfiles" }

# mkdir + cd
function mkcd() { mkdir -p "$1" && cd "$1" }

# Extract any archive
function extract() {
  [ ! -f "$1" ] && echo "'$1' is not a valid file" && return
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar)             tar xf  "$1" ;;
    *.bz2)             bunzip2 "$1" ;;
    *.gz)              gunzip  "$1" ;;
    *.rar)             unrar x "$1" ;;
    *.zip)             unzip   "$1" ;;
    *.Z)               uncompress "$1" ;;
    *.7z)              7z x "$1" ;;
    *)                 echo "Cannot extract '$1'" ;;
  esac
}