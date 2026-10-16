#!/usr/bin/env zsh

DOTFILES_DIR="$HOME/dotfiles"

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/ghostty"
mkdir -p "$HOME/.config/worktrunk/hooks"


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

echo "Setting VS Code as default app for shell scripts..."
for type in public.shell-script .sh .bash .zsh; do
    duti -s com.microsoft.VSCode "$type" all
done

echo "Creating symlinks..."
symlink "$DOTFILES_DIR/zsh/.zshrc"              "$HOME/.zshrc"
symlink "$DOTFILES_DIR/zsh/.zshenv"             "$HOME/.zshenv"
symlink "$DOTFILES_DIR/starship/starship.toml"  "$HOME/.config/starship.toml"
symlink "$DOTFILES_DIR/git/.gitconfig"          "$HOME/.gitconfig"
symlink "$DOTFILES_DIR/ghostty/config"          "$HOME/.config/ghostty/config"
symlink "$DOTFILES_DIR/worktrunk/config.toml"   "$HOME/.config/worktrunk/config.toml"
symlink "$DOTFILES_DIR/worktrunk/hooks/link-env-files.sh" "$HOME/.config/worktrunk/hooks/link-env-files.sh"

# Work git identity + gh account (kept out of git; prompted once per machine)
if [ ! -f "$DOTFILES_DIR/git/.gitconfig.work" ]; then
    echo "Setting up work git identity (used under ~/Documents/ix/, not committed to this repo)..."
    read "work_name?  Work git name: "
    read "work_email?  Work git email: "
    cat > "$DOTFILES_DIR/git/.gitconfig.work" <<EOF
[user]
    name = $work_name
    email = $work_email
EOF
fi
symlink "$DOTFILES_DIR/git/.gitconfig.work" "$HOME/.gitconfig.work"

if [ ! -f "$DOTFILES_DIR/direnv/work.env" ]; then
    read "gh_account?  gh CLI account to use under ~/Documents/ix/ (blank to skip): "
    echo "GH_WORK_ACCOUNT=$gh_account" > "$DOTFILES_DIR/direnv/work.env"
fi
mkdir -p "$HOME/Documents/ix"
symlink "$DOTFILES_DIR/direnv/work.envrc" "$HOME/Documents/ix/.envrc"
direnv allow "$HOME/Documents/ix"

echo "Done! Next: source ~/.zshrc"