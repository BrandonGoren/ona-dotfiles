#!/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Create consistent reference path
ln -sfn "$DOTFILES_DIR" "$HOME/.dotfiles"

# Symlink shell config
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Install Starship prompt
if ! command -v starship &> /dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

# Install git completion for zsh
if [ ! -f "$HOME/.zsh/git-completion.bash" ]; then
  mkdir -p "$HOME/.zsh"
  curl -sS -o "$HOME/.zsh/git-completion.bash" \
    https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
  curl -sS -o "$HOME/.zsh/_git" \
    https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
fi

# Run Claude configuration
source "$DOTFILES_DIR/claude/.run"
