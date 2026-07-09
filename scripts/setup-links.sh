#!/usr/bin/env bash
#
# setup-links.sh — create ~/.config directories and symlink all repo-owned
# configuration. Anything already at a destination is moved into the
# timestamped backup directory first; nothing is ever deleted.

set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

info "Creating ~/.config directories..."
mkdir -p "$HOME/.config/ghostty" "$HOME/.config/atuin" "$HOME/.config/yazi"

link_file "$DOTFILES_DIR/ghostty/config"         "$HOME/.config/ghostty/config"
link_file "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
link_file "$DOTFILES_DIR/atuin/config.toml"      "$HOME/.config/atuin/config.toml"
link_file "$DOTFILES_DIR/yazi/yazi.toml"         "$HOME/.config/yazi/yazi.toml"
link_file "$DOTFILES_DIR/tmux/tmux.conf"         "$HOME/.tmux.conf"
