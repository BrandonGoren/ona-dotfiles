#!/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Create consistent reference path
ln -sfn "$DOTFILES_DIR" "$HOME/.dotfiles"

# Symlink shell config
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Run Claude configuration
source "$DOTFILES_DIR/claude/.run"
