#!/usr/bin/env bash
#
# utils.sh — shared helpers for all dotfiles scripts.
# This file is sourced, not executed.

# Repo root, resolved from this file's real location.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_DIR

# One timestamped backup directory per install run. install.sh exports
# DOTFILES_BACKUP_DIR so every child script shares it; a script run on its
# own gets a fresh timestamp. The directory is only created when a backup
# actually happens.
DOTFILES_BACKUP_DIR="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"
export DOTFILES_BACKUP_DIR

# ---------------------------------------------------------------- logging --

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  C_RESET=$'\033[0m'; C_BOLD=$'\033[1m'; C_RED=$'\033[31m'
  C_GREEN=$'\033[32m'; C_YELLOW=$'\033[33m'; C_BLUE=$'\033[34m'
else
  C_RESET=''; C_BOLD=''; C_RED=''; C_GREEN=''; C_YELLOW=''; C_BLUE=''
fi

info()    { printf '%s\n' "${C_BLUE}==>${C_RESET} $*"; }
success() { printf '%s\n' "${C_GREEN}  ✓${C_RESET} $*"; }
warn()    { printf '%s\n' "${C_YELLOW}  !${C_RESET} $*"; }
error()   { printf '%s\n' "${C_RED}  ✗${C_RESET} $*" >&2; }
step()    { printf '\n%s\n' "${C_BOLD}${C_BLUE}──── $* ────${C_RESET}"; }

# ---------------------------------------------------------------- backups --

# backup_move <path>
# Move an existing file/dir/symlink into the backup dir, mirroring its path
# relative to $HOME. No-op when <path> does not exist. Never deletes.
backup_move() {
  local target="$1"
  [[ -e "$target" || -L "$target" ]] || return 0
  local rel="${target#"$HOME"/}"
  local dest="$DOTFILES_BACKUP_DIR/$rel"
  mkdir -p "$(dirname "$dest")"
  mv "$target" "$dest"
  warn "backed up: $target -> $dest"
}

# backup_copy <path>
# Like backup_move, but leaves the original in place — for files we edit
# in place rather than replace (e.g. ~/.zshrc).
backup_copy() {
  local target="$1"
  [[ -f "$target" ]] || return 0
  local rel="${target#"$HOME"/}"
  local dest="$DOTFILES_BACKUP_DIR/$rel"
  mkdir -p "$(dirname "$dest")"
  cp -p "$target" "$dest"
  warn "backed up copy: $target -> $dest"
}

# --------------------------------------------------------------- symlinks --

# link_file <source-in-repo> <destination>
# Idempotent: skips when the correct link already exists, backs up whatever
# else is in the way, then links.
link_file() {
  local src="$1" dest="$2"
  if [[ ! -e "$src" ]]; then
    error "link source missing: $src"
    return 1
  fi
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    success "already linked: $dest"
    return 0
  fi
  backup_move "$dest"
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  success "linked: $dest -> $src"
}

# --------------------------------------------------------- managed blocks --

DOTFILES_BLOCK_BEGIN='# >>> dotfiles >>>'
DOTFILES_BLOCK_END='# <<< dotfiles <<<'

# ensure_block <file> <content-line>
# Ensure <file> contains exactly one managed block wrapping <content-line>.
# Creates the file when missing, rewrites the block when its content
# drifted, appends it when absent. The file is backed up before any edit.
ensure_block() {
  local file="$1" line="$2"
  local desired="$DOTFILES_BLOCK_BEGIN
$line
$DOTFILES_BLOCK_END"

  if [[ ! -f "$file" ]]; then
    printf '%s\n' "$desired" > "$file"
    success "created $file with managed block"
    return 0
  fi

  if grep -qxF "$DOTFILES_BLOCK_BEGIN" "$file"; then
    local current
    current="$(awk -v b="$DOTFILES_BLOCK_BEGIN" -v e="$DOTFILES_BLOCK_END" \
      '$0==b{f=1} f{print} $0==e{f=0}' "$file")"
    if [[ "$current" == "$desired" ]]; then
      success "managed block up to date: $file"
      return 0
    fi
    backup_copy "$file"
    # BSD awk rejects newlines in -v values, so the block is passed as
    # three single-line variables and printed line by line.
    awk -v b="$DOTFILES_BLOCK_BEGIN" -v e="$DOTFILES_BLOCK_END" -v l="$line" \
      '$0==b{inblock=1; print b; print l; print e; next}
       $0==e{inblock=0; next}
       !inblock{print}' \
      "$file" > "$file.dotfiles-tmp"
    mv "$file.dotfiles-tmp" "$file"
    success "updated managed block: $file"
  else
    backup_copy "$file"
    printf '\n%s\n' "$desired" >> "$file"
    success "added managed block: $file"
  fi
}

# ------------------------------------------------------------------- brew --

# Put brew on PATH for this script when it is installed but not exported yet.
# Returns non-zero when Homebrew is not installed at all.
ensure_brew_in_path() {
  command -v brew >/dev/null 2>&1 && return 0
  local candidate
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$candidate" ]]; then
      eval "$("$candidate" shellenv)"
      return 0
    fi
  done
  return 1
}
