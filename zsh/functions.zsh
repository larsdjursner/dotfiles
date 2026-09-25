# Functions
# Project dirs
function ix()  { cd ~/Documents/ix/  && echo "→ ix" }
function dev() { cd ~/Documents/dev/ && echo "→ dev" }
function dotf() { cd ~/dotfiles && echo "→ dotfiles" }

# mkdir + cd
function mkcd() { mkdir -p "$1" && cd "$1" }

# Tab title: repo ⎇ worktree, or just the dir name
function _set_tab_title() {
  local title
  set -- $(git rev-parse --path-format=absolute --git-dir --git-common-dir --show-toplevel 2>/dev/null)
  if [ -n "$3" ] && [ "$1" != "$2" ]; then
    title="$(basename "$(dirname "$2")") ⎇ $(basename "$3")"
  else
    title="${PWD:t}"
  fi
  print -n "\e]2;${title}\a"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _set_tab_title

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