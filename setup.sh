# #!/usr/bin/env

DOTFILES_DIR="$HOME/.dotfiles"

mkdir -p "$HOME/.config"

symlink() {
    local source="$1"
    local target="$2"

    if [ -f "$target" ] && [ ! -L "$target" ]; then
        echo "  Backing up $target → $target.backup"
        mv "$target" "$target.backup"
    fi

    [ -L "$target" ] && rm "$target"
    ln -s "$source" "$target"
    echo "  Linked $source → $target"
}

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing Homebrew packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

echo "Creating symlinks..."
symlink "$DOTFILES_DIR/zsh/.zshrc"              "$HOME/.zshrc"
symlink "$DOTFILES_DIR/zsh/.zshenv"             "$HOME/.zshenv"
symlink "$DOTFILES_DIR/starship/starship.toml"  "$HOME/.config/starship.toml"
symlink "$DOTFILES_DIR/git/.gitconfig"          "$HOME/.gitconfig"
symlink "$DOTFILES_DIR/git/.gitconfig.ix"       "$HOME/.gitconfig.ix"

echo "Done! Next: source ~/.zshrc"