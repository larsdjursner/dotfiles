# #!/usr/bin/env bash

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

echo "Creating symlinks..."
symlink "$DOTFILES_DIR/zsh/.zshrc"             "$HOME/.zshrc"
symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
symlink "$DOTFILES_DIR/git/.gitconfig"         "$HOME/.gitconfig"
symlink "$DOTFILES_DIR/git/.gitconfig.ix"      "$HOME/.gitconfig.ix"

echo "Done! Next: source ~/.zshrc"