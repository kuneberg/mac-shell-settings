#!/usr/bin/env bash
#
# setup-links.sh — create ~/.config directories and symlink all repo-owned
# configuration. Anything already at a destination is moved into the
# timestamped backup directory first; nothing is ever deleted.

set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

info "Creating ~/.config directories..."
mkdir -p "$HOME/.config/ghostty" "$HOME/.config/alacritty" "$HOME/.config/atuin"

link_file "$DOTFILES_DIR/ghostty/config"         "$HOME/.config/ghostty/config"
link_file "$DOTFILES_DIR/ghostty/orange-glow.png"  "$HOME/.config/ghostty/orange-glow.png"
link_file "$DOTFILES_DIR/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
link_file "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
link_file "$DOTFILES_DIR/atuin/config.toml"      "$HOME/.config/atuin/config.toml"
# lf links its whole config directory (lfrc, colors, icons, previewer)
link_file "$DOTFILES_DIR/lf"                     "$HOME/.config/lf"
link_file "$DOTFILES_DIR/tmux/tmux.conf"         "$HOME/.tmux.conf"
# micro links its whole config directory (settings, bindings, colorschemes)
link_file "$DOTFILES_DIR/micro"                  "$HOME/.config/micro"
# iTerm2 auto-loads profiles from its DynamicProfiles directory
link_file "$DOTFILES_DIR/iterm2/srcery.json"      "$HOME/Library/Application Support/iTerm2/DynamicProfiles/srcery.json"
link_file "$DOTFILES_DIR/gdu/gdu.yaml"           "$HOME/.gdu.yaml"
# Claude Code: user settings (hooks, model, permissions) + hook scripts
link_file "$DOTFILES_DIR/claude/settings.json"   "$HOME/.claude/settings.json"
link_file "$DOTFILES_DIR/claude/hooks"           "$HOME/.claude/hooks"
