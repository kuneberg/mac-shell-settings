#!/usr/bin/env bash
#
# setup-zsh.sh — wire the repo's zsh configuration into ~/.zprofile and
# ~/.zshrc via managed blocks. Existing user content is preserved; files
# are backed up before any edit, and the block is never duplicated.

set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

ensure_block "$HOME/.zprofile" 'source "$HOME/.dotfiles/zsh/zprofile"'
ensure_block "$HOME/.zshrc"    'source "$HOME/.dotfiles/zsh/zshrc"'
