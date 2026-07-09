#!/usr/bin/env bash
#
# install-tools.sh — install everything declared in the Brewfile.

set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

ensure_brew_in_path || { error "Homebrew is required — run install-homebrew.sh first"; exit 1; }

BREWFILE="$DOTFILES_DIR/Brewfile"

if brew bundle check --file="$BREWFILE" >/dev/null 2>&1; then
  success "all Brewfile packages already installed"
else
  info "Installing packages from $BREWFILE ..."
  brew bundle install --file="$BREWFILE"
  success "Brewfile packages installed"
fi
