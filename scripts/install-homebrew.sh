#!/usr/bin/env bash
#
# install-homebrew.sh — install Homebrew if missing, then update it.

set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

if ensure_brew_in_path; then
  success "Homebrew present: $(brew --version | head -n1)"
else
  info "Homebrew not found — installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ensure_brew_in_path || { error "Homebrew installed but brew not found on PATH"; exit 1; }
  success "Homebrew installed: $(brew --version | head -n1)"
fi

info "Updating Homebrew..."
brew update --quiet
success "Homebrew is up to date"
