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
link_file "$DOTFILES_DIR/yazi/theme.toml"        "$HOME/.config/yazi/theme.toml"
link_file "$DOTFILES_DIR/yazi/keymap.toml"       "$HOME/.config/yazi/keymap.toml"
link_file "$DOTFILES_DIR/yazi/plugins"           "$HOME/.config/yazi/plugins"
link_file "$DOTFILES_DIR/tmux/tmux.conf"         "$HOME/.tmux.conf"
# micro links its whole config directory (settings, bindings, colorschemes)
link_file "$DOTFILES_DIR/micro"                  "$HOME/.config/micro"
# iTerm2 auto-loads profiles from its DynamicProfiles directory
link_file "$DOTFILES_DIR/iterm2/amethyst.json"   "$HOME/Library/Application Support/iTerm2/DynamicProfiles/amethyst.json"
link_file "$DOTFILES_DIR/gdu/gdu.yaml"           "$HOME/.gdu.yaml"
