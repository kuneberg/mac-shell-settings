#!/usr/bin/env bash
#
# install.sh — one-shot, idempotent setup for this dotfiles repository.
#
# Safe to run repeatedly: existing files are backed up (never deleted),
# symlinks and managed blocks are only touched when they have drifted.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# One backup directory for the whole run, shared by every child script.
DOTFILES_BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
export DOTFILES_BACKUP_DIR

# shellcheck source=scripts/utils.sh
source "$DOTFILES_DIR/scripts/utils.sh"

run_step() {
  local title="$1" script="$2"
  step "$title"
  bash "$DOTFILES_DIR/scripts/$script"
}

setup_git_include() {
  step "Git configuration"
  local include_path="$DOTFILES_DIR/git/gitconfig"
  if git config --global --get-all include.path 2>/dev/null | grep -qxF "$include_path"; then
    success "gitconfig already included: $include_path"
  else
    git config --global --add include.path "$include_path"
    success "added git include.path -> $include_path"
  fi
}

summary() {
  step "Summary"
  if [[ -d "$DOTFILES_BACKUP_DIR" ]]; then
    info "Replaced/edited files were backed up to: $DOTFILES_BACKUP_DIR"
  else
    info "No existing files needed backing up."
  fi
  if [[ -z "$(git config --global user.name 2>/dev/null || true)" ]] ||
     [[ -z "$(git config --global user.email 2>/dev/null || true)" ]]; then
    warn "git identity is not set — configure it manually:"
    printf '      git config --global user.name  "Your Name"\n'
    printf '      git config --global user.email "you@example.com"\n'
  fi
  info "Restart your terminal (or run: exec zsh) to load the new configuration."
  success "Done. Re-running this installer is always safe."
}

main() {
  printf '%s\n' "${C_BOLD}Dotfiles installer${C_RESET} — $DOTFILES_DIR"

  run_step "Homebrew"            "install-homebrew.sh"
  run_step "Packages (Brewfile)" "install-tools.sh"
  run_step "Fonts"               "install-fonts.sh"
  run_step "Symlinks"            "setup-links.sh"
  run_step "Zsh"                 "setup-zsh.sh"
  setup_git_include
  summary
}

main "$@"
