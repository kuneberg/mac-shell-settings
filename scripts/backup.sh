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
  "$HOME/.config/starship.toml"
  "$HOME/.config/atuin/config.toml"
  "$HOME/.config/yazi/yazi.toml"
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
