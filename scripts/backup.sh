#!/usr/bin/env bash
#
# backup.sh — snapshot every file this repository manages into a
# timestamped backup directory. Files are copied, originals stay in place.
# Useful before experiments or before running the installer by hand.

set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

TARGETS=(
  "$HOME/.zprofile"
  "$HOME/.zshrc"
  "$HOME/.tmux.conf"
  "$HOME/.config/ghostty/config"
  "$HOME/.config/alacritty/alacritty.toml"
  "$HOME/.config/starship.toml"
  "$HOME/.config/atuin/config.toml"
  "$HOME/.config/lf/lfrc"
  "$HOME/.config/lf/colors"
  "$HOME/.config/lf/icons"
  "$HOME/.config/micro/settings.json"
  "$HOME/.config/micro/bindings.json"
  "$HOME/Library/Application Support/iTerm2/DynamicProfiles/srcery.json"
  "$HOME/.gdu.yaml"
  "$HOME/.claude/settings.json"
  "/etc/pam.d/sudo_local"
)

info "Backing up managed files -> $DOTFILES_BACKUP_DIR"
count=0
for target in "${TARGETS[@]}"; do
  if [[ -f "$target" || -L "$target" ]]; then
    backup_copy "$target"
    count=$((count + 1))
  fi
done

if (( count == 0 )); then
  warn "nothing to back up"
else
  success "$count file(s) backed up to $DOTFILES_BACKUP_DIR"
fi
