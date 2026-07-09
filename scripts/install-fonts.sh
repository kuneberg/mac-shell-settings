#!/usr/bin/env bash
#
# install-fonts.sh — install terminal fonts (JetBrains Mono Nerd Font).
#
# The font is also declared in the Brewfile; this script exists so fonts
# can be (re)installed on their own and so the installer can verify them.

set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

ensure_brew_in_path || { error "Homebrew is required — run install-homebrew.sh first"; exit 1; }

FONT_CASK="font-jetbrains-mono-nerd-font"

if brew list --cask "$FONT_CASK" >/dev/null 2>&1; then
  success "$FONT_CASK already installed"
else
  info "Installing $FONT_CASK ..."
  brew install --cask "$FONT_CASK"
  success "$FONT_CASK installed"
fi
