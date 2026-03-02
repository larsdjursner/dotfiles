#!/usr/bin/env bash

# Define the dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"

# List of dotfiles and their destinations
declare -A FILES_TO_SYMLINK=(
    ["zsh/.zshrc"]="$HOME/.zshrc"
    ["starship/starship.toml"]="$HOME/.config/starship.toml"
)

# Ensure the necessary directories exist
mkdir -p "$HOME/.config"

echo "Creating symlinks..."
for file in "${!FILES_TO_SYMLINK[@]}"; do
    target="${FILES_TO_SYMLINK[$file]}"
    source="$DOTFILES_DIR/$file"

    # If the target already exists and isn't a symlink, back it up
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        echo "  Backing up $target → $target.backup"
        mv "$target" "$target.backup"
    fi

    # Remove existing symlink if it exists
    [ -L "$target" ] && rm "$target"

    # Create a new symlink
    ln -s "$source" "$target"
    echo "  Linked $source → $target"
done

echo "Done! Next: source ~/.zshrc"